import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BleService _bluetoothService = BleService();

  BluetoothDevice? _connectedDevice;
  int _heartRate = 0;
  int _spo2 = 0;

  bool _isScanning = false;
  List<BluetoothDevice> _devicesList = [];

  @override
  void initState() {
    super.initState();
  }

  void startScan() async {
    setState(() {
      _isScanning = true;
      _devicesList.clear();
    });

    // Start scanning using the static method on FlutterBluePlus class
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    // Listen to scan results via static getter
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!_devicesList.contains(result.device)) {
          setState(() {
            _devicesList.add(result.device);
          });
        }
      }
    });

    // Wait for scan duration
    await Future.delayed(Duration(seconds: 5));

    // Stop scanning using static method
    FlutterBluePlus.stopScan();

    setState(() {
      _isScanning = false;
    });

    _showDeviceDialog();
  }

  void _showDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Device'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _devicesList.length,
            itemBuilder: (context, index) {
              final device = _devicesList[index];
              return ListTile(
                title: Text(device.name.isEmpty ? device.id.toString() : device.name),
                onTap: () async {
                  await _connectToDevice(device);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      setState(() {
        _connectedDevice = device;
      });
      _listenToVitals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to ${device.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
    }
  }

  void _listenToVitals() {
    if (_connectedDevice == null) return;

    _bluetoothService.listenToHeartRate(_connectedDevice!).listen((bpm) {
      setState(() {
        _heartRate = bpm;
      });
    });

    _bluetoothService.listenToSpO2(_connectedDevice!).listen((spo2) {
      setState(() {
        _spo2 = spo2;
      });
    });
  }

  Future<void> _disconnectDevice() async {
    if (_connectedDevice == null) return;
    await _connectedDevice!.disconnect();
    setState(() {
      _connectedDevice = null;
      _heartRate = 0;
      _spo2 = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          if (_connectedDevice != null)
            IconButton(
              icon: Icon(Icons.bluetooth_disabled),
              onPressed: _disconnectDevice,
              tooltip: 'Disconnect Device',
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isScanning ? null : startScan,
              child: Text(_isScanning ? 'Scanning...' : 'Scan & Connect Device'),
            ),
            SizedBox(height: 30),
            if (_connectedDevice != null) ...[
              Text(
                'Connected to: ${_connectedDevice!.name.isEmpty ? _connectedDevice!.id : _connectedDevice!.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                'Heart Rate: $_heartRate bpm',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 20),
              Text(
                'SpO₂: $_spo2 %',
                style: TextStyle(fontSize: 22),
              ),
            ] else
              Text('No device connected', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
