import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ECGChart extends StatelessWidget {
  final List<FlSpot> data;
  const ECGChart({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: false,
            barWidth: 2,
          ),
        ],
      ),
    );
  }
}