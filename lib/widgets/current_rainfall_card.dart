import 'package:flutter/material.dart';

class CurrentRainfallCard extends StatelessWidget {
  final double rainfall;

  const CurrentRainfallCard({super.key, required this.rainfall});

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
                const Icon(Icons.water_drop, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Current Rainfall',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${rainfall.toStringAsFixed(1)} mm',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _getRainfallDescription(rainfall),
                style: TextStyle(
                  color: _getRainfallColor(rainfall),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRainfallDescription(double rainfall) {
    if (rainfall < 0.5) {
      return 'No significant rainfall';
    } else if (rainfall < 2.5) {
      return 'Light rain';
    } else if (rainfall < 7.5) {
      return 'Moderate rain';
    } else {
      return 'Heavy rain';
    }
  }

  Color _getRainfallColor(double rainfall) {
    if (rainfall < 0.5) {
      return Colors.grey;
    } else if (rainfall < 2.5) {
      return Colors.lightBlue;
    } else if (rainfall < 7.5) {
      return Colors.blue;
    } else {
      return Colors.indigo;
    }
  }
}
