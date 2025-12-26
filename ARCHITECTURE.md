# Technical Architecture Documentation

## 🏛️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Mobile App (Flutter)                │
│  ┌──────────────────────────────────────────────┐  │
│  │         Presentation Layer (Screens)          │  │
│  └────────────────┬─────────────────────────────┘  │
│                   │                                  │
│  ┌────────────────▼─────────────────────────────┐  │
│  │       State Management (Riverpod)            │  │
│  └────────────────┬─────────────────────────────┘  │
│                   │                                  │
│  ┌────────────────▼─────────────────────────────┐  │
│  │          Service Layer                        │  │
│  │  • SupabaseService                           │  │
│  │  • NotificationService                       │  │
│  └────────────────┬─────────────────────────────┘  │
└───────────────────┼─────────────────────────────────┘
                    │
         ┌──────────▼──────────┐
         │   Network Layer      │
         │  • HTTP/HTTPS       │
         │  • WebSocket        │
         └──────────┬──────────┘
                    │
    ┌───────────────▼────────────────┐
    │      Supabase Backend          │
    │  ┌──────────────────────────┐ │
    │  │  PostgreSQL Database      │ │
    │  ├──────────────────────────┤ │
    │  │  Authentication (GoTrue)  │ │
    │  ├──────────────────────────┤ │
    │  │  Storage (S3-compatible) │ │
    │  ├──────────────────────────┤ │
    │  │  Realtime (WebSocket)    │ │
    │  └──────────────────────────┘ │
    └────────────────────────────────┘
```

---

## 📦 Layer-by-Layer Breakdown

### 1. Presentation Layer (UI)

**Location**: `lib/screens/`

**Responsibility**: Display UI and handle user interactions

**Components**:
- **Screens**: Full-page views (StatelessWidget/StatefulWidget)
- **Widgets**: Reusable UI components
- **Forms**: User input collection and validation

**Key Patterns**:
- Consumer widgets (Riverpod) for reactive UI
- StatelessWidget preferred for performance
- Theme-aware components using `Theme.of(context)`

**Example Flow**:
```dart
HomeScreen (ConsumerWidget)
  ↓ watches
userRoleProvider
  ↓ renders
AppBottomNavigationBar
  ↓ triggers
context.go('/client/dashboard')
```

---

### 2. State Management Layer

**Location**: `lib/providers/`

**Framework**: Riverpod 2.4.9

**Provider Types Used**:

| Provider Type | Usage | Example |
|--------------|-------|---------|
| `Provider` | Immutable services/singletons | `supabaseClientProvider` |
| `StateProvider` | Simple mutable state | `userRoleProvider` |
| `StreamProvider` | Async data streams | `authStateProvider` |
| `FutureProvider` | One-time async data | (Not yet used) |

**Provider Dependency Graph**:
```
supabaseClientProvider (Provider<SupabaseClient>)
  ↓ depends on
Supabase.instance.client
  
supabaseServiceProvider (Provider<SupabaseService>)
  ↓ depends on
supabaseClientProvider

authStateProvider (StreamProvider<AuthState>)
  ↓ depends on
supabaseClientProvider
  
currentUserProvider (Provider<User?>)
  ↓ depends on
supabaseClientProvider
```

**State Lifecycle**:
1. App starts → Providers initialized
2. User logs in → `authStateProvider` emits new state
3. UI rebuilds → Consumers react to changes
4. User logs out → Providers reset

---

### 3. Service Layer

**Location**: `lib/services/`

**Responsibility**: Business logic and API communication

#### SupabaseService

**Purpose**: Wrapper around Supabase client for type-safe operations

**Methods**:

```dart
class SupabaseService {
  // Authentication
  Future<AuthResponse> signUpClient({...})
  Future<AuthResponse> signUpArtisan({...})
  Future<AuthResponse> signInWithEmail({...})
  Future<void> signOut()
  
