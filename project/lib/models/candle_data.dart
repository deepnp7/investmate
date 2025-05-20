class CandleData {
  final List<int> timestamps;
  final List<double> opens;
  final List<double> highs;
  final List<double> lows;
  final List<double> closes;
  final List<int> volumes;
  final String status;

  CandleData({
    required this.timestamps,
    required this.opens,
    required this.highs,
    required this.lows,
    required this.closes,
    required this.volumes,
    required this.status,
  });

  factory CandleData.fromJson(Map<String, dynamic> json) {
    return CandleData(
      timestamps: List<int>.from(json['t'] ?? []),
      opens: List<double>.from(json['o']?.map((x) => x.toDouble()) ?? []),
      highs: List<double>.from(json['h']?.map((x) => x.toDouble()) ?? []),
      lows: List<double>.from(json['l']?.map((x) => x.toDouble()) ?? []),
      closes: List<double>.from(json['c']?.map((x) => x.toDouble()) ?? []),
      volumes: List<int>.from(json['v'] ?? []),
      status: json['s'] ?? '',
    );
  }

  List<Map<String, dynamic>> toChartData() {
    List<Map<String, dynamic>> chartData = [];
    
    for (int i = 0; i < timestamps.length; i++) {
      chartData.add({
        'timestamp': timestamps[i],
        'open': opens[i],
        'high': highs[i],
        'low': lows[i],
        'close': closes[i],
        'volume': volumes[i],
      });
    }
    
    return chartData;
  }
}