import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/area_water_data.dart';

class AreaCard extends StatelessWidget {
  final AreaWaterData areaData;
  final VoidCallback? onTap;

  const AreaCard({
    super.key,
    required this.areaData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding / 2),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          areaData.area,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: ${_formatDate(areaData.lastUpdated)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getQualityColor(areaData.overallQualityStatus),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      areaData.overallQualityStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.water_drop,
                      label: 'Water Amount',
                      value: '${areaData.waterQuantity.toStringAsFixed(1)}L',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.science,
                      label: 'pH Level',
                      value: areaData.ph.toStringAsFixed(1),
                      color: _getPhColor(areaData.ph),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.opacity,
                      label: 'Turbidity',
                      value: '${areaData.turbidity.toStringAsFixed(1)} NTU',
                      color: _getTurbidityColor(areaData.turbidity),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.warning,
                      label: 'Contamination',
                      value: '${(areaData.contaminationLevel * 100).toStringAsFixed(1)}%',
                      color: _getContaminationColor(areaData.contaminationLevel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getQualityColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPhColor(double ph) {
    if (ph < 6.5 || ph > 8.5) return Colors.red;
    if (ph < 7.0 || ph > 8.0) return Colors.orange;
    return Colors.green;
  }

  Color _getTurbidityColor(double turbidity) {
    if (turbidity > 4.0) return Colors.red;
    if (turbidity > 1.0) return Colors.orange;
    return Colors.green;
  }

  Color _getContaminationColor(double contamination) {
    if (contamination > 0.5) return Colors.red;
    if (contamination > 0.2) return Colors.orange;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