  // Storage
  Future<String?> uploadProfileImage({...})
}
```

**Design Benefits**:
- Centralized error handling
- Type safety for Supabase operations
- Easy to mock for testing
- Abstracts backend implementation details

#### NotificationService

**Purpose**: Handle push notifications (Firebase/Local)

**Current State**: Placeholder structure for future FCM integration

---

### 4. Data Layer (Models)

**Location**: `lib/models/`

**Pattern**: Plain Old Dart Objects (PODOs) with JSON serialization

#### UserModel

```dart
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String role; // 'client' or 'artisan'
  
  factory UserModel.fromJson(Map<String, dynamic> json)
  Map<String, dynamic> toJson()
}
```

#### RequestModel

```dart
class RequestModel {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final String category;
  final String location;
  final String status; // 'pending', 'accepted', etc.
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  factory RequestModel.fromJson(Map<String, dynamic> json)
  Map<String, dynamic> toJson()
}
```

**Model Responsibilities**:
- Data validation (via factory constructors)
- JSON serialization/deserialization
- Type safety for data structures

---

## 🔄 Data Flow Diagrams

### Authentication Flow

```
┌──────────────┐
│  User Opens  │
│     App      │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│SplashScreen  │
│checks prefs  │
└──────┬───────┘
       │
       ▼
  [Has seen    NO
  onboarding?]─────► OnboardingScreen
       │YES                │
       ▼                   ▼
  [Logged in?] NO    RoleSelectionScreen
       │YES                │
       ▼                   ▼
  Restore role      Login/Signup Screen
       │                   │
       ▼                   ▼
   Dashboard ◄──────── Auth Success
```

### Service Request Creation Flow

```
Client (Post Request Screen)
  │
  ├─ Fills form (title, description, category, location)
  ├─ Optionally uploads images
  │
  ▼
FormBuilder validates input
  │
  ▼
SupabaseService.createRequest() [To be implemented]
  │
  ├─ Insert to 'requests' table
  ├─ Upload images to 'request-images' bucket
  ├─ Trigger notification to artisans
  │
  ▼
Update UI → Navigate to Dashboard
  │
  ▼
Show success message
```

### Real-time Updates Flow (Planned)

```
Artisan Dashboard
  │
  ├─ Subscribe to 'requests' table changes
  │
  ▼
Supabase Realtime Channel
  │
  ├─ New request created
  │
  ▼
StreamProvider emits new data
  │
  ▼
UI automatically rebuilds
  │
  ▼
Show notification banner
```

---

## 🗄️ Database Schema Design

### Supabase Tables

#### auth.users (Built-in Supabase table)
```sql
id          | uuid      | PK
email       | text      | UNIQUE
encrypted_password | text
user_metadata | jsonb   -- Stores role, name, etc.
created_at  | timestamptz
```

#### client_profiles
```sql
id          | uuid      | PK, FK → auth.users(id)
first_name  | text
last_name   | text
phone       | text
avatar_url  | text      -- URL from storage bucket
created_at  | timestamptz
updated_at  | timestamptz
```

#### artisan_profiles
```sql
id          | uuid      | PK, FK → auth.users(id)
full_name   | text
profession  | text
phone       | text
location    | text
skills      | text      -- JSON or comma-separated
avatar_url  | text
portfolio_urls | text[] -- Array of image URLs
rating      | decimal(3,2) -- Average rating
created_at  | timestamptz
updated_at  | timestamptz
```

#### requests (To be created)
```sql
id          | uuid      | PK, DEFAULT gen_random_uuid()
client_id   | uuid      | FK → auth.users(id)
title       | text      | NOT NULL
description | text      | NOT NULL
category    | text      | NOT NULL
location    | text      | NOT NULL
status      | text      | DEFAULT 'pending'
budget      | decimal(10,2)
image_urls  | text[]    -- Array of image URLs
created_at  | timestamptz | DEFAULT now()
updated_at  | timestamptz
```

#### messages (Future)
```sql
id          | uuid      | PK
sender_id   | uuid      | FK → auth.users(id)
recipient_id| uuid      | FK → auth.users(id)
request_id  | uuid      | FK → requests(id)
content     | text      | NOT NULL
read_at     | timestamptz
created_at  | timestamptz
```

### Row-Level Security (RLS) Policies

**Recommended Policies**:

```sql
-- Client Profiles: Users can only read/update their own profile
CREATE POLICY "Users can view own profile"
  ON client_profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON client_profiles FOR UPDATE
  USING (auth.uid() = id);

