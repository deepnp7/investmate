import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/providers/stock_provider.dart';
import 'package:stock_market_app/screens/stock_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final stockProvider = Provider.of<StockProvider>(context, listen: false);
      stockProvider.searchStocks(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Stocks'),
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by symbol (e.g., AAPL)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          stockProvider.searchStocks('');
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
            ),
          ),

          // Loading indicator
          if (stockProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),

          // Search results
          Expanded(
            child: stockProvider.searchResults.isEmpty
                ? Center(
                    child: _searchController.text.isEmpty
                        ? const Text('Search for stocks by symbol')
                        : const Text('No results found'),
                  )
                : ListView.builder(
                    itemCount: stockProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      final symbol = stockProvider.searchResults[index];
                      final inWatchlist =
                          stockProvider.watchlist.contains(symbol);

                      return ListTile(
                        title: Text(symbol),
                        trailing: IconButton(
                          icon: Icon(
                            inWatchlist ? Icons.star : Icons.star_border,
                            color: inWatchlist ? Colors.amber : null,
                          ),
                          onPressed: () {
                            if (inWatchlist) {
                              stockProvider.removeFromWatchlist(symbol);
                            } else {
                              stockProvider.addToWatchlist(symbol);
                            }
                          },
                        ),
                        onTap: () {
                          // Add to watchlist if not already there
                          if (!inWatchlist) {
                            stockProvider.addToWatchlist(symbol);
                          }
                          
                          // Navigate to stock details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StockDetailScreen(symbol: symbol),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Timer {
  final Duration duration;
  final Function callback;
  bool _isActive = false;

  Timer(this.duration, this.callback) {
    _isActive = true;
    Future.delayed(duration, () {
      _isActive = false;
      callback();
    });
  }

  bool get isActive => _isActive;

  void cancel() {
    _isActive = false;
  }
}