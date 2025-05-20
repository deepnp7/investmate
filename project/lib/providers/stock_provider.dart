import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_market_app/models/stock.dart';
import 'package:stock_market_app/models/company_profile.dart';
import 'package:stock_market_app/models/stock_news.dart';
import 'package:stock_market_app/models/candle_data.dart';
import 'package:stock_market_app/services/finnhub_service.dart';

class StockProvider extends ChangeNotifier {
  final FinnhubService _finnhubService = FinnhubService();
  
  // List of stock symbols for watchlist
  List<String> _watchlist = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA'];
  
  // Map to store stock data by symbol
  Map<String, Stock> _stocks = {};
  
  // Currently selected stock for detailed view
  String _selectedSymbol = 'AAPL';
  
  // Company profile for selected stock
  CompanyProfile? _companyProfile;
  
  // News for selected stock
  List<StockNews>? _stockNews;
  
  // Candle data for charts
  CandleData? _candleData;
  
  // Search results
  List<String> _searchResults = [];
  
  // Stream subscription for real-time updates
  StreamSubscription? _stockSubscription;
  
  bool _isLoading = false;
  String _error = '';

  StockProvider() {
    _initWatchlist();
  }

  // Getters
  List<String> get watchlist => _watchlist;
  Map<String, Stock> get stocks => _stocks;
  String get selectedSymbol => _selectedSymbol;
  CompanyProfile? get companyProfile => _companyProfile;
  List<StockNews>? get stockNews => _stockNews;
  CandleData? get candleData => _candleData;
  List<String> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Initialize watchlist from shared preferences
  Future<void> _initWatchlist() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedWatchlist = prefs.getStringList('watchlist');
      
      if (savedWatchlist != null && savedWatchlist.isNotEmpty) {
        _watchlist = savedWatchlist;
      }
      
      // Initialize websocket connection
      _connectWebSocket();
      
      // Load initial stock data
      await fetchAllStocks();
    } catch (e) {
      _setError('Failed to initialize: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Connect to WebSocket for real-time updates
  void _connectWebSocket() {
    _finnhubService.connectWebSocket(_watchlist);
    
    _stockSubscription = _finnhubService.stocksStream.listen((data) {
      final symbol = data['symbol'];
      final price = data['price']?.toDouble();
      
      if (_stocks.containsKey(symbol) && price != null) {
        final stock = _stocks[symbol]!;
        
        // Calculate new price changes
        final priceChange = price - stock.previousClose;
        final percentChange = stock.previousClose > 0 
            ? (priceChange / stock.previousClose * 100) 
            : 0.0;
        
        // Update stock data with new price
        _stocks[symbol] = stock.copyWith(
          currentPrice: price,
          priceChange: priceChange,
          percentChange: percentChange,
        );
        
        notifyListeners();
      }
    });
  }

  // Fetch all stocks in watchlist
  Future<void> fetchAllStocks() async {
    _setLoading(true);
    
    try {
      for (final symbol in _watchlist) {
        final stock = await _finnhubService.getQuote(symbol);
        _stocks[symbol] = stock;
      }
    } catch (e) {
      _setError('Failed to fetch stocks: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Select a stock for detailed view
  Future<void> selectStock(String symbol) async {
    if (_selectedSymbol == symbol) return;
    
    _selectedSymbol = symbol;
    _companyProfile = null;
    _stockNews = null;
    _candleData = null;
    
    notifyListeners();
    
    await fetchStockDetails();
  }

  // Fetch details for selected stock
  Future<void> fetchStockDetails() async {
    _setLoading(true);
    
    try {
      // Fetch company profile
      _companyProfile = await _finnhubService.getCompanyProfile(_selectedSymbol);
      
      // Fetch news
      _stockNews = await _finnhubService.getCompanyNews(_selectedSymbol);
      
      // Fetch candle data for chart (last 30 days)
      final now = DateTime.now();
      final to = (now.millisecondsSinceEpoch / 1000).round();
      final from = (now.subtract(const Duration(days: 30)).millisecondsSinceEpoch / 1000).round();
      
      _candleData = await _finnhubService.getCandles(
        _selectedSymbol,
        from: from,
        to: to,
      );
    } catch (e) {
      _setError('Failed to fetch stock details: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search for stocks
  Future<void> searchStocks(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    
    try {
      _searchResults = await _finnhubService.symbolSearch(query);
    } catch (e) {
      _setError('Search failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add stock to watchlist
  Future<void> addToWatchlist(String symbol) async {
    if (_watchlist.contains(symbol)) return;
    
    _watchlist.add(symbol);
    
    // Subscribe to real-time updates
    _finnhubService.subscribeSymbol(symbol);
    
    // Fetch initial data for this stock
    try {
      final stock = await _finnhubService.getQuote(symbol);
      _stocks[symbol] = stock;
    } catch (e) {
      _setError('Failed to add stock: $e');
    }
    
    // Save to shared preferences
    _saveWatchlist();
    
    notifyListeners();
  }

  // Remove stock from watchlist
  Future<void> removeFromWatchlist(String symbol) async {
    if (!_watchlist.contains(symbol)) return;
    
    _watchlist.remove(symbol);
    _stocks.remove(symbol);
    
    // Unsubscribe from real-time updates
    _finnhubService.unsubscribeSymbol(symbol);
    
    // Save to shared preferences
    _saveWatchlist();
    
    notifyListeners();
  }

  // Save watchlist to shared preferences
  Future<void> _saveWatchlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('watchlist', _watchlist);
    } catch (e) {
      _setError('Failed to save watchlist: $e');
    }
  }

  // Update loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Update error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Clear current error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _stockSubscription?.cancel();
    _finnhubService.disconnectWebSocket();
    super.dispose();
  }
}