-- Requests: Clients can CRUD own requests, Artisans can view all
CREATE POLICY "Clients can insert own requests"
  ON requests FOR INSERT
  WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Artisans can view all requests"
  ON requests FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM artisan_profiles WHERE id = auth.uid()
    )
  );
```

---

## 🧭 Routing Architecture

### GoRouter Configuration

**Routing Type**: Declarative, path-based

**Route Structure**:
```
/
├── splash
├── onboarding
├── auth/
│   ├── role-select
│   ├── login
│   ├── signup-client
│   └── signup-artisan
├── client/
│   ├── home
│   ├── post-request
│   ├── dashboard
│   └── profile
└── artisan/
    ├── dashboard
    ├── subscriptions
    ├── training
    └── profile
```

**Navigation Methods**:
- `context.go('/path')` - Replace current stack
- `context.push('/path')` - Add to stack (modal)
- `context.pop()` - Go back

**Guards/Redirects** (To be implemented):
```dart
redirect: (context, state) {
  final isLoggedIn = authState.session != null;
  final isAuthRoute = state.location.startsWith('/auth');
  
  if (!isLoggedIn && !isAuthRoute) {
    return '/auth/login';
  }
  return null; // No redirect
}
```

---

## 🎨 Theme Architecture

### Theme System

**Location**: `lib/utils/app_theme.dart`

**Pattern**: Centralized theme using Material Design 3

**Theme Components**:

```dart
ThemeData {
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor)
  textTheme: GoogleFonts.inter() // Custom typography
  elevatedButtonTheme: // Custom button styles
  inputDecorationTheme: // Form field styles
  cardTheme: // Card component styles
  appBarTheme: // App bar styles
}
```

**Design Tokens**:
```dart
// Colors
primaryColor: #1E3A8A      // Deep Blue
accentColor: #F97316       // Orange
backgroundColor: #F9FAFB   // Light Grey
cardColor: #FFFFFF         // White

// Typography Scale
displayLarge: 32px, bold
displayMedium: 28px, bold
displaySmall: 24px, w600
titleLarge: 18px, w600
bodyLarge: 16px
bodyMedium: 14px
bodySmall: 12px

// Spacing Scale
8px, 12px, 16px, 24px, 32px

// Border Radius
Small: 12px
Medium: 16px
Large: 20px
Circle: 999px
```

**Dark Mode Support**: Not yet implemented (future enhancement)

---

## 🔐 Security Architecture

### Authentication Security

**Method**: Supabase Auth (JWT-based)

**Token Storage**:
- Access Token: Stored in Supabase client (memory)
- Refresh Token: Stored securely by Supabase SDK
- User Session: Persisted in `SharedPreferences` (boolean flag only)

**Session Flow**:
```
1. User logs in → Supabase returns JWT
2. JWT stored in memory by Supabase client
3. `is_logged_in` flag saved to SharedPreferences
4. JWT auto-refreshed by Supabase SDK
5. On app restart → Supabase auto-restores session
```

### Data Security

**Current Implementation**:
- HTTPS only (enforced by Supabase)
- Anonymous key exposed (safe for client-side)
- No sensitive data in SharedPreferences

**Recommendations**:
1. Enable RLS on all tables
2. Use `flutter_secure_storage` for sensitive data
3. Implement input sanitization
4. Add rate limiting on Supabase (built-in)
5. Validate file uploads (size, type)

### Storage Security

**Bucket Policies** (To be configured):
```sql
-- profile-images bucket
CREATE POLICY "Users can upload own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'profile-images' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Anyone can view avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'profile-images');
```

---

## ⚡ Performance Optimization Strategies

### Current Optimizations

1. **Lazy Loading**
   - GoRouter loads screens on-demand
   - Providers initialized only when accessed

2. **Widget Efficiency**
   - `const` constructors wherever possible
   - StatelessWidget preferred over StatefulWidget
   - ListView.builder for long lists

3. **Image Optimization**
   - Cached network images (default Flutter behavior)
   - Image picker with quality compression

4. **State Management**
   - Provider scoping to prevent global rebuilds
   - ConsumerWidget only where state is needed

### Future Optimizations

1. **Pagination**
   ```dart
   // Implement cursor-based pagination for requests
   final requests = await supabase
     .from('requests')
     .select()
     .range(0, 20)
     .order('created_at', ascending: false);
   ```

2. **Caching Layer**
   ```dart
   // Cache frequently accessed data
   final cachedRequests = ref.watch(requestsCacheProvider);
   ```

3. **Debouncing Search**
   ```dart
   // Prevent excessive API calls during search
   Timer? _debounce;
   void onSearchChanged(String query) {
     _debounce?.cancel();
     _debounce = Timer(Duration(milliseconds: 500), () {
       performSearch(query);
     });
   }
   ```

4. **Image Optimization**
   - Use `cached_network_image` package
   - Implement progressive JPEG loading
   - Lazy load images in lists

---

## 🧪 Testing Architecture

### Current Test Structure

**Location**: `test/`

**Framework**: `flutter_test` (built-in)

**Coverage**: Minimal (widget test placeholder)

### Recommended Test Strategy

#### Unit Tests
```dart
// Test models
test('UserModel.fromJson creates valid user', () {
  final json = {'id': '123', 'email': 'test@test.com', ...};
  final user = UserModel.fromJson(json);
  expect(user.id, '123');
});

