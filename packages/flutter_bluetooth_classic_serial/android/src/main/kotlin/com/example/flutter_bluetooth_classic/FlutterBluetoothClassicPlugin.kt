package com.example.flutter_bluetooth_classic

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.content.pm.PackageManager
import android.Manifest
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.util.UUID
import kotlin.concurrent.thread

class FlutterBluetoothClassicPlugin : FlutterPlugin, MethodChannel.MethodCallHandler,
    ActivityAware, PluginRegistry.ActivityResultListener {

    private val TAG = "FBClassicPlugin"

    // channels
    private lateinit var methodChannel: MethodChannel
    private lateinit var discoveryChannel: EventChannel
    private lateinit var dataChannel: EventChannel
    private lateinit var stateChannel: EventChannel
    private lateinit var connectionChannel: EventChannel

    // sinks
    private var discoverySink: EventChannel.EventSink? = null
    private var dataSink: EventChannel.EventSink? = null
    private var stateSink: EventChannel.EventSink? = null
    private var connectionSink: EventChannel.EventSink? = null

    // context / activity
    private var context: Context? = null
    private var activity: Activity? = null
    private var activityBinding: ActivityPluginBinding? = null

    // bluetooth
    private val adapter: BluetoothAdapter? get() = BluetoothAdapter.getDefaultAdapter()
    private var discoveryReceiver: BroadcastReceiver? = null
    private var bluetoothStateReceiver: BroadcastReceiver? = null // ✅ state receiver

    // socket/io
    private var socket: BluetoothSocket? = null
    private var inputThread: Thread? = null
    private var outputStream: OutputStream? = null
    private var inputStream: InputStream? = null

    private val mainHandler = Handler(Looper.getMainLooper())

    // pending result when system prompt is shown (for enableBluetooth)
    private var pendingEnableResult: MethodChannel.Result? = null
    private var isEnablingBluetooth: Boolean = false
    private val REQUEST_ENABLE_BT = 1001

    companion object {
        val SPP_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
    }

    // ---------------------------
    // FlutterPlugin lifecycle
    // ---------------------------
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        methodChannel = MethodChannel(binding.binaryMessenger, "flutter_bluetooth_classic/methods")
        methodChannel.setMethodCallHandler(this)

        discoveryChannel = EventChannel(binding.binaryMessenger, "flutter_bluetooth_classic/discovery")
        discoveryChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                discoverySink = events
                startDiscovery()
            }

            override fun onCancel(arguments: Any?) {
                stopDiscovery()
                discoverySink = null
            }
        })

        dataChannel = EventChannel(binding.binaryMessenger, "flutter_bluetooth_classic/onData")
        dataChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                dataSink = events
            }

            override fun onCancel(arguments: Any?) {
                dataSink = null
            }
        })

        stateChannel = EventChannel(binding.binaryMessenger, "flutter_bluetooth_classic/state")
        stateChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                stateSink = events
                emitState()
            }

            override fun onCancel(arguments: Any?) {
                stateSink = null
            }
        })

        connectionChannel = EventChannel(binding.binaryMessenger, "flutter_bluetooth_classic/connection")
        connectionChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                connectionSink = events
            }

            override fun onCancel(arguments: Any?) {
                connectionSink = null
            }
        })

        // Register Bluetooth state change receiver (safe — uses nullable context check inside)
        registerBluetoothStateReceiver()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        stopDiscovery()
        disconnectInternal()
        unregisterBluetoothStateReceiver()
        methodChannel.setMethodCallHandler(null)
        discoveryChannel.setStreamHandler(null)
        dataChannel.setStreamHandler(null)
        stateChannel.setStreamHandler(null)
        connectionChannel.setStreamHandler(null)
        context = null
    }

    // ---------------------------
    // ActivityAware lifecycle
    // ---------------------------
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        activity = null
    }

    // ---------------------------
    // MethodCallHandler
    // ---------------------------
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPairedDevices" -> result.success(getPairedDevices())

            "startDiscovery" -> {
                startDiscovery(); result.success(true)
            }

            "stopDiscovery" -> {
                stopDiscovery(); result.success(true)
            }

            "isBluetoothSupported" -> result.success(adapter != null)

            "isBluetoothEnabled" -> {
                // Some platforms require BLUETOOTH_CONNECT to read state on Android 12+
                val ctx = context
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    if (ctx == null) {
                        result.error("NO_CONTEXT", "Context is null", null)
                        return
                    }
                    if (ActivityCompat.checkSelfPermission(ctx, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
                        result.error("NO_PERMISSION", "BLUETOOTH_CONNECT not granted", null)
                        return
                    }
                }
                result.success(adapter?.isEnabled == true)
            }

            "enableBluetooth" -> {
                handleEnableBluetooth(result)
            }

            "connectInsecure" -> {
                val address = call.argument<String>("address")
                if (address == null) {
                    result.error("NO_ADDR", "address is null", null)
                } else {
                    thread {
                        val ok = connectInsecure(address)
                        mainHandler.post {
                            result.success(ok)
                            if (ok) connectionSink?.success("connected:$address")
                            else connectionSink?.success("failed:$address")
                        }
                    }
                }
            }

            "disconnect" -> {
                thread {
                    disconnectInternal()
                    mainHandler.post {
                        result.success(true)
                        connectionSink?.success("disconnected")
                    }
                }
            }

            "write" -> {
                val data = call.argument<String>("data") ?: ""
                thread {
                    val ok = writeToDevice(data)
                    mainHandler.post { result.success(ok) }
                }
            }

            else -> result.notImplemented()
        }
    }

    // ---------------------------
    // enable Bluetooth flow
    // ---------------------------
    private fun handleEnableBluetooth(result: MethodChannel.Result) {
        val ad = adapter ?: run {
            result.success(false)
            return
        }

        // Already ON
        if (ad.isEnabled) {
            result.success(true)
            return
        }

        // If another request is pending, reject
        if (pendingEnableResult != null) {
            result.error("ALREADY_REQUESTING", "Bluetooth enable pending", null)
            return
        }

        // Android 12+ requires BLUETOOTH_CONNECT permission and Activity for the system dialog
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val ctx = context ?: run {
                Log.e(TAG, "Context is null")
                result.error("NO_CONTEXT", "Context is null", null)
                return
            }

            if (ActivityCompat.checkSelfPermission(ctx, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
                Log.e(TAG, "BLUETOOTH_CONNECT not granted")
                result.error("NO_PERMISSION", "BLUETOOTH_CONNECT not granted", null)
                return
            }

            val act = activity ?: run {
                Log.e(TAG, "Activity is null - cannot show enable dialog")
                result.error("NO_ACTIVITY", "Activity is null", null)
                return
            }

            // mark pending and launch system dialog
            pendingEnableResult = result
            try {
                val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                act.startActivityForResult(intent, REQUEST_ENABLE_BT)
            } catch (e: Exception) {
                Log.e(TAG, "startActivityForResult failed: ${e.message}")
                pendingEnableResult = null
                result.success(false)
            }
            return
        }

        // Android < 12: attempt silent enable (legacy)
        try {
            val ok = ad.enable()
            result.success(ok)
        } catch (e: Exception) {
            Log.e(TAG, "enableBluetooth silent failed: ${e.message}")
            result.success(false)
        }
    }

    // ---------------------------
    // ActivityResultListener
    // ---------------------------
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_ENABLE_BT) {
            val enabled = adapter?.isEnabled == true
            pendingEnableResult?.let {
                try {
                    it.success(enabled)
                } catch (_: Exception) {}
                pendingEnableResult = null
            }
            return true
        }
        return false
    }

    // ---------------------------
    // Bluetooth state listener
    // ---------------------------
    private fun registerBluetoothStateReceiver() {
        if (bluetoothStateReceiver != null) return

        bluetoothStateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == BluetoothAdapter.ACTION_STATE_CHANGED) {
                    val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)
                    val stateString = when (state) {
                        BluetoothAdapter.STATE_ON -> "enabled"
                        BluetoothAdapter.STATE_OFF -> "disabled"
                        BluetoothAdapter.STATE_TURNING_ON -> "turningOn"
                        BluetoothAdapter.STATE_TURNING_OFF -> "turningOff"
                        else -> "unknown"
                    }
                    Log.d(TAG, "Bluetooth state changed → $stateString")
                    mainHandler.post { stateSink?.success(stateString) }
                }
            }
        }

        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        try {
            val ctx = context
            if (ctx == null) {
                Log.w(TAG, "registerBluetoothStateReceiver: context is null, skipping")
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                ctx.registerReceiver(
                    bluetoothStateReceiver,
                    filter,
                    Context.RECEIVER_EXPORTED
                )
            } else {
                ctx.registerReceiver(bluetoothStateReceiver, filter)
            }
            Log.d(TAG, "Bluetooth state receiver registered with proper flags")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to register bluetooth state receiver: ${e.message}")
        }
    }

    private fun unregisterBluetoothStateReceiver() {
        try {
            val ctx = context
            if (ctx == null) {
                Log.w(TAG, "unregisterBluetoothStateReceiver: context null")
                return
            }
            if (bluetoothStateReceiver != null) {
                ctx.unregisterReceiver(bluetoothStateReceiver)
                bluetoothStateReceiver = null
                Log.d(TAG, "Bluetooth state receiver unregistered")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error unregistering bluetooth state receiver: ${e.message}")
        }
    }

    // ---------------------------
    // Bluetooth helper methods
    // ---------------------------
    private fun getPairedDevices(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()
        val ad = adapter ?: return out
        val paired = ad.bondedDevices
        paired?.forEach { d ->
            out.add(mapOf("name" to (d.name ?: ""), "address" to (d.address ?: "")))
        }
        return out
    }

    private fun startDiscovery() {
        val ad = adapter ?: run {
            mainHandler.post { discoverySink?.error("NO_ADAPTER", "Bluetooth adapter not available", null) }
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val ctx = context
            if (ctx == null) {
                mainHandler.post { discoverySink?.error("NO_CONTEXT", "Context null", null) }
                return
            }

            val hasScanPerm = ActivityCompat.checkSelfPermission(
                ctx, Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED

            val hasLocPerm = ActivityCompat.checkSelfPermission(
                ctx, Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED

            if (!hasScanPerm || !hasLocPerm) {
                Log.w(TAG, "Missing BLUETOOTH_SCAN or LOCATION permission, skipping discovery")
                mainHandler.post {
                    discoverySink?.error("NO_PERMISSION", "Missing Bluetooth scan/location permission", null)
                }
                return
            }
        }

        // GPS status check (optional)
        try {
            val lm = context?.getSystemService(Context.LOCATION_SERVICE) as? android.location.LocationManager
            val gpsEnabled = lm?.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER) ?: false
            if (!gpsEnabled) {
                Log.w(TAG, "GPS disabled → discovery may return empty results")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Unable to check GPS: ${e.message}")
        }

        if (discoveryReceiver == null) {
            discoveryReceiver = object : BroadcastReceiver() {
                override fun onReceive(ctx: Context?, intent: Intent?) {
                    val action = intent?.action
                    if (action == BluetoothDevice.ACTION_FOUND) {
                        val device: BluetoothDevice? = intent?.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                        val rssi: Short = intent?.getShortExtra(BluetoothDevice.EXTRA_RSSI, Short.MIN_VALUE) ?: Short.MIN_VALUE
                        device?.let {
                            val map = mapOf(
                                "name" to (it.name ?: ""),
                                "address" to (it.address ?: ""),
                                "rssi" to rssi.toInt()
                            )
                            Log.d(TAG, "Found device: ${it.name} (${it.address})")
                            mainHandler.post { discoverySink?.success(map) }
                        }
                    } else if (action == BluetoothAdapter.ACTION_DISCOVERY_FINISHED) {
                        Log.d(TAG, "Discovery finished")
                        mainHandler.post { discoverySink?.endOfStream() }
                    }
                }
            }

            val filter = IntentFilter().apply {
                addAction(BluetoothDevice.ACTION_FOUND)
                addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
            }

            try {
                val ctx = context
                if (ctx == null) {
                    Log.w(TAG, "register discoveryReceiver: context null")
                } else {
                    ctx.registerReceiver(discoveryReceiver, filter)
                    Log.d(TAG, "Discovery receiver registered")
                }
            } catch (e: Exception) {
                Log.w(TAG, "registerReceiver failed: ${e.message}")
            }
        }

        try {
            if (!ad.isDiscovering) {
                val ok = ad.startDiscovery()
                Log.d(TAG, "Bluetooth discovery started: $ok")
            }
        } catch (e: Exception) {
            Log.w(TAG, "startDiscovery failed: ${e.message}")
        }
    }

    private fun stopDiscovery() {
        try {
            val ad = adapter
            if (ad != null && ad.isDiscovering) ad.cancelDiscovery()
            if (discoveryReceiver != null) {
                try {
                    val ctx = context
                    if (ctx != null) ctx.unregisterReceiver(discoveryReceiver)
                } catch (_: Exception) {}
                discoveryReceiver = null
            }
        } catch (e: Exception) {
            Log.w(TAG, "stopDiscovery error: ${e.message}")
        }
    }

    private fun connectInsecure(address: String): Boolean {
        val ad = adapter ?: return false
        try {
            val device = ad.getRemoteDevice(address)
            if (ad.isDiscovering) ad.cancelDiscovery()
            disconnectInternal()

            var sock: BluetoothSocket? = null
            try {
                sock = device.createInsecureRfcommSocketToServiceRecord(SPP_UUID)
                sock.connect()
            } catch (e: IOException) {
                Log.w(TAG, "connectInsecure failed: ${e.message}")
                try { sock?.close() } catch (_: Exception) {}
                sock = device.createRfcommSocketToServiceRecord(SPP_UUID)
                sock.connect()
            }

            socket = sock
            outputStream = socket?.outputStream
            inputStream = socket?.inputStream
            startReaderThread()
            return true
        } catch (e: Exception) {
            Log.e(TAG, "connectInsecure exception: ${e.message}", e)
            disconnectInternal()
            return false
        }
    }

    private fun disconnectInternal() {
        try { inputThread?.interrupt(); inputThread = null } catch (_: Exception) {}
        try { inputStream?.close(); inputStream = null } catch (_: Exception) {}
        try { outputStream?.close(); outputStream = null } catch (_: Exception) {}
        try { socket?.close(); socket = null } catch (_: Exception) {}
    }

    private fun writeToDevice(data: String): Boolean {
        return try {
            val out = outputStream ?: return false
            synchronized(out) {
                out.write(data.toByteArray())
                out.flush()
            }
            true
        } catch (e: Exception) {
            Log.e(TAG, "writeToDevice error: ${e.message}", e)
            false
        }
    }

    private fun startReaderThread() {
        val input = inputStream ?: return
        try { inputThread?.interrupt() } catch (_: Exception) {}
        inputThread = thread(start = true, name = "bt-read-thread") {
            try {
                val buffer = ByteArray(1024)
                while (!Thread.currentThread().isInterrupted) {
                    val read = try { input.read(buffer) } catch (e: IOException) { -1 }
                    if (read > 0) {
                        val payload = String(buffer, 0, read, Charsets.UTF_8)
                        mainHandler.post { dataSink?.success(mapOf("data" to payload)) }
                    } else break
                }
            } catch (e: Exception) {
                Log.w(TAG, "reader stopped: ${e.message}")
            } finally {
                mainHandler.post { connectionSink?.success("disconnected") }
            }
        }
    }

    private fun emitState() {
        val ad = adapter
        mainHandler.post {
            stateSink?.success(
                if (ad == null) "unsupported"
                else if (ad.isEnabled) "enabled"
                else "disabled"
            )
        }
    }
}
