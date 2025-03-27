class LocationMessage {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;

  LocationMessage({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationMessage.fromMap(Map<String, dynamic> map) {
    return LocationMessage(
      id: map['id'],
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
