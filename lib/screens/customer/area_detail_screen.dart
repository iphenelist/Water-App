import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/area_water_data.dart';
import 'components/water_quantity_card.dart';
import 'components/water_quality_card.dart';
import '../../models/customer_data.dart';

class AreaDetailScreen extends StatelessWidget {
  final AreaWaterData areaData;

  const AreaDetailScreen({
    super.key,
    required this.areaData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(areaData.area),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with area info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    areaData.area,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Water Quality & Quantity Information',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getQualityIcon(areaData.overallQualityStatus),
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Overall Quality: ${areaData.overallQualityStatus}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Water Quantity Section
                  const Text(
                    "Water Quantity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  WaterQuantityCard(quantity: areaData.waterQuantity),
                  
                  const SizedBox(height: defaultPadding * 2),
                  
                  // Water Quality Section
                  const Text(
                    "Water Quality Analysis",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  WaterQualityCard(
                    quality: WaterQuality(
                      ph: areaData.ph,
                      turbidity: areaData.turbidity,
                      contaminationLevel: areaData.contaminationLevel,
                    ),
                  ),
                  
                  const SizedBox(height: defaultPadding * 2),
                  
                  // Additional Information
                  _buildInfoSection(),
                  
                  const SizedBox(height: defaultPadding * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Additional Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Last Updated',
            _formatDateTime(areaData.lastUpdated),
            Icons.access_time,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'pH Status',
            areaData.phStatus,
            Icons.science,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Turbidity Level',
            areaData.turbidityStatus,
            Icons.opacity,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Contamination Level',
            areaData.contaminationStatus,
            Icons.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  IconData _getQualityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return Icons.check_circle;
      case 'fair':
        return Icons.warning;
      case 'poor':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
