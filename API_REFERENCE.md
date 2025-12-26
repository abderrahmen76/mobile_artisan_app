# 🔌 API Reference - Supabase Integration

## Overview

This document provides a complete reference for all Supabase backend interactions in the Mobile Artisan App.

---

## 📍 Endpoint Configuration

### Base Configuration

```dart
// Location: lib/main.dart, lib/utils/constants.dart

URL: https://nqszuysyvzsmphrymqxo.supabase.co
Anon Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Storage Buckets

| Bucket Name | Purpose | Public Access |
|-------------|---------|---------------|
| `profile-images` | User avatars | Yes (read only) |
| `request-images` | Service request photos | Yes (read only) |
| `portfolio-images` | Artisan portfolios | Yes (read only) |

---

## 🔐 Authentication API

### Sign Up Client

**Method**: `signUpClient()`

**Purpose**: Register a new client user and create profile

**Parameters**:
```dart
{
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String phone,
}
```

**Returns**: `Future<AuthResponse>`

**Implementation**:
```dart
final service = ref.read(supabaseServiceProvider);
final response = await service.signUpClient(
  email: 'client@example.com',
  password: 'SecurePass123',
  firstName: 'John',
  lastName: 'Doe',
  phone: '+1234567890',
);

if (response.user != null) {
  // Success - user created
  final userId = response.user!.id;
}
```

**Database Operations**:
1. Creates user in `auth.users` table
2. Inserts row in `client_profiles` table
3. Sets user metadata: `{ role: 'client', first_name, last_name, phone }`

**Error Handling**:
```dart
try {
  final response = await service.signUpClient(...);
} on AuthException catch (e) {
  // Handle auth errors (email exists, weak password, etc.)
  print('Auth error: ${e.message}');
} catch (e) {
  // Handle other errors
  print('Error: $e');
}
```

---

### Sign Up Artisan

**Method**: `signUpArtisan()`

**Purpose**: Register a new artisan user and create profile

**Parameters**:
```dart
{
  required String email,
  required String password,
  required String fullName,
  required String profession,
  required String phone,
  required String location,
  required String skills,
}
```

**Returns**: `Future<AuthResponse>`

**Implementation**:
```dart
final response = await service.signUpArtisan(
  email: 'artisan@example.com',
  password: 'SecurePass123',
  fullName: 'Jane Smith',
  profession: 'Plumber',
  phone: '+1234567890',
  location: 'New York, NY',
  skills: 'Plumbing, Pipe fitting, Water heater installation',
);
```

**Database Operations**:
1. Creates user in `auth.users` table
2. Inserts row in `artisan_profiles` table
3. Sets user metadata: `{ role: 'artisan', full_name, profession, phone, location }`

---

### Sign In

**Method**: `signInWithEmail()`

**Purpose**: Authenticate existing user

**Parameters**:
```dart
{
  required String email,
  required String password,
}
```

**Returns**: `Future<AuthResponse>`

**Implementation**:
```dart
final response = await service.signInWithEmail(
  email: 'user@example.com',
  password: 'password123',
);

if (response.session != null) {
  // Login successful
  final user = response.user;
  final role = user?.userMetadata?['role']; // 'client' or 'artisan'
}
```

**Session Management**:
- Access token stored in memory by Supabase client
- Refresh token automatically managed
- Session persists across app restarts

---

### Sign Out

**Method**: `signOut()`

**Purpose**: End user session

**Parameters**: None

**Returns**: `Future<void>`

**Implementation**:
```dart
await service.signOut();
// Clear local storage
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
// Navigate to login
context.go('/auth/login');
```

---

## 📂 Storage API

### Upload Profile Image

**Method**: `uploadProfileImage()`

**Purpose**: Upload user avatar to Supabase Storage

**Parameters**:
```dart
{
  required File file,
  required String userId,
}
```

**Returns**: `Future<String?>` (public URL)

**Implementation**:
```dart
final file = File('/path/to/image.jpg');
final userId = currentUser.id;

final imageUrl = await service.uploadProfileImage(
  file: file,
  userId: userId,
);

