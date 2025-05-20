class CompanyProfile {
  final String country;
  final String currency;
  final String exchange;
  final String ipo;
  final double marketCap;
  final String name;
  final String phone;
  final double shareOutstanding;
  final String ticker;
  final String weburl;
  final String logo;
  final String finnhubIndustry;
  final String description;

  CompanyProfile({
    required this.country,
    required this.currency,
    required this.exchange,
    required this.ipo,
    required this.marketCap,
    required this.name,
    required this.phone,
    required this.shareOutstanding,
    required this.ticker,
    required this.weburl,
    required this.logo,
    required this.finnhubIndustry,
    required this.description,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      country: json['country'] ?? '',
      currency: json['currency'] ?? '',
      exchange: json['exchange'] ?? '',
      ipo: json['ipo'] ?? '',
      marketCap: json['marketCapitalization']?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      shareOutstanding: json['shareOutstanding']?.toDouble() ?? 0.0,
      ticker: json['ticker'] ?? '',
      weburl: json['weburl'] ?? '',
      logo: json['logo'] ?? '',
      finnhubIndustry: json['finnhubIndustry'] ?? '',
      description: json['description'] ?? 'No description available',
    );
  }
}