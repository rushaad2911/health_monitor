import 'package:flutter/material.dart';

class VitalsCard extends StatelessWidget {
  final int heartRate;
  final int spo2;

  const VitalsCard({
    Key? key,
    required this.heartRate,
    required this.spo2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildVitalItem(
              icon: Icons.favorite,
              label: 'Heart Rate',
              value: '$heartRate bpm',
              color: Colors.red,
            ),
            _buildVitalItem(
              icon: Icons.opacity,
              label: 'SpO₂',
              value: '$spo2 %',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: color)),
      ],
    );
  }
}
