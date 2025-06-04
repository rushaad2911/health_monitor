import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceConnectScreen extends StatefulWidget {
  @override
  State<DeviceConnectScreen> createState() => _DeviceConnectScreenState();
}

class _DeviceConnectScreenState extends State<DeviceConnectScreen> {
  bool _isScanning = false;
  List<BluetoothDevice> _devicesList = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    setState(() {
      _isScanning = true;
      _devicesList.clear();
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!_devicesList.contains(result.device)) {
          setState(() {
            _devicesList.add(result.device);
          });
        }
      }
    });

    await Future.delayed(Duration(seconds: 5));
    FlutterBluePlus.stopScan();

    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to ${device.name}')),
      );
      Navigator.pop(context, device); // Return device back to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect to Device'),
        actions: [
          if (!_isScanning)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: startScan,
              tooltip: 'Rescan',
            )
        ],
      ),
      body: _isScanning
          ? Center(child: CircularProgressIndicator())
          : _devicesList.isEmpty
              ? Center(child: Text('No devices found.'))
              : ListView.builder(
                  itemCount: _devicesList.length,
                  itemBuilder: (context, index) {
                    final device = _devicesList[index];
                    return ListTile(
                      title: Text(
                        device.name.isEmpty ? device.id.toString() : device.name,
                      ),
                      onTap: () => _connectToDevice(device),
                    );
                  },
                ),
    );
  }
}
