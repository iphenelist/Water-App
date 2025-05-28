import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/customer_data.dart';

class WaterQualityCard extends StatelessWidget {
  final WaterQuality quality;

  const WaterQualityCard({super.key, required this.quality});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Water Quality",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          _buildQualityItem(
            context,
            "pH Level",
            "${quality.ph}",
            _getPhQualityColor(quality.ph),
            Icons.science,
          ),
          const SizedBox(height: 8),
          _buildQualityItem(
            context,
            "Turbidity",
            "${quality.turbidity} NTU",
            _getTurbidityQualityColor(quality.turbidity),
            Icons.opacity,
          ),
          const SizedBox(height: 8),
          _buildQualityItem(
            context,
            "Contamination",
            "${quality.contaminationLevel} ppm",
            _getContaminationQualityColor(quality.contaminationLevel),
            Icons.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildQualityItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: lightTextColor,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getQualityText(label, color),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _getQualityText(String label, Color color) {
    if (color == Colors.green) {
      return "Good";
    } else if (color == Colors.orange) {
      return "Fair";
    } else {
      return "Poor";
    }
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
