import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_app/models/candle_data.dart';
import 'package:stock_market_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class StockChart extends StatelessWidget {
  final CandleData candleData;

  const StockChart({
    Key? key,
    required this.candleData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chartData = candleData.toChartData();
    
    if (chartData.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }

    // Find min and max for Y axis
    double minY = double.infinity;
    double maxY = -double.infinity;
    
    for (final point in chartData) {
      if (point['low'] < minY) minY = point['low'];
      if (point['high'] > maxY) maxY = point['high'];
    }
    
    // Add some padding to Y axis
    final yRange = maxY - minY;
    minY = minY - (yRange * 0.05);
    maxY = maxY + (yRange * 0.05);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: (maxY - minY) / 5,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDarkMode 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade300,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: chartData.length > 20 
                  ? (chartData.length / 5).ceil().toDouble() 
                  : 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= chartData.length) {
                  return const SizedBox.shrink();
                }
                
                final timestamp = chartData[value.toInt()]['timestamp'];
                final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    DateFormat('MM/dd').format(date),
                    style: TextStyle(
                      color: isDarkMode 
                          ? Colors.grey.shade400 
                          : Colors.grey.shade700,
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
              interval: (maxY - minY) / 5,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isDarkMode 
                          ? Colors.grey.shade400 
                          : Colors.grey.shade700,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade300,
              width: 1,
            ),
            left: BorderSide(
              color: isDarkMode 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        minX: 0,
        maxX: chartData.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDarkMode
                ? Colors.grey.shade800
                : Colors.white,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index < 0 || index >= chartData.length) {
                  return null;
                }
                
                final data = chartData[index];
                final timestamp = data['timestamp'];
                final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                
                return LineTooltipItem(
                  '${DateFormat('MMM dd, yyyy').format(date)}\n',
                  TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Open: \$${data['open'].toStringAsFixed(2)}\n',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'Close: \$${data['close'].toStringAsFixed(2)}\n',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'High: \$${data['high'].toStringAsFixed(2)}\n',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: 'Low: \$${data['low'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(chartData.length, (index) {
              return FlSpot(index.toDouble(), chartData[index]['close']);
            }),
            isCurved: true,
            curveSmoothness: 0.2,
            color: Theme.of(context).colorScheme.secondary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}