// Test services
test('SupabaseService.signUpClient creates profile', () async {
  final service = SupabaseService(mockClient);
  final response = await service.signUpClient(...);
  expect(response.user, isNotNull);
});
```

#### Widget Tests
```dart
testWidgets('HomeScreen displays welcome message', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: HomeScreen()),
    ),
  );
  expect(find.text('Welcome!'), findsOneWidget);
});
```

#### Integration Tests
```dart
// Test complete flows
testWidgets('User can complete signup flow', (tester) async {
  // Navigate through signup screens
  // Fill forms
  // Submit and verify navigation
});
```

---

## 📱 Platform-Specific Considerations

### Android

**Min SDK**: 21 (Android 5.0)
**Target SDK**: 33+

**Configuration**: `android/app/build.gradle`
```gradle
android {
    compileSdkVersion 33
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

**Permissions** (Required):
- `INTERNET` - API calls
- `CAMERA` - Image picker
- `READ_EXTERNAL_STORAGE` - Image picker
- `WRITE_EXTERNAL_STORAGE` - Image picker

### iOS

**Min Version**: iOS 12.0
**Target**: iOS 16+

**Configuration**: `ios/Runner/Info.plist`
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Need access to upload images</string>
<key>NSCameraUsageDescription</key>
<string>Need access to take photos</string>
```

---

## 🚀 Deployment Architecture

### Build Process

```bash
# Development
flutter run --debug

# Staging
flutter build apk --flavor staging
flutter build ios --flavor staging

# Production
flutter build apk --release --obfuscate --split-debug-info=./symbols
flutter build ios --release --obfuscate --split-debug-info=./symbols
```

### Environment Configuration (Recommended)

```dart
// lib/config/environment.dart
enum Environment { dev, staging, production }

class EnvironmentConfig {
  static Environment current = Environment.dev;
  
  static String get supabaseUrl {
    switch (current) {
      case Environment.dev:
        return 'https://dev-supabase.co';
      case Environment.staging:
        return 'https://staging-supabase.co';
      case Environment.production:
        return 'https://prod-supabase.co';
    }
  }
}
```

---

## 📊 Monitoring & Analytics (Future)

### Recommended Tools

1. **Crash Reporting**: Firebase Crashlytics
2. **Analytics**: Firebase Analytics / Mixpanel
3. **Performance**: Firebase Performance Monitoring
4. **Logging**: Sentry

### Key Metrics to Track

- User registration rate
- Request creation rate
- Artisan response time
- App crash rate
- API response times
- User retention (DAU/MAU)

---

## 🔄 CI/CD Pipeline (Recommended)

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v2
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

*This architecture is designed to be scalable, maintainable, and follows Flutter/Dart best practices.*
