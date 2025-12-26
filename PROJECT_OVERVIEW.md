# Mobile Artisan App - Comprehensive Project Overview

## 📱 Project Summary

**ArtisanConnect** is a Flutter-based mobile marketplace application that connects clients with artisans for various services. It features a dual-role system supporting both service seekers (clients) and service providers (artisans).

### Key Concept
The app uses a "Post & Connect" model where:
1. Clients post service requests
2. Artisans browse requests and contact interested clients
3. Both parties manage their interactions through dedicated dashboards

---

## 🏗️ Architecture Overview

### Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Framework | Flutter 3.0+ | Cross-platform mobile development |
| Language | Dart | Primary programming language |
| Backend | Supabase | PostgreSQL database, authentication, storage, realtime |
| State Management | Riverpod 2.4.9 | Reactive state management |
| Routing | GoRouter 12.1.3 | Declarative routing |
| Forms | flutter_form_builder 9.1.1 | Form handling and validation |
| Charts | fl_chart 0.66.0 | Data visualization |
| UI Components | Material Design 3 | UI framework |
| Typography | Google Fonts (Inter) | Custom fonts |
| Notifications | flutter_local_notifications | Local push notifications |

### Project Structure

```
lib/
├── main.dart                           # App entry point, Supabase initialization
├── models/                             # Data models
│   ├── user_model.dart                # User entity (client/artisan)
│   └── request_model.dart             # Service request entity
├── providers/                          # Riverpod state providers
│   ├── auth_provider.dart             # Authentication state & Supabase client
│   └── navigation_provider.dart       # Router & user role management
├── screens/                            # UI screens
│   ├── splash_screen.dart             # Initial loading screen
│   ├── onboarding_screen.dart         # First-time user onboarding (3 pages)
│   ├── auth/                          # Authentication flows
│   │   ├── role_selection_screen.dart # Client vs Artisan selection
│   │   ├── login_screen.dart          # Email/password login
│   │   ├── client_signup_screen.dart  # Client registration
│   │   └── artisan_signup_screen.dart # Artisan registration
│   ├── client/                        # Client-specific screens
│   │   ├── home_screen.dart           # Browse services, quick actions
│   │   ├── post_request_screen.dart   # Create service requests
│   │   ├── client_dashboard_screen.dart # View active requests
│   │   └── client_profile_screen.dart # User profile management
│   └── artisan/                       # Artisan-specific screens
│       ├── artisan_dashboard_screen.dart # Stats, earnings, jobs
│       ├── subscription_screen.dart   # Subscription plans management
│       ├── training_screen.dart       # Training courses & progress
│       └── artisan_profile_screen.dart # Business profile & portfolio
├── services/                           # Business logic layer
│   ├── supabase_service.dart          # Supabase API wrapper (auth, data)
│   └── notification_service.dart      # Push notification handling
├── widgets/                            # Reusable UI components
│   └── bottom_navigation_bar.dart     # Role-based navigation bar
└── utils/                              # Utilities & constants
    ├── app_theme.dart                 # App-wide theme configuration
    ├── constants.dart                 # API endpoints, statuses, roles
    └── validators.dart                # Form validation logic
```

---

## 🎨 Design System

