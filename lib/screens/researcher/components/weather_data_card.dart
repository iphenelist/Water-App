import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../models/researcher_data.dart';
import '../../../services/data_service.dart';

class WeatherDataCard extends StatelessWidget {
  final WeatherData weatherData;
  final VoidCallback? onTap;

  const WeatherDataCard({super.key, required this.weatherData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding / 2),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap ?? () => _showEditDialog(context),
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
                          _formatDate(weatherData.date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                weatherData.area,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit,
                    color: primaryColor.withOpacity(0.7),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (weatherData.rainfall != null) ...[
                    _buildDataItem(
                      icon: Icons.water_drop,
                      label: 'Rainfall',
                      value: '${weatherData.rainfall!.toStringAsFixed(1)} mm',
                      color: Colors.blue,
                    ),
                    if (weatherData.temperature != null)
                      const SizedBox(width: 20),
                  ],
                  if (weatherData.temperature != null)
                    _buildDataItem(
                      icon: Icons.thermostat,
                      label: 'Temperature',
                      value: '${weatherData.temperature!.toStringAsFixed(1)}°C',
                      color: _getTemperatureColor(weatherData.temperature!),
                    ),
                ],
              ),
              if (weatherData.notes != null &&
                  weatherData.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          weatherData.notes!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 0) return Colors.blue;
    if (temperature < 10) return Colors.lightBlue;
    if (temperature < 20) return Colors.green;
    if (temperature < 30) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController areaController = TextEditingController();
    final TextEditingController rainfallController = TextEditingController();
    final TextEditingController temperatureController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    areaController.text = weatherData.area;
    rainfallController.text = weatherData.rainfall?.toString() ?? '';
    temperatureController.text = weatherData.temperature?.toString() ?? '';
    notesController.text = weatherData.notes ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Weather Data - ${_formatDate(weatherData.date)}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Research Area',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'e.g., Downtown District, Rural Valley',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
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
                const SizedBox(height: 16),
                TextField(
                  controller: temperatureController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Temperature (°C)',
                    border: OutlineInputBorder(),
                    suffixText: '°C',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Add any additional observations...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _deleteWeatherData(context),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed:
                  () => _updateWeatherData(
                    context,
                    areaController,
                    rainfallController,
                    temperatureController,
                    notesController,
                  ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateWeatherData(
    BuildContext context,
    TextEditingController areaController,
    TextEditingController rainfallController,
    TextEditingController temperatureController,
    TextEditingController notesController,
  ) {
    final area = areaController.text.trim();
    final rainfall = double.tryParse(rainfallController.text);
    final temperature = double.tryParse(temperatureController.text);
    final notes = notesController.text.trim();

    if (area.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a research area'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (rainfall == null && temperature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least rainfall or temperature data'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedData = weatherData.copyWith(
      area: area,
      rainfall: rainfall,
      temperature: temperature,
      notes: notes.isEmpty ? null : notes,
    );

    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.updateWeatherData(updatedData);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Weather data updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteWeatherData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Weather Data'),
          content: const Text(
            'Are you sure you want to delete this weather data entry?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final dataService = Provider.of<DataService>(
                  context,
                  listen: false,
                );
                dataService.deleteWeatherData(weatherData.id!);
                Navigator.of(context).pop(); // Close delete dialog
                Navigator.of(context).pop(); // Close edit dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Weather data deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
