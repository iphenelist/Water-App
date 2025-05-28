import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../services/data_service.dart';

class CurrentRainfallCard extends StatelessWidget {
  final double rainfall;

  const CurrentRainfallCard({super.key, required this.rainfall});

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
                  color: _getRainfallColor(rainfall).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.water_drop,
                  color: _getRainfallColor(rainfall),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Current Rainfall",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => _showUpdateRainfallDialog(context),
                icon: const Icon(Icons.edit, color: primaryColor, size: 20),
                tooltip: "Update rainfall data",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${rainfall.toStringAsFixed(1)} mm",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _getRainfallColor(rainfall),
                    ),
                  ),
                  Text(
                    _getRainfallDescription(rainfall),
                    style: TextStyle(
                      color: _getRainfallColor(rainfall),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getRainfallColor(rainfall).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getRainfallIcon(rainfall),
                  color: _getRainfallColor(rainfall),
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getRainfallInfo(rainfall),
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateRainfallDialog(BuildContext context) {
    final TextEditingController rainfallController = TextEditingController();
    rainfallController.text = rainfall.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Current Rainfall'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the current rainfall amount in millimeters:'),
              const SizedBox(height: 16),
              TextField(
                controller: rainfallController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Rainfall (mm)',
                  border: OutlineInputBorder(),
                  suffixText: 'mm',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newRainfall = double.tryParse(rainfallController.text);
                if (newRainfall != null && newRainfall >= 0) {
                  final dataService = Provider.of<DataService>(
                    context,
                    listen: false,
                  );
                  dataService.updateCurrentRainfall(newRainfall);
                  Navigator.of(context).pop();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Rainfall updated to ${newRainfall.toStringAsFixed(1)} mm',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid rainfall amount'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  String _getRainfallDescription(double rainfall) {
    if (rainfall < 0.5) {
      return "No significant rainfall";
    } else if (rainfall < 2.5) {
      return "Light rain";
    } else if (rainfall < 7.5) {
      return "Moderate rain";
    } else {
      return "Heavy rain";
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

  IconData _getRainfallIcon(double rainfall) {
    if (rainfall < 0.5) {
      return Icons.wb_sunny;
    } else if (rainfall < 2.5) {
      return Icons.grain;
    } else if (rainfall < 7.5) {
      return Icons.water_drop;
    } else {
      return Icons.thunderstorm;
    }
  }

  String _getRainfallInfo(double rainfall) {
    if (rainfall < 0.5) {
      return "Dry conditions. No significant precipitation expected.";
    } else if (rainfall < 2.5) {
      return "Light rain. Minimal impact on water systems.";
    } else if (rainfall < 7.5) {
      return "Moderate rain. Water systems may see increased flow.";
    } else {
      return "Heavy rain. Monitor water systems for potential overflow.";
    }
  }
}
