import 'package:flutter/material.dart';
import 'package:stock_market_app/models/stock_news.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final StockNews news;

  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Format timestamp to readable date
    final date = DateTime.fromMillisecondsSinceEpoch(news.datetime * 1000);
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          // In a real app, we would open the news URL
          // But for demo purposes, we'll just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening news: ${news.headline}'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News source and date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      news.source,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // News headline
              Text(
                news.headline,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // News summary
              if (news.summary.isNotEmpty)
                Text(
                  news.summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              
              // Tags/category
              if (news.category.isNotEmpty) 
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          news.category,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}