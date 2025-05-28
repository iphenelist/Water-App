import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/water_quality_card.dart';
import '../widgets/water_quantity_card.dart';
import '../widgets/location_card.dart';
import '../widgets/water_flow_control.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final customerData = dataService.customerData;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Location Card
              LocationCard(location: customerData.location),
              const SizedBox(height: 16),
              
              // Water Quantity Card
              WaterQuantityCard(quantity: customerData.waterQuantity),
              const SizedBox(height: 16),
              
              // Water Quality Card
              WaterQualityCard(quality: customerData.waterQuality),
              const SizedBox(height: 16),
              
              // Water Flow Control
              WaterFlowControl(
                isEnabled: customerData.waterFlowEnabled,
                onToggle: () {
                  dataService.toggleWaterFlow();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
