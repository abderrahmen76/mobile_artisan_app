import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/bottom_navigation_bar.dart';

class ArtisanDashboardScreen extends ConsumerWidget {
  const ArtisanDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Disconnect',
            onPressed: () async {
              final service = ref.read(supabaseServiceProvider);
              await service.signOut();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                context.go('/auth/role-select');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Overview
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '24',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            'Active Jobs',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.attach_money_outlined,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$2,450',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            'This Month',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '4.9',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            'Rating',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '156',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            'Clients',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Earnings Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Earnings Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 1),
                                FlSpot(1, 2),
                                FlSpot(2, 1.5),
                                FlSpot(3, 3),
                                FlSpot(4, 2.5),
                                FlSpot(5, 4),
                                FlSpot(6, 3.5),
                              ],
                              isCurved: true,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Recent Jobs
            Text(
              'Recent Jobs',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    title: Text('Job ${index + 1}'),
                    subtitle: Text('Client: John Doe'),
                    trailing: Chip(
                      label: const Text('In Progress'),
                      backgroundColor: Colors.blue.shade100,
                      labelStyle: const TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      // TODO: Navigate to job details
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(
        currentIndex: 0,
        userRole: UserRole.artisan,
      ),
    );
  }
}