if (imageUrl != null) {
  // Update user profile with imageUrl
}
```

**Storage Path**: `profile-images/avatars/{userId}.{ext}`

**File Options**:
- Cache control: 3600 seconds
- Upsert: true (overwrites existing)

**Supported Formats**: JPG, PNG, GIF, WebP

**Size Limit**: 5MB (configurable in Supabase)

---

## 👥 User Profile API

### Get Client Profile

**Method**: Direct Supabase query (to be wrapped in service)

**Implementation**:
```dart
final userId = currentUser.id;
final response = await supabase
  .from('client_profiles')
  .select()
  .eq('id', userId)
  .single();

final profile = response as Map<String, dynamic>;
print(profile['first_name']);
```

**Response Schema**:
```json
{
  "id": "uuid",
  "first_name": "string",
  "last_name": "string",
  "phone": "string",
  "avatar_url": "string | null",
  "created_at": "timestamp"
}
```

---

### Update Client Profile

**Method**: Direct Supabase query (to be wrapped)

**Implementation**:
```dart
await supabase
  .from('client_profiles')
  .update({
    'first_name': 'John',
    'last_name': 'Updated',
    'phone': '+9876543210',
    'avatar_url': 'https://...',
  })
  .eq('id', userId);
```

---

### Get Artisan Profile

**Implementation**:
```dart
final response = await supabase
  .from('artisan_profiles')
  .select()
  .eq('id', userId)
  .single();
```

**Response Schema**:
```json
{
  "id": "uuid",
  "full_name": "string",
  "profession": "string",
  "phone": "string",
  "location": "string",
  "skills": "string",
  "avatar_url": "string | null",
  "portfolio_urls": ["string"],
  "rating": "decimal | null",
  "created_at": "timestamp"
}
```

---

## 📋 Requests API (To Be Implemented)

### Create Request

**Proposed Method**: `createRequest()`

**Parameters**:
```dart
{
  required String title,
  required String description,
  required String category,
  required String location,
  double? budget,
  List<File>? images,
}
```

**Implementation Example**:
```dart
Future<String> createRequest({
  required String title,
  required String description,
  required String category,
  required String location,
  double? budget,
  List<File>? images,
}) async {
  final userId = currentUser!.id;
  
  // 1. Upload images to storage
  List<String> imageUrls = [];
  if (images != null) {
    for (var image in images) {
      final url = await uploadRequestImage(image);
      if (url != null) imageUrls.add(url);
    }
  }
  
  // 2. Insert request
  final response = await _client
    .from('requests')
    .insert({
      'client_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'budget': budget,
      'status': 'pending',
      'image_urls': imageUrls,
    })
    .select()
    .single();
  
  return response['id'] as String;
}
```

---

### Get Requests

**Proposed Implementation**:

**For Clients** (get own requests):
```dart
final requests = await supabase
  .from('requests')
  .select()
  .eq('client_id', userId)
  .order('created_at', ascending: false);
```

**For Artisans** (get all pending requests):
```dart
final requests = await supabase
  .from('requests')
  .select()
  .eq('status', 'pending')
  .order('created_at', ascending: false)
  .limit(20);
```

---

### Update Request Status

**Proposed Implementation**:
```dart
await supabase
  .from('requests')
  .update({'status': 'accepted'})
  .eq('id', requestId);
```

---

## 🔔 Realtime API (Planned)

### Subscribe to Request Updates

**Purpose**: Get real-time notifications when requests are updated

**Implementation Example**:
```dart
final subscription = supabase
  .from('requests')
  .stream(primaryKey: ['id'])
  .eq('client_id', userId)
  .listen((data) {
    // Handle new/updated requests
    print('Requests updated: $data');
  });

// Unsubscribe when done
subscription.cancel();
```

---

### Subscribe to New Messages

**Proposed Implementation**:
```dart
final channel = supabase.channel('messages');

channel
  .on(
    RealtimeListenTypes.postgresChanges,
    ChannelFilter(
      event: 'INSERT',
      schema: 'public',
      table: 'messages',
      filter: 'recipient_id=eq.$userId',
    ),
    (payload, [ref]) {
      // Handle new message
      final message = payload['new'];
      showNotification(message);
    },
  )
  .subscribe();
```

---

## 🔍 Query Patterns

### Filtering

```dart
// Single condition
.eq('status', 'pending')

// Multiple conditions
.eq('category', 'plumbing')
.eq('status', 'pending')

// Range filter
.gte('budget', 100)
.lte('budget', 500)

// Text search
.textSearch('title', 'plumber')

// In array
.in_('category', ['plumbing', 'electrical'])
```

### Ordering

```dart
// Ascending
.order('created_at', ascending: true)

