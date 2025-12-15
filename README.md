# Artisan Service Marketplace - Flutter Mobile App

A Flutter mobile application for connecting clients with artisans for various services.

## Features

### Client Features
- **Home Screen**: Browse services and quick actions
- **Post Request**: Create service requests with detailed information
- **Dashboard**: View and manage active requests
- **Profile**: Manage personal information and settings

### Artisan Features
- **Dashboard**: View statistics, earnings, and recent jobs
- **Subscriptions**: Manage subscription plans
- **Training**: Access training courses and track progress
- **Profile**: Manage business information and portfolio

## Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL + Storage + Realtime + Auth)
- **Notifications**: Firebase Cloud Messaging (FCM)
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Forms & Validation**: flutter_form_builder
- **Bottom Navigation**: BottomNavigationBar
- **Charts**: fl_chart

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── client/              # Client screens
│   │   ├── home_screen.dart
│   │   ├── post_request_screen.dart
│   │   ├── client_dashboard_screen.dart
│   │   └── client_profile_screen.dart
│   └── artisan/             # Artisan screens
│       ├── artisan_dashboard_screen.dart
│       ├── subscription_screen.dart
│       ├── training_screen.dart
│       └── artisan_profile_screen.dart
├── widgets/                  # Reusable widgets
│   └── bottom_navigation_bar.dart
├── models/                   # Data models
│   ├── user_model.dart
│   └── request_model.dart
├── services/                 # Service classes
│   ├── supabase_service.dart
│   └── notification_service.dart
├── providers/                # Riverpod providers
│   ├── navigation_provider.dart
│   └── auth_provider.dart
└── utils/                    # Utilities
    ├── app_theme.dart
    ├── constants.dart
    └── validators.dart
```

## Setup Instructions

1. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure Supabase**:
   - Update `lib/main.dart` with your Supabase URL and anon key
   - Update `lib/utils/constants.dart` with your configuration

3. **Configure Firebase** (for FCM):
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update Firebase configuration in `lib/main.dart`

4. **Run the app**:
   ```bash
   flutter run
   ```

## Design System

- **Primary Color**: Deep Blue (#1E3A8A)
- **Accent Color**: Orange (#F97316)
- **Background**: Light Grey (#F9FAFB)
- **Typography**: Inter (via Google Fonts)

## Next Steps

- [ ] Implement Supabase authentication
- [ ] Connect screens to backend services
- [ ] Implement image upload functionality
- [ ] Set up push notifications
- [ ] Add real-time updates for requests
- [ ] Implement payment integration
- [ ] Add search and filtering
- [ ] Implement rating and review system

## Notes

- This is an MVP skeleton with UI placeholders
- Backend integration is prepared but not yet implemented
- All screens are accessible via bottom navigation
- User role switching can be done via `userRoleProvider` in `navigation_provider.dart`

