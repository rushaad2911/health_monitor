import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();

  /// Listen to Heart Rate Measurement (UUID: 0x2A37) from device (Service UUID: 0x180D)
  Stream<int> listenToHeartRate(BluetoothDevice device) async* {
    List<BluetoothService> services = await device.discoverServices();
    try {
      final hrService = services.firstWhere(
          (s) => s.uuid.toString().toLowerCase().contains('180d'));
      final hrChar = hrService.characteristics.firstWhere(
          (c) => c.uuid.toString().toLowerCase().contains('2a37'));

      await hrChar.setNotifyValue(true);

      yield* hrChar.value.asyncMap((value) {
        if (value.isNotEmpty) {
          // Flags are in value[0], HR value starts from value[1]
          int bpm = value[1];
          return bpm;
        }
        return 0;
      });
    } catch (e) {
      print('Heart Rate Service/Characteristic not found: $e');
      yield* Stream.empty();
    }
  }

  /// Listen to SpO2 Measurement (UUID: 0x2A5F) from device (Service UUID: 0x1822)
  Stream<int> listenToSpO2(BluetoothDevice device) async* {
    List<BluetoothService> services = await device.discoverServices();
    try {
      final spo2Service = services.firstWhere(
          (s) => s.uuid.toString().toLowerCase().contains('1822'));
      final spo2Char = spo2Service.characteristics.firstWhere(
          (c) => c.uuid.toString().toLowerCase().contains('2a5f'));

      await spo2Char.setNotifyValue(true);

      yield* spo2Char.value.asyncMap((value) {
        if (value.isNotEmpty) {
          int spo2 = value[0];
          return spo2;
        }
        return 0;
      });
    } catch (e) {
      print('SpO2 Service/Characteristic not found: $e');
      yield* Stream.empty();
    }
  }
}