// Descending
.order('created_at', ascending: false)

// Multiple columns
.order('status')
.order('created_at', ascending: false)
```

### Pagination

```dart
// Limit results
.limit(20)

// Range (offset-based)
.range(0, 19)  // First 20 results
.range(20, 39) // Next 20 results

// Cursor-based (recommended)
.gt('id', lastSeenId)
.limit(20)
```

### Joins

```dart
// Get requests with client info
final data = await supabase
  .from('requests')
  .select('''
    *,
    client:client_id (
      first_name,
      last_name,
      phone
    )
  ''');
```

---

## ⚠️ Error Handling

### Common Error Types

```dart
try {
  // Supabase operation
} on AuthException catch (e) {
  // Authentication errors
  switch (e.statusCode) {
    case '400':
      print('Invalid credentials');
      break;
    case '422':
      print('User already exists');
      break;
    default:
      print('Auth error: ${e.message}');
  }
} on PostgrestException catch (e) {
  // Database errors
  print('Database error: ${e.message}');
} on StorageException catch (e) {
  // Storage errors
  print('Storage error: ${e.message}');
} catch (e) {
  // Other errors
  print('Unexpected error: $e');
}
```

### Validation Errors

```dart
// Check before operation
if (!isValidEmail(email)) {
  throw FormatException('Invalid email format');
}

if (password.length < 8) {
  throw FormatException('Password must be at least 8 characters');
}
```

---

## 🔒 Row-Level Security (RLS)

### Client Profiles Policy

```sql
-- Users can view their own profile
CREATE POLICY "Users view own profile"
  ON client_profiles FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users update own profile"
  ON client_profiles FOR UPDATE
  USING (auth.uid() = id);
```

### Requests Policy

```sql
-- Clients can insert own requests
CREATE POLICY "Clients insert requests"
  ON requests FOR INSERT
  WITH CHECK (auth.uid() = client_id);

-- Clients can view own requests
CREATE POLICY "Clients view own requests"
  ON requests FOR SELECT
  USING (auth.uid() = client_id);

-- Artisans can view all pending requests
CREATE POLICY "Artisans view pending requests"
  ON requests FOR SELECT
  USING (
    status = 'pending' AND
    EXISTS (
      SELECT 1 FROM artisan_profiles
      WHERE id = auth.uid()
    )
  );
```

---

## 📊 Rate Limiting

**Supabase Default Limits**:
- API requests: 100 requests per 10 seconds
- Storage uploads: 100 uploads per 10 seconds
- Realtime connections: 100 concurrent connections

**Best Practices**:
1. Implement client-side debouncing for search
2. Use pagination instead of loading all data
3. Cache frequently accessed data
4. Batch operations when possible

---

## 🧪 Testing API Calls

### Mock Supabase for Testing

```dart
// test/mocks.dart
class MockSupabaseClient extends Mock implements SupabaseClient {}

// In test
test('signUpClient creates user and profile', () async {
  final mockClient = MockSupabaseClient();
  final service = SupabaseService(mockClient);
  
  when(mockClient.auth.signUp(
    email: any,
    password: any,
    data: any,
  )).thenAnswer((_) async => AuthResponse(
    user: User(id: '123', ...),
  ));
  
  final result = await service.signUpClient(...);
  expect(result.user, isNotNull);
});
```

---

## 📝 API Checklist

### Implemented ✅
- [x] Client signup
- [x] Artisan signup
- [x] Email/password login
- [x] Logout
- [x] Upload profile image
- [x] Get current user

### To Be Implemented 🚧
- [ ] Get client profile
- [ ] Update client profile
- [ ] Get artisan profile
- [ ] Update artisan profile
- [ ] Create request
- [ ] Get requests (filtered by role)
- [ ] Update request status
- [ ] Delete request
- [ ] Upload request images
- [ ] Realtime subscriptions
- [ ] Search requests
- [ ] Filter requests by category/location
- [ ] Messaging system
- [ ] Rating and reviews

---

## 🔗 External References

- [Supabase Dart Client Docs](https://supabase.com/docs/reference/dart/introduction)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Supabase Storage Guide](https://supabase.com/docs/guides/storage)
- [Supabase Realtime Guide](https://supabase.com/docs/guides/realtime)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)

---

*Last Updated: December 2024*
*API Version: 1.0.0 (MVP)*
