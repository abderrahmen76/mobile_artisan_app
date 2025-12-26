import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/client_signup_screen.dart';
import '../screens/auth/artisan_signup_screen.dart';
import '../screens/client/home_screen.dart';
import '../screens/client/post_request_screen.dart';
import '../screens/client/client_dashboard_screen.dart';
import '../screens/client/client_profile_screen.dart';
import '../screens/artisan/artisan_dashboard_screen.dart';
import '../screens/artisan/subscription_screen.dart';
import '../screens/artisan/training_screen.dart';
import '../screens/artisan/artisan_profile_screen.dart';

// User role enum
enum UserRole { client, artisan }

// Navigation provider to track user role
final userRoleProvider = StateProvider<UserRole>((ref) => UserRole.client);

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Splash is always the first screen; it will redirect based on role/auth.
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Auth & role selection
      GoRoute(
        path: '/auth/role-select',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup-client',
        builder: (context, state) => const ClientSignupScreen(),
      ),
      GoRoute(
        path: '/auth/signup-artisan',
        builder: (context, state) => const ArtisanSignupScreen(),
      ),
      // Client Routes
      GoRoute(
        path: '/client/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/client/post-request',
        builder: (context, state) => const PostRequestScreen(),
      ),
      GoRoute(
        path: '/client/dashboard',
        builder: (context, state) => const ClientDashboardScreen(),
      ),
      GoRoute(
        path: '/client/profile',
        builder: (context, state) => const ClientProfileScreen(),
      ),
      // Artisan Routes
      GoRoute(
        path: '/artisan/dashboard',
        builder: (context, state) => const ArtisanDashboardScreen(),
      ),
      GoRoute(
        path: '/artisan/subscriptions',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/artisan/training',
        builder: (context, state) => const TrainingScreen(),
      ),
      GoRoute(
        path: '/artisan/profile',
        builder: (context, state) => const ArtisanProfileScreen(),
      ),
    ],
  );
});
