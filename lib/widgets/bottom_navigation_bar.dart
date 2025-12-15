import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigation_provider.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final UserRole userRole;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    if (userRole == UserRole.client) {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/client/home');
              break;
            case 1:
              context.go('/client/post-request');
              break;
            case 2:
              context.go('/client/dashboard');
              break;
            case 3:
              context.go('/client/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Post Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    } else {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/artisan/dashboard');
              break;
            case 1:
              context.go('/artisan/subscriptions');
              break;
            case 2:
              context.go('/artisan/training');
              break;
            case 3:
              context.go('/artisan/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    }
  }
}

