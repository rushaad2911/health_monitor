class Vitals {
  final int? id; // optional, assigned by DB
  final String deviceId;
  final int heartRate;
  final int spo2;
  final DateTime timestamp;

  Vitals({
    this.id,
    required this.deviceId,
    required this.heartRate,
    required this.spo2,
    required this.timestamp,
  });

  // From Supabase (Map<String, dynamic>) to Vitals object
  factory Vitals.fromMap(Map<String, dynamic> map) {
    return Vitals(
      id: map['id'] as int?,
      deviceId: map['device_id'] as String,
      heartRate: map['heart_rate'] as int,
      spo2: map['spo2'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  // To Map for inserting/updating DB
  Map<String, dynamic> toMap() {
    return {
      'device_id': deviceId,
      'heart_rate': heartRate,
      'spo2': spo2,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
