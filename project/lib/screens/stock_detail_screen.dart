import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/providers/stock_provider.dart';
import 'package:stock_market_app/widgets/stock_chart.dart';
import 'package:stock_market_app/widgets/company_info_card.dart';
import 'package:stock_market_app/widgets/stock_stats.dart';
import 'package:stock_market_app/widgets/news_card.dart';
import 'package:stock_market_app/utils/app_theme.dart';

class StockDetailScreen extends StatefulWidget {
  final String symbol;

  const StockDetailScreen({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  @override
  void initState() {
    super.initState();
    
    // Select this stock to load its details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stockProvider = Provider.of<StockProvider>(context, listen: false);
      stockProvider.selectStock(widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final stock = stockProvider.stocks[widget.symbol];
    final inWatchlist = stockProvider.watchlist.contains(widget.symbol);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        actions: [
          // Add/Remove from watchlist button
          IconButton(
            icon: Icon(
              inWatchlist ? Icons.star : Icons.star_border,
              color: inWatchlist ? Colors.amber : null,
            ),
            onPressed: () {
              if (inWatchlist) {
                stockProvider.removeFromWatchlist(widget.symbol);
              } else {
                stockProvider.addToWatchlist(widget.symbol);
              }
            },
          ),
        ],
      ),
      body: stockProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildDetailContent(stockProvider, stock),
    );
  }

  Widget _buildDetailContent(StockProvider stockProvider, stock) {
    if (stock == null) {
      return const Center(child: Text('Stock data not available'));
    }

    return RefreshIndicator(
      onRefresh: () => stockProvider.fetchStockDetails(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stock price header
          _buildPriceHeader(stock),
          const SizedBox(height: 24),
          
          // Price chart
          if (stockProvider.candleData != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Chart',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: StockChart(
                        candleData: stockProvider.candleData!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          
          // Stock statistics
          StockStats(stock: stock),
          const SizedBox(height: 16),
          
          // Company information
          if (stockProvider.companyProfile != null)
            CompanyInfoCard(
              companyProfile: stockProvider.companyProfile!,
            ),
          const SizedBox(height: 16),
          
          // Latest news
          if (stockProvider.stockNews != null &&
              stockProvider.stockNews!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                    'Latest News',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ...stockProvider.stockNews!
                    .take(5)
                    .map((news) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NewsCard(news: news),
                        ))
                    .toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPriceHeader(stock) {
    final isPositive = stock.priceChange >= 0;
    final changeColor = isPositive
        ? AppColors.gainLight
        : AppColors.lossLight;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company name
        Text(
          stock.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        
        // Current price
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '\$${stock.currentPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: changeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: isPositive ? '+' : '',
                    ),
                    TextSpan(
                      text: '\$${stock.priceChange.abs().toStringAsFixed(2)} ',
                    ),
                    TextSpan(
                      text: '(${isPositive ? '+' : ''}${stock.percentChange.toStringAsFixed(2)}%)',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}