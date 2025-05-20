import 'package:flutter/material.dart';
import 'package:stock_market_app/models/company_profile.dart';

class CompanyInfoCard extends StatelessWidget {
  final CompanyProfile companyProfile;

  const CompanyInfoCard({
    Key? key,
    required this.companyProfile,
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
              'Company Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Company description
            Text(
              companyProfile.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // Company details in grid
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildInfoItem(context, 'Industry', companyProfile.finnhubIndustry),
                _buildInfoItem(context, 'Country', companyProfile.country),
                _buildInfoItem(context, 'Exchange', companyProfile.exchange),
                _buildInfoItem(context, 'Currency', companyProfile.currency),
                _buildInfoItem(context, 'IPO Date', companyProfile.ipo),
                _buildInfoItem(
                  context, 
                  'Market Cap', 
                  '\$${(companyProfile.marketCap * 1000000).toStringAsFixed(0)}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Company website button
            if (companyProfile.weburl.isNotEmpty)
              OutlinedButton.icon(
                icon: const Icon(Icons.language),
                label: const Text('Visit Website'),
                onPressed: () {
                  // In a real app, we would open the URL
                  // But for demo purposes, we'll just show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${companyProfile.weburl}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
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
          value.isEmpty ? 'N/A' : value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}