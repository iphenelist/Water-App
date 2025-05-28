import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../models/researcher_data.dart';

class RainfallChartCard extends StatelessWidget {
  final List<RainfallData> rainfallData;

  const RainfallChartCard({super.key, required this.rainfallData});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icons.bar_chart,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Rainfall Trend",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Last 30 Days",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xffe7e8ec),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xffe7e8ec),
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
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= rainfallData.length || value.toInt() < 0) {
                          return const Text('');
                        }
                        final date = rainfallData[value.toInt()].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} mm',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xffe7e8ec)),
                ),
                minX: 0,
                maxX: rainfallData.length.toDouble() - 1,
                minY: 0,
                maxY: _getMaxRainfall() + 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: _createSpots(),
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: primaryColor.withAlpha(77), // 0.3 * 255 = 77 for alpha
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                "Average",
                "${_calculateAverage().toStringAsFixed(1)} mm",
                Icons.calculate,
                Colors.blue,
              ),
              _buildStatCard(
                "Maximum",
                "${_getMaxRainfall().toStringAsFixed(1)} mm",
                Icons.arrow_upward,
                Colors.green,
              ),
              _buildStatCard(
                "Minimum",
                "${_getMinRainfall().toStringAsFixed(1)} mm",
                Icons.arrow_downward,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createSpots() {
    return List.generate(rainfallData.length, (index) {
      return FlSpot(index.toDouble(), rainfallData[index].amount);
    });
  }

  double _getMaxRainfall() {
    double max = 0;
    for (var data in rainfallData) {
      if (data.amount > max) {
        max = data.amount;
      }
    }
    return max.ceilToDouble();
  }

  double _getMinRainfall() {
    if (rainfallData.isEmpty) return 0;
    double min = rainfallData.first.amount;
    for (var data in rainfallData) {
      if (data.amount < min) {
        min = data.amount;
      }
    }
    return min;
  }

  double _calculateAverage() {
    if (rainfallData.isEmpty) return 0;
    double sum = 0;
    for (var data in rainfallData) {
      sum += data.amount;
    }
    return sum / rainfallData.length;
  }
}
