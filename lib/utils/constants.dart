// App constants
class AppConstants {
  // API endpoints (to be configured)
  static const String supabaseUrl = 'https://nqszuysyvzsmphrymqxo.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xc3p1eXN5dnpzbXBocnltcXhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2ODQ2MDEsImV4cCI6MjA4MTI2MDYwMX0.mdXHkI1-n1Q3M5c8PSSJM6h0PRXeXppUDY6wt2W0PiU';

  // Storage buckets
  static const String profileImagesBucket = 'profile-images';
  static const String requestImagesBucket = 'request-images';
  static const String portfolioImagesBucket = 'portfolio-images';

  // Notification topics
  static const String clientNotificationsTopic = 'client-notifications';
  static const String artisanNotificationsTopic = 'artisan-notifications';

  // Request statuses
  static const String requestStatusPending = 'pending';
  static const String requestStatusAccepted = 'accepted';
  static const String requestStatusInProgress = 'in_progress';
  static const String requestStatusCompleted = 'completed';
  static const String requestStatusCancelled = 'cancelled';

  // User roles
  static const String userRoleClient = 'client';
  static const String userRoleArtisan = 'artisan';
}
