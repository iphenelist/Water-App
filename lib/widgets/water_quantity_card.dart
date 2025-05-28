import 'package:flutter/material.dart';

class WaterQuantityCard extends StatelessWidget {
  final double quantity;

  const WaterQuantityCard({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    // Calculate fill percentage (assuming max capacity is 1000 liters)
    final fillPercentage = (quantity / 1000).clamp(0.0, 1.0);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Water Quantity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${quantity.toStringAsFixed(1)} liters',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: fillPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getQuantityColor(fillPercentage)),
              minHeight: 20,
            ),
            const SizedBox(height: 8),
            Text(
              'Tank capacity: ${(fillPercentage * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                color: _getQuantityColor(fillPercentage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getQuantityColor(double fillPercentage) {
    if (fillPercentage < 0.2) {
      return Colors.red; // Low
    } else if (fillPercentage < 0.5) {
      return Colors.orange; // Medium
    } else {
      return Colors.green; // High
    }
  }
}
