class LogMstSyncModel {
  String? name;
  DateTime? lastUpdate;

  LogMstSyncModel({
    this.name,
    this.lastUpdate,
  });

  /// Convert ke Map untuk simpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // simpan dalam bentuk epoch millis biar gampang di-compare
      'lastUpdate': lastUpdate?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Buat instance dari Map SQLite
  factory LogMstSyncModel.fromMap(Map<String, dynamic> map) {
    return LogMstSyncModel(
      name: map['name'] as String?,
      lastUpdate: map['lastUpdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdate'] as int)
          : null,
    );
  }

  /// Biar gampang di-debug
  @override
  String toString() {
    return 'LogMstSyncModel(name: $name, lastUpdate: $lastUpdate)';
  }
}
