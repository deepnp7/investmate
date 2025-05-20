import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stock_market_app/models/stock.dart';
import 'package:stock_market_app/models/company_profile.dart';
import 'package:stock_market_app/models/stock_news.dart';
import 'package:stock_market_app/models/candle_data.dart';
import 'package:stock_market_app/constants/api_constants.dart';

class FinnhubService {
  final String _baseUrl = ApiConstants.baseUrl;
  final String _webSocketUrl = ApiConstants.webSocketUrl;
  final String _apiKey = ApiConstants.apiKey;
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _stocksController = 
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stocksStream => _stocksController.stream;

  // Real-time WebSocket connection
  void connectWebSocket(List<String> symbols) {
    _channel = WebSocketChannel.connect(
      Uri.parse('$_webSocketUrl?token=$_apiKey'),
    );

    for (final symbol in symbols) {
      subscribeSymbol(symbol);
    }

    _channel?.stream.listen(
      (data) {
        final decodedData = jsonDecode(data);
        if (decodedData['type'] == 'trade') {
          final trades = decodedData['data'];
          if (trades != null && trades.isNotEmpty) {
            final latestTrade = trades.last;
            _stocksController.add({
              'symbol': latestTrade['s'],
              'price': latestTrade['p'],
              'volume': latestTrade['v'],
              'timestamp': latestTrade['t'],
            });
          }
        }
      },
      onError: (error) {
        print('WebSocket Error: $error');
        reconnectWebSocket(symbols);
      },
      onDone: () {
        print('WebSocket connection closed');
        reconnectWebSocket(symbols);
      },
    );
  }

  void reconnectWebSocket(List<String> symbols) {
    Future.delayed(Duration(seconds: 5), () {
      connectWebSocket(symbols);
    });
  }

  void subscribeSymbol(String symbol) {
    _channel?.sink.add(jsonEncode({
      'type': 'subscribe',
      'symbol': symbol
    }));
  }

  void unsubscribeSymbol(String symbol) {
    _channel?.sink.add(jsonEncode({
      'type': 'unsubscribe',
      'symbol': symbol
    }));
  }

  void disconnectWebSocket() {
    _channel?.sink.close();
  }

  // REST API endpoints
  Future<Stock> getQuote(String symbol) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data['symbol'] = symbol;
      return Stock.fromJson(data);
    } else {
      throw Exception('Failed to load quote data: ${response.statusCode}');
    }
  }

  Future<CompanyProfile> getCompanyProfile(String symbol) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stock/profile2?symbol=$symbol&token=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return CompanyProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load company profile: ${response.statusCode}');
    }
  }

  Future<List<StockNews>> getCompanyNews(String symbol, {int days = 7}) async {
    final DateTime now = DateTime.now();
    final DateTime to = now;
    final DateTime from = now.subtract(Duration(days: days));

    final String toStr = "${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}";
    final String fromStr = "${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}";

    final response = await http.get(
      Uri.parse('$_baseUrl/company-news?symbol=$symbol&from=$fromStr&to=$toStr&token=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> newsJson = jsonDecode(response.body);
      return newsJson.map((json) => StockNews.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load company news: ${response.statusCode}');
    }
  }

  Future<List<String>> symbolSearch(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=$query&token=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['result'] ?? [];
      return results
          .map<String>((item) => item['symbol'] as String)
          .where((symbol) => symbol.contains(RegExp(r'^[A-Z]+$')))
          .toList();
    } else {
      throw Exception('Failed to search symbols: ${response.statusCode}');
    }
  }

  Future<CandleData> getCandles(
    String symbol, {
    String resolution = 'D',
    required int from,
    required int to,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/stock/candle?symbol=$symbol&resolution=$resolution&from=$from&to=$to&token=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      return CandleData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load candle data: ${response.statusCode}');
    }
  }
}