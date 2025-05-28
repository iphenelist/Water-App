import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/researcher_data.dart';
import 'package:intl/intl.dart';

class RainfallChart extends StatelessWidget {
  final List<RainfallData> rainfallData;

  const RainfallChart({super.key, required this.rainfallData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 5,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= rainfallData.length ||
                      value.toInt() < 0) {
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
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: rainfallData.length.toDouble() - 1,
          minY: 0,
          maxY: _getMaxRainfall() + 1,
          lineBarsData: [
            LineChartBarData(
              spots: _createSpots(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withAlpha(77), // 0.3 * 255 = 77 for alpha
              ),
            ),
          ],
        ),
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
}
