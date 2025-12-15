import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/navigation_provider.dart';
import '../utils/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Decide whether to show onboarding or go directly to main app.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

      // Short splash delay for a smooth experience
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (!hasSeenOnboarding) {
        context.go('/onboarding');
        return;
      }

      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final savedRole = prefs.getString('user_role');

      if (!isLoggedIn) {
        // Not logged in yet → go to role selection/login flow
        context.go('/auth/role-select');
        return;
      }

      // Restore role (default to client if missing)
      if (savedRole == 'artisan') {
        ref.read(userRoleProvider.notifier).state = UserRole.artisan;
      } else {
        ref.read(userRoleProvider.notifier).state = UserRole.client;
      }

      final role = ref.read(userRoleProvider);
      final target =
          role == UserRole.client ? '/client/dashboard' : '/artisan/dashboard';
      context.go(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with soft glow
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.35),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: const Offset(0, 24),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.handyman_rounded,
                  color: Colors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: 32),

              // App name
              Text(
                'ArtisanConnect',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),

              // Tagline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Post your request  →  Artisans contact you',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 96),

              // Loader + version at the bottom
              Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'v1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