### Color Palette
- **Primary**: Deep Blue (#1E3A8A) - Headers, primary actions
- **Accent**: Orange (#F97316) - CTAs, highlights
- **Background**: Light Grey (#F9FAFB) - Screen backgrounds
- **Card**: White (#FFFFFF) - Card backgrounds
- **Text Primary**: Dark Grey (#1F2937)
- **Text Secondary**: Medium Grey (#6B7280)

### Typography
- **Font Family**: Inter (via Google Fonts)
- **Design Philosophy**: Material Design 3 with custom theming
- **Components**: Rounded corners (12-16px), soft shadows, elevated cards

---

## 🔐 Authentication & User Flow

### User Journey

```
Splash Screen (2s delay)
    ↓
[First Time?] → YES → Onboarding (3 pages) → Role Selection
    ↓ NO
[Logged In?] → NO → Role Selection → Login/Signup
    ↓ YES
Restore Role → Client Dashboard / Artisan Dashboard
```

### Authentication System
- **Provider**: Supabase Auth (email/password)
- **Storage**: SharedPreferences for session persistence
- **User Roles**: Stored in user metadata and separate profile tables
- **Session Management**: Automatic restoration on app restart

### Database Schema (Supabase)

```sql
-- Client profiles table
create table public.client_profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  first_name text,
  last_name text,
  phone text,
  created_at timestamptz default now()
);

-- Artisan profiles table
create table public.artisan_profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  profession text,
  phone text,
  location text,
  skills text,
  created_at timestamptz default now()
);
```

---

## 📋 Features by User Role

### Client Features

| Screen | Functionality | Navigation Tab |
|--------|--------------|----------------|
| Home | Browse services, quick action cards | Tab 1: Home |
| Post Request | Create service requests with form | Tab 2: Post Request |
| Dashboard | View active/pending requests | Tab 3: Dashboard |
| Profile | Manage personal info, settings | Tab 4: Profile |

### Artisan Features

| Screen | Functionality | Navigation Tab |
|--------|--------------|----------------|
| Dashboard | View stats, earnings, jobs chart | Tab 1: Dashboard |
| Subscriptions | Manage subscription plans | Tab 2: Subscriptions |
| Training | Access training courses, track progress | Tab 3: Training |
| Profile | Business info, portfolio, reviews | Tab 4: Profile |

---

## 🔌 Backend Integration (Supabase)

### Configured Endpoints
- **URL**: `https://nqszuysyvzsmphrymqxo.supabase.co`
- **Anonymous Key**: Configured in `main.dart` and `constants.dart`

### Storage Buckets
- `profile-images` - User avatars
- `request-images` - Service request photos
- `portfolio-images` - Artisan portfolio

### Services Implemented
1. **Authentication**
   - `signUpClient()` - Client registration + profile creation
   - `signUpArtisan()` - Artisan registration + profile creation
   - `signInWithEmail()` - Email/password login
   - `signOut()` - Session termination

2. **Storage**
   - `uploadProfileImage()` - Upload avatars to Supabase Storage

### Request Status Flow
```
pending → accepted → in_progress → completed
                 ↘ cancelled
```

---

## 🧭 Navigation System

### Router Configuration (GoRouter)
- **Initial Route**: `/splash`
- **Auth Flow**: `/onboarding` → `/auth/role-select` → `/auth/login` or `/auth/signup-{role}`
- **Client Routes**: `/client/{home, post-request, dashboard, profile}`
- **Artisan Routes**: `/artisan/{dashboard, subscriptions, training, profile}`

### Role-Based Navigation
- **State Provider**: `userRoleProvider` (Riverpod StateProvider)
- **Bottom Navigation**: Dynamic tabs based on user role
- **Deep Linking**: Ready (GoRouter supports URL-based navigation)

---

## 📊 State Management (Riverpod)

### Key Providers

```dart
// Auth-related providers
final supabaseClientProvider       // Supabase client instance
final supabaseServiceProvider      // High-level service wrapper
final authStateProvider            // Auth state stream
final currentUserProvider          // Current logged-in user

// Navigation providers
final userRoleProvider             // Client or Artisan role
final routerProvider               // GoRouter instance
```

---

## 🚀 Development Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK
- Android Studio / Xcode (for emulators)
- Supabase account (already configured)

### Installation Steps

```bash
# 1. Clone repository
git clone https://github.com/abderrahmen76/mobile_artisan_app.git
cd mobile_artisan_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Build for production
flutter build apk        # Android
flutter build ios        # iOS
```

### Configuration Files
- `pubspec.yaml` - Dependencies and assets
- `analysis_options.yaml` - Lint rules (flutter_lints)
- `android/app/build.gradle` - Android config
- `ios/Runner/Info.plist` - iOS config

### Firebase Setup (Optional - Currently Disabled)
Uncomment in `pubspec.yaml` and `main.dart`:
- `firebase_core: ^2.24.2`
- `firebase_messaging: ^14.7.10`
- Add `google-services.json` (Android)
- Add `GoogleService-Info.plist` (iOS)

---

## 📦 Assets Structure

```
assets/
├── images/
│   ├── onboarding_1.png         # Onboarding page 1 illustration
│   ├── onboarding_2.png         # Onboarding page 2 illustration
│   ├── onboarding_3.png         # Onboarding page 3 illustration
│   └── avatars/                 # User avatar placeholders
└── icons/                       # Custom app icons
```

---

## 🧪 Testing

### Test Structure
- **Unit Tests**: `test/widget_test.dart`
- **Framework**: flutter_test (built-in)
- **Coverage**: Currently minimal (MVP stage)

### Running Tests
```bash
flutter test                      # Run all tests
flutter test test/widget_test.dart  # Run specific test
```

---

## 📝 Current Implementation Status

### ✅ Completed (MVP)
- Complete UI skeleton for all screens
- Authentication flow (Supabase integrated)
- Role-based navigation system
- User profile creation (client & artisan)
- Bottom navigation for both roles
- Onboarding experience
- Splash screen with session restoration
- Theme system with Material Design 3
- Form builders and validators setup
- Image upload service structure

### 🚧 In Progress / Planned
- [ ] Backend data integration (requests CRUD)
- [ ] Real-time updates (Supabase Realtime)
- [ ] Image upload UI for requests/portfolio
- [ ] Push notifications (FCM integration)
- [ ] Payment integration
- [ ] Search and filtering
- [ ] Rating and review system
- [ ] Chat/messaging between clients and artisans
- [ ] Geolocation services
- [ ] Analytics and tracking

---

## 🔑 Key Design Patterns

### 1. **Feature-Based Organization**
Screens are organized by user role (client/artisan), making navigation intuitive.

### 2. **Provider Pattern**
Riverpod providers manage state globally, avoiding prop drilling.

### 3. **Service Layer**
`SupabaseService` abstracts backend logic from UI components.

### 4. **Declarative Routing**
GoRouter provides type-safe, declarative navigation.

### 5. **Theme Centralization**
`AppTheme` class centralizes all design tokens.

---

## 🛡️ Security Considerations

### Current Implementation
- Supabase Row-Level Security (RLS) should be configured
- Anonymous key is public (safe for client-side)
- User sessions stored locally (SharedPreferences)

### Recommendations
1. Enable RLS policies on Supabase tables
2. Implement refresh token rotation
3. Add input sanitization
4. Implement rate limiting on Supabase
5. Add error boundary handling
6. Secure storage for sensitive data (flutter_secure_storage)

---

## 📈 Performance Optimizations

### Current Optimizations
- Lazy loading with GoRouter
- Image caching (default Flutter behavior)
- Stateless widgets where possible
- Provider scoping to prevent unnecessary rebuilds

### Potential Improvements
- Implement pagination for request lists
- Add skeleton loaders for better UX
- Optimize image sizes
- Implement offline-first architecture
- Add caching layer for API responses

---

## 🐛 Known Limitations

1. **Flutter SDK Required**: Development requires Flutter installation (not available in current environment)
2. **Firebase Disabled**: Push notifications not yet active
3. **Mock Data**: Most screens show placeholder data
4. **No Backend Logic**: CRUD operations not fully implemented
5. **Asset Missing**: Some onboarding images may be missing

---

## 📚 Dependencies Summary

### Core Dependencies
- `flutter_riverpod: ^2.4.9` - State management
- `supabase_flutter: ^2.5.4` - Backend services
- `go_router: ^12.1.3` - Navigation
- `flutter_form_builder: ^9.1.1` - Forms
- `google_fonts: ^6.1.0` - Typography
- `fl_chart: ^0.66.0` - Charts

### Development Dependencies
- `flutter_test` - Testing framework
- `flutter_lints: ^3.0.1` - Lint rules
- `build_runner: ^2.4.7` - Code generation
- `riverpod_generator: ^2.3.9` - Provider code generation

---

## 🎯 Next Development Steps

### Immediate (Week 1-2)
1. Implement request CRUD operations
2. Connect dashboards to real data
3. Add image upload UI
4. Implement search functionality

### Short-term (Week 3-4)
1. Add real-time notifications
2. Implement artisan-client messaging
3. Add geolocation features
4. Create filtering system

### Long-term (Month 2+)
1. Payment gateway integration
2. Rating and review system
3. Advanced analytics dashboard
4. Multi-language support
5. Accessibility improvements

---

## 👥 User Roles & Permissions

| Feature | Client | Artisan |
|---------|--------|---------|
| Post Service Request | ✅ | ❌ |
| Browse Requests | ❌ | ✅ |
| View Dashboard | ✅ | ✅ |
| Manage Profile | ✅ | ✅ |
| Subscriptions | ❌ | ✅ |
| Training Courses | ❌ | ✅ |
| Upload Portfolio | ❌ | ✅ |

---

## 📞 Support & Documentation

### Resources
- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev
- **Supabase Docs**: https://supabase.com/docs
- **GoRouter Docs**: https://pub.dev/packages/go_router

### Project-Specific
- Main README: `/README.md`
- This Overview: `/PROJECT_OVERVIEW.md`
- Analysis Config: `/analysis_options.yaml`

---

## 📄 License & Version

- **Version**: 1.0.0+1
- **Publish**: Not published to app stores
- **Environment**: Dart SDK >=3.0.0 <4.0.0

---

*Last Updated: December 2024*
*Project Status: MVP Development Phase*
