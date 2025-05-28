import 'package:flutter/material.dart';

class WaterFlowControl extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onToggle;

  const WaterFlowControl({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isEnabled ? Icons.water_drop : Icons.water_drop_outlined,
                  color: isEnabled ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Water Flow Control',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEnabled ? 'Water flow is ON' : 'Water flow is OFF',
                  style: TextStyle(
                    color: isEnabled ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (_) => onToggle(),
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isEnabled
                  ? 'Water is currently flowing into the tank'
                  : 'Water flow to the tank is stopped',
              style: TextStyle(
                color: isEnabled ? Colors.blue[700] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
