import 'dart:convert';

class ProcessBluetoothBufferUseCase {
  const ProcessBluetoothBufferUseCase();

  BluetoothParsedResult execute(StringBuffer buffer) {
    var foundCompleteJson = false;
    Map<String, dynamic>? parsedJson;
    final results = BluetoothParsedResult();

    while (true) {
      final current = buffer.toString();
      final endIndex = current.indexOf('}');
      if (endIndex == -1) break;

      final jsonString = current.substring(0, endIndex + 1);

      try {
        final data = json.decode(jsonString);
        if (data is Map<String, dynamic>) {
          parsedJson = data;
          foundCompleteJson = true;

          // 🔹 evaluasi hasil
          if (data.containsKey("sn") && data.containsKey("template")) {
            results.insertTemplates.add(data);
          }

          if (data.containsKey("result")) {
            results.resultCount++;
          }

          if (data.containsKey("perintah")) {
            results.done = true;
          }

          if (data.containsKey("sn") && data.containsKey("sensor")) {
            results.handshakeOk = true;
            results.deviceInfo = data;
          }

          if (data["validate"] == "incorrect") {
            results.incorrect = true;
          }
        }
      } catch (_) {
        // abaikan error json parse
      } finally {
        buffer.clear();
      }

      final remaining = current.substring(endIndex + 1).trimLeft();
      buffer = StringBuffer(remaining);
    }

    results.hasValidJson = foundCompleteJson;
    results.parsedJson = parsedJson;
    return results;
  }
}

/// Model hasil parsing
class BluetoothParsedResult {
  bool hasValidJson = false;
  bool done = false;
  bool handshakeOk = false;
  bool incorrect = false;
  int resultCount = 0;
  List<Map<String, dynamic>> insertTemplates = [];
  Map<String, dynamic>? deviceInfo;
  Map<String, dynamic>? parsedJson;
}
