class BluetoothDeviceEntity {
  final String name;
  final String address;
  final bool bonded;

  BluetoothDeviceEntity({
    required this.name,
    required this.address,
    required this.bonded,
  });

  factory BluetoothDeviceEntity.fromMap(Map<String, dynamic> map) {
    return BluetoothDeviceEntity(
      name: map['name'] ?? 'Unknown',
      address: map['address'] ?? '',
      bonded: map['bonded'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'bonded': bonded,
    };
  }
}
