import 'package:flutter/material.dart';
import 'package:stock_market_app/models/stock.dart';

class StockStats extends StatelessWidget {
  final Stock stock;

  const StockStats({
    Key? key,
    required this.stock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatItem(
                  context, 
                  'Previous Close', 
                  '\$${stock.previousClose.toStringAsFixed(2)}',
                ),
                _buildStatItem(
                  context, 
                  'Open', 
                  '\$${stock.currentPrice.toStringAsFixed(2)}',
                ),
                _buildStatItem(
                  context, 
                  'Day\'s High', 
                  '\$${stock.high.toStringAsFixed(2)}',
                ),
                _buildStatItem(
                  context, 
                  'Day\'s Low', 
                  '\$${stock.low.toStringAsFixed(2)}',
                ),
                _buildStatItem(
                  context, 
                  'Volume', 
                  _formatVolume(stock.volume),
                ),
                _buildStatItem(
                  context, 
                  'Market Cap', 
                  '\$${(stock.marketCap * 1000000).toStringAsFixed(0)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  String _formatVolume(int volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(2)}B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(2)}K';
    }
    return volume.toString();
  }
}