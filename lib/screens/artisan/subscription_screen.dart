import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../providers/navigation_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Subscription
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Plan',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Chip(
                          label: const Text('Active'),
                          backgroundColor: Colors.green.shade100,
                          labelStyle: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Professional Plan',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$29.99/month',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildFeatureItem(context, 'Unlimited job postings'),
                    _buildFeatureItem(context, 'Priority in search results'),
                    _buildFeatureItem(context, 'Advanced analytics'),
                    _buildFeatureItem(context, '24/7 support'),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Cancel subscription
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Cancel Subscription'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Available Plans
            Text(
              'Available Plans',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            
            // Basic Plan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Plan',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$9.99/month',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(context, 'Up to 10 job postings/month'),
                    _buildFeatureItem(context, 'Standard search visibility'),
                    _buildFeatureItem(context, 'Basic analytics'),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Subscribe to basic plan
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Choose Plan'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Professional Plan (Current)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Professional Plan',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: const Text('Current'),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$29.99/month',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(context, 'Unlimited job postings'),
                    _buildFeatureItem(context, 'Priority in search results'),
                    _buildFeatureItem(context, 'Advanced analytics'),
                    _buildFeatureItem(context, '24/7 support'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Already subscribed
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Current Plan'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Premium Plan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Plan',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$49.99/month',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(context, 'Unlimited job postings'),
                    _buildFeatureItem(context, 'Top priority in search'),
                    _buildFeatureItem(context, 'Premium analytics & insights'),
                    _buildFeatureItem(context, 'Dedicated account manager'),
                    _buildFeatureItem(context, 'Custom branding'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Subscribe to premium plan
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Upgrade to Premium'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(
        currentIndex: 1,
        userRole: UserRole.artisan,
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

