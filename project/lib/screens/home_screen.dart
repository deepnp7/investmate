import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/providers/auth_provider.dart';
import 'package:stock_market_app/providers/stock_provider.dart';
import 'package:stock_market_app/providers/theme_provider.dart';
import 'package:stock_market_app/screens/login_screen.dart';
import 'package:stock_market_app/screens/search_screen.dart';
import 'package:stock_market_app/screens/stock_detail_screen.dart';
import 'package:stock_market_app/widgets/stock_card.dart';
import 'package:stock_market_app/widgets/market_overview.dart';
import 'package:stock_market_app/widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    
    // Fetch stock data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stockProvider = Provider.of<StockProvider>(context, listen: false);
      stockProvider.fetchAllStocks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockMarket Pro'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          // User profile menu
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Logged in as ${authProvider.username}'),
                enabled: false,
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Watchlist'),
            Tab(text: 'Markets'),
            Tab(text: 'News'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Watchlist Tab
          _buildWatchlistTab(stockProvider),
          
          // Markets Tab
          _buildMarketsTab(),
          
          // News Tab
          _buildNewsTab(stockProvider),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildWatchlistTab(StockProvider stockProvider) {
    if (stockProvider.isLoading && stockProvider.stocks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (stockProvider.watchlist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Your watchlist is empty',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add stocks',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => stockProvider.fetchAllStocks(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stockProvider.watchlist.length,
        itemBuilder: (context, index) {
          final symbol = stockProvider.watchlist[index];
          final stock = stockProvider.stocks[symbol];
          
          if (stock == null) {
            return const SizedBox.shrink(); // Skip if stock data not available yet
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StockCard(
              stock: stock,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockDetailScreen(symbol: symbol),
                  ),
                );
              },
              onLongPress: () {
                _showRemoveDialog(context, stockProvider, symbol);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarketsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarketOverview(),
        ],
      ),
    );
  }

  Widget _buildNewsTab(StockProvider stockProvider) {
    // For the news tab, we'll show news from the first stock in the watchlist
    if (stockProvider.watchlist.isEmpty || stockProvider.stockNews == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stockProvider.stockNews?.length ?? 0,
      itemBuilder: (context, index) {
        final news = stockProvider.stockNews![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NewsCard(news: news),
        );
      },
    );
  }

  void _showRemoveDialog(BuildContext context, StockProvider stockProvider, String symbol) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Watchlist'),
        content: Text('Are you sure you want to remove $symbol from your watchlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              stockProvider.removeFromWatchlist(symbol);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}