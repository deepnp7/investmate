class StockNews {
  final String category;
  final int datetime;
  final String headline;
  final int id;
  final String image;
  final String related;
  final String source;
  final String summary;
  final String url;

  StockNews({
    required this.category,
    required this.datetime,
    required this.headline,
    required this.id,
    required this.image,
    required this.related,
    required this.source,
    required this.summary,
    required this.url,
  });

  factory StockNews.fromJson(Map<String, dynamic> json) {
    return StockNews(
      category: json['category'] ?? '',
      datetime: json['datetime'] ?? 0,
      headline: json['headline'] ?? '',
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      related: json['related'] ?? '',
      source: json['source'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
    );
  }
}