package com.example.flutter_bluetooth_classic

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.util.UUID
import kotlin.concurrent.thread

class FlutterBluetoothClassicPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
    private val TAG = "FBClassicPlugin"

    private lateinit var channel: MethodChannel
    private lateinit var discoveryChannel: EventChannel
    private lateinit var dataChannel: EventChannel
    private lateinit var stateChannel: EventChannel
    private lateinit var connectionChannel: EventChannel

    private var discoverySink: EventChannel.EventSink? = null
    private var dataSink: EventChannel.EventSink? = null
    private var stateSink: EventChannel.EventSink? = null
    private var connectionSink: EventChannel.EventSink? = null

    private var context: Context? = null
    private val adapter: BluetoothAdapter? get() = BluetoothAdapter.getDefaultAdapter()
    private var discoveryReceiver: BroadcastReceiver? = null

    private var socket: BluetoothSocket? = null
    private var inputThread: Thread? = null
    private var outputStream: OutputStream? = null
    private var inputStream: InputStream? = null

    private val mainHandler = Handler(Looper.getMainLooper())

    companion object {
        val SPP_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        channel = MethodChannel(binding.binaryMessenger, "flutter_bluetooth_classic/methods")
        channel.setMethodCallHandler(this)

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
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        stopDiscovery()
        disconnectInternal()
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPairedDevices" -> result.success(getPairedDevices())
            "startDiscovery" -> { startDiscovery(); result.success(true) }
            "stopDiscovery" -> { stopDiscovery(); result.success(true) }
            "connectInsecure" -> {
                val address = call.argument<String>("address")
                if (address == null) result.error("NO_ADDR", "address is null", null)
                else thread {
                    val ok = connectInsecure(address)
                    mainHandler.post {
                        result.success(ok)
                        if (ok) connectionSink?.success("connected:$address")
                        else connectionSink?.success("failed:$address")
                    }
                }
            }
            "disconnect" -> {
                disconnectInternal()
                mainHandler.post {
                    result.success(true)
                    connectionSink?.success("disconnected")
                }
            }
            "write" -> {
                val data = call.argument<String>("data") ?: ""
                result.success(writeToDevice(data))
            }
            "isBluetoothSupported" -> result.success(adapter != null)
            "isBluetoothEnabled" -> result.success(adapter?.isEnabled == true)
            else -> result.notImplemented()
        }
    }

    private fun getPairedDevices(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()
        val ad = adapter ?: return out
        ad.bondedDevices?.forEach { d ->
            out.add(mapOf("name" to (d.name ?: ""), "address" to (d.address ?: "")))
        }
        return out
    }

    private fun startDiscovery() {
        val ad = adapter ?: run {
            mainHandler.post { discoverySink?.error("NO_ADAPTER", "Bluetooth adapter not available", null) }
            return
        }

        if (discoveryReceiver == null) {
            discoveryReceiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
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
                            mainHandler.post { discoverySink?.success(map) }
                        }
                    } else if (action == BluetoothAdapter.ACTION_DISCOVERY_FINISHED) {
                        mainHandler.post { discoverySink?.endOfStream() }
                    }
                }
            }
            val filter = IntentFilter().apply {
                addAction(BluetoothDevice.ACTION_FOUND)
                addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
            }
            context?.registerReceiver(discoveryReceiver, filter)
        }

        if (!ad.isDiscovering) ad.startDiscovery()
    }

    private fun stopDiscovery() {
        try {
            val ad = adapter
            if (ad != null && ad.isDiscovering) ad.cancelDiscovery()
            if (discoveryReceiver != null) {
                context?.unregisterReceiver(discoveryReceiver)
                discoveryReceiver = null
            }
        } catch (e: IllegalArgumentException) {
            Log.w(TAG, "stopDiscovery: ${e.message}")
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
        try { inputStream?.close() } catch (_: Exception) {}
        try { outputStream?.close() } catch (_: Exception) {}
        try { socket?.close(); socket = null } catch (_: Exception) {}
    }

    private fun writeToDevice(data: String): Boolean {
        return try {
            val out = outputStream ?: return false
            out.write(data.toByteArray())
            out.flush()
            true
        } catch (e: Exception) {
            Log.e(TAG, "writeToDevice error: ${e.message}", e)
            false
        }
    }

    private fun startReaderThread() {
        val input = inputStream ?: return
        inputThread = thread(start = true, name = "bt-read-thread") {
            try {
                val buffer = ByteArray(1024)
                while (!Thread.currentThread().isInterrupted) {
                    val read = input.read(buffer)
                    if (read > 0) {
                        val payload = String(buffer, 0, read, Charsets.UTF_8)
                        mainHandler.post { dataSink?.success(mapOf("data" to payload)) }
                    } else break
                }
            } catch (e: IOException) {
                Log.w(TAG, "reader thread stopped: ${e.message}")
            } finally {
                mainHandler.post { dataSink?.endOfStream() }
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
