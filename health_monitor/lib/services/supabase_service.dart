import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase;

  SupabaseService(String supabaseUrl, String supabaseKey)
      : supabase = SupabaseClient(supabaseUrl, supabaseKey);

  Future<void> insertVitals({
    required String deviceId,
    required int heartRate,
    required int spo2,
  }) async {
    final response = await supabase.from('vitals').insert({
      'device_id': deviceId,
      'heart_rate': heartRate,
      'spo2': spo2,
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (response.error != null) {
      throw Exception('Failed to insert vitals: ${response.error!.message}');
    }
  }
}
