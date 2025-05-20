import 'package:flutter/material.dart';
import 'package:stock_market_app/utils/app_theme.dart';

class MarketOverview extends StatelessWidget {
  const MarketOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Sample market index data
    final marketIndices = [
      {
        'name': 'S&P 500',
        'value': 4,893.31,
        'change': 0.68,
        'isPositive': true,
      },
      {
        'name': 'Dow Jones',
        'value': 38,996.39,
        'change': 1.22,
        'isPositive': true,
      },
      {
        'name': 'Nasdaq',
        'value': 17,482.63,
        'change': 0.34,
        'isPositive': true,
      },
      {
        'name': 'Russell 2000',
        'value': 2,028.97,
        'change': -0.72,
        'isPositive': false,
      },
    ];
    
    // Sample sector performance
    final sectorPerformance = [
      {'name': 'Technology', 'change': 1.8, 'isPositive': true},
      {'name': 'Healthcare', 'change': 0.9, 'isPositive': true},
      {'name': 'Financials', 'change': 0.7, 'isPositive': true},
      {'name': 'Consumer Cyclical', 'change': -0.3, 'isPositive': false},
      {'name': 'Communication', 'change': 1.2, 'isPositive': true},
      {'name': 'Industrials', 'change': 0.5, 'isPositive': true},
      {'name': 'Energy', 'change': -0.8, 'isPositive': false},
      {'name': 'Utilities', 'change': -0.2, 'isPositive': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Indices',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        // Market indices cards
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: marketIndices.length,
          itemBuilder: (context, index) {
            final indexData = marketIndices[index];
            final isPositive = indexData['isPositive'] as bool;
            final changeColor = isPositive
                ? (isDarkMode ? AppColors.gainDark : AppColors.gainLight)
                : (isDarkMode ? AppColors.lossDark : AppColors.lossLight);
                
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      indexData['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${indexData['value']}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: changeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${isPositive ? '+' : ''}${indexData['change']}%',
                            style: TextStyle(
                              color: changeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 32),
        
        Text(
          'Sector Performance',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        
        // Sector performance list
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: sectorPerformance.map((sector) {
                final isPositive = sector['isPositive'] as bool;
                final changeColor = isPositive
                    ? (isDarkMode ? AppColors.gainDark : AppColors.gainLight)
                    : (isDarkMode ? AppColors.lossDark : AppColors.lossLight);
                    
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          sector['name'] as String,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${isPositive ? '+' : ''}${sector['change']}%',
                          style: TextStyle(
                            color: changeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}