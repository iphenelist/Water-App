import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/area_card.dart';
import '../widgets/rainfall_chart.dart';
import '../widgets/current_rainfall_card.dart';

class ResearcherDashboard extends StatelessWidget {
  const ResearcherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final researcherData = dataService.researcherData;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Researcher Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Area Card
              AreaCard(area: researcherData.area),
              const SizedBox(height: 16),
              
              // Current Rainfall Card
              CurrentRainfallCard(rainfall: researcherData.currentRainfall),
              const SizedBox(height: 16),
              
              // Rainfall Chart
              const Text(
                'Rainfall Patterns (Last 30 Days)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: RainfallChart(rainfallData: researcherData.rainfallHistory),
              ),
            ],
          ),
        );
      },
    );
  }
}
