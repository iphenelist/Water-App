import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants.dart';
import '../../../models/researcher_data.dart';

class WeatherSummaryChart extends StatelessWidget {
  final List<WeatherData> weatherData;

  const WeatherSummaryChart({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    if (weatherData.isEmpty) {
      return Card(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(defaultPadding),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No weather data available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add some weather data to see the summary chart',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Summary (Last 30 Days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSummaryStats(),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats() {
    final rainfallData = weatherData.where((data) => data.rainfall != null).toList();
    final temperatureData = weatherData.where((data) => data.temperature != null).toList();

    final totalRainfall = rainfallData.fold<double>(0, (sum, data) => sum + data.rainfall!);
    final avgRainfall = rainfallData.isNotEmpty ? totalRainfall / rainfallData.length : 0.0;
    
    final avgTemperature = temperatureData.isNotEmpty 
        ? temperatureData.fold<double>(0, (sum, data) => sum + data.temperature!) / temperatureData.length
        : 0.0;

    final maxTemp = temperatureData.isNotEmpty 
        ? temperatureData.map((data) => data.temperature!).reduce((a, b) => a > b ? a : b)
        : 0.0;
    
    final minTemp = temperatureData.isNotEmpty 
        ? temperatureData.map((data) => data.temperature!).reduce((a, b) => a < b ? a : b)
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Rainfall',
            '${totalRainfall.toStringAsFixed(1)} mm',
            Icons.water_drop,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Rainfall',
            '${avgRainfall.toStringAsFixed(1)} mm',
            Icons.grain,
            Colors.lightBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Temp',
            '${avgTemperature.toStringAsFixed(1)}°C',
            Icons.thermostat,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final sortedData = List<WeatherData>.from(weatherData)
      ..sort((a, b) => a.date.compareTo(b.date));

    final rainfallSpots = <FlSpot>[];
    final temperatureSpots = <FlSpot>[];

    for (int i = 0; i < sortedData.length; i++) {
      final data = sortedData[i];
      if (data.rainfall != null) {
        rainfallSpots.add(FlSpot(i.toDouble(), data.rainfall!));
      }
      if (data.temperature != null) {
        temperatureSpots.add(FlSpot(i.toDouble(), data.temperature!));
      }
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < sortedData.length) {
                  final date = sortedData[value.toInt()].date;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: (sortedData.length - 1).toDouble(),
        minY: 0,
        maxY: _getMaxY(),
        lineBarsData: [
          if (rainfallSpots.isNotEmpty)
            LineChartBarData(
              spots: rainfallSpots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.8), Colors.blue],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.blue,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          if (temperatureSpots.isNotEmpty)
            LineChartBarData(
              spots: temperatureSpots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.orange.withOpacity(0.8), Colors.orange],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.orange,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  double _getMaxY() {
    double maxRainfall = 0;
    double maxTemperature = 0;

    for (final data in weatherData) {
      if (data.rainfall != null && data.rainfall! > maxRainfall) {
        maxRainfall = data.rainfall!;
      }
      if (data.temperature != null && data.temperature! > maxTemperature) {
        maxTemperature = data.temperature!;
      }
    }

    return (maxRainfall > maxTemperature ? maxRainfall : maxTemperature) + 5;
  }
}
