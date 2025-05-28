import 'package:flutter/material.dart';
import '../models/customer_data.dart';

class WaterQualityCard extends StatelessWidget {
  final WaterQuality quality;

  const WaterQualityCard({super.key, required this.quality});

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
                  'Water Quality',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            _buildQualityItem(
              'pH Level',
              '${quality.ph}',
              _getPhQualityColor(quality.ph),
            ),
            _buildQualityItem(
              'Turbidity',
              '${quality.turbidity} NTU',
              _getTurbidityQualityColor(quality.turbidity),
            ),
            _buildQualityItem(
              'Contamination',
              '${quality.contaminationLevel} ppm',
              _getContaminationQualityColor(quality.contaminationLevel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Chip(
            label: Text(value),
            backgroundColor: color.withAlpha(51), // 0.2 * 255 = 51 for alpha
            labelStyle: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Color _getPhQualityColor(double ph) {
    if (ph >= 6.5 && ph <= 8.5) {
      return Colors.green; // Good
    } else if ((ph >= 6.0 && ph < 6.5) || (ph > 8.5 && ph <= 9.0)) {
      return Colors.orange; // Acceptable
    } else {
      return Colors.red; // Poor
    }
  }

  Color _getTurbidityQualityColor(double turbidity) {
    if (turbidity <= 1.0) {
      return Colors.green; // Good
    } else if (turbidity <= 5.0) {
      return Colors.orange; // Acceptable
    } else {
      return Colors.red; // Poor
    }
  }

  Color _getContaminationQualityColor(double contamination) {
    if (contamination <= 0.3) {
      return Colors.green; // Good
    } else if (contamination <= 0.5) {
      return Colors.orange; // Acceptable
    } else {
      return Colors.red; // Poor
    }
  }
}
