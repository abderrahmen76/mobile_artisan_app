import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_core/firebase_core.dart'; // Commented out if Firebase setup is not ready
import 'package:google_fonts/google_fonts.dart';

import 'providers/navigation_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url:
        'https://nqszuysyvzsmphrymqxo.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xc3p1eXN5dnpzbXBocnltcXhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2ODQ2MDEsImV4cCI6MjA4MTI2MDYwMX0.mdXHkI1-n1Q3M5c8PSSJM6h0PRXeXppUDY6wt2W0PiU', // Replace with your Supabase anon key
  );

  // Initialize Firebase (for FCM) - Commented out if Firebase setup is not ready
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: ArtisanMarketplaceApp(),
    ),
  );
}

class ArtisanMarketplaceApp extends ConsumerWidget {
  const ArtisanMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Artisan Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
