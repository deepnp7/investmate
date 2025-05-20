class Stock {
  final String symbol;
  final String name;
  final String companyLogo;
  final double currentPrice;
  final double previousClose;
  final double priceChange;
  final double percentChange;
  final double high;
  final double low;
  final int volume;
  final double marketCap;

  Stock({
    required this.symbol,
    required this.name,
    required this.companyLogo,
    required this.currentPrice,
    required this.previousClose,
    this.priceChange = 0.0,
    this.percentChange = 0.0,
    this.high = 0.0,
    this.low = 0.0,
    this.volume = 0,
    this.marketCap = 0.0,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    final double currentPrice = json['c']?.toDouble() ?? 0.0;
    final double previousClose = json['pc']?.toDouble() ?? 0.0;
    final double priceChange = currentPrice - previousClose;
    final double percentChange = previousClose > 0 
        ? (priceChange / previousClose * 100) 
        : 0.0;

    return Stock(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      companyLogo: 'https://finnhub.io/api/logo?symbol=${json['symbol']}',
      currentPrice: currentPrice,
      previousClose: previousClose,
      priceChange: priceChange,
      percentChange: percentChange,
      high: json['h']?.toDouble() ?? 0.0,
      low: json['l']?.toDouble() ?? 0.0,
      volume: json['v']?.toInt() ?? 0,
      marketCap: json['marketCapitalization']?.toDouble() ?? 0.0,
    );
  }

  Stock copyWith({
    String? symbol,
    String? name,
    String? companyLogo,
    double? currentPrice,
    double? previousClose,
    double? priceChange,
    double? percentChange,
    double? high,
    double? low,
    int? volume,
    double? marketCap,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      companyLogo: companyLogo ?? this.companyLogo,
      currentPrice: currentPrice ?? this.currentPrice,
      previousClose: previousClose ?? this.previousClose,
      priceChange: priceChange ?? this.priceChange,
      percentChange: percentChange ?? this.percentChange,
      high: high ?? this.high,
      low: low ?? this.low,
      volume: volume ?? this.volume,
      marketCap: marketCap ?? this.marketCap,
    );
  }
}