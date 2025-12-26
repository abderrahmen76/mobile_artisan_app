# 🚀 Quick Start Guide - Mobile Artisan App

## Welcome Developer! 👋

This guide will get you up and running with the Mobile Artisan App in under 10 minutes.

---

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ **Flutter SDK** (version 3.0 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- ✅ **Dart SDK** (comes with Flutter)
- ✅ **Git** - [Install Git](https://git-scm.com/downloads)
- ✅ **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- ✅ **Mobile Emulator** or physical device
  - Android: Android Emulator (via Android Studio)
  - iOS: Xcode Simulator (macOS only)

### Verify Installation

```bash
flutter --version
dart --version
git --version
```

Expected output:
```
Flutter 3.x.x • channel stable
Dart 3.x.x
git version 2.x.x
```

---

## 🔧 Setup Steps

### 1. Clone the Repository

```bash
git clone https://github.com/abderrahmen76/mobile_artisan_app.git
cd mobile_artisan_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all packages listed in `pubspec.yaml`.

### 3. Verify Flutter Doctor

```bash
flutter doctor
```

Ensure all required components are installed. Fix any issues reported.

### 4. Connect a Device

**Option A: Physical Device**
- Enable Developer Mode on your device
- Enable USB Debugging (Android) or trust your computer (iOS)
- Connect via USB

**Option B: Emulator**
- Android: Launch emulator from Android Studio
- iOS: Launch simulator: `open -a Simulator`

Verify device is connected:
```bash
flutter devices
```

### 5. Run the App

```bash
flutter run
```

Or in debug mode with hot reload:
```bash
flutter run --debug
```

🎉 **Success!** The app should launch on your device/emulator.

---

## 📱 First App Launch

### Default Flow

1. **Splash Screen** (2 seconds)
   - Shows app logo and loading indicator

2. **Onboarding** (first-time only)
   - Swipe through 3 pages
   - Tap "Get Started" or "Skip"

3. **Role Selection**
   - Choose "Client" or "Artisan"
   - Tap "Continue"

4. **Signup**
   - Fill registration form
   - Submit to create account

5. **Dashboard**
   - Explore features based on role

### Testing Credentials

Currently, no test accounts are pre-configured. You'll need to:
1. Create a new account via signup
2. Or configure Supabase with test data

---

## 🗂️ Project Structure Overview

```
mobile_artisan_app/
├── lib/                    # Main application code
│   ├── main.dart          # App entry point ⭐ START HERE
│   ├── screens/           # UI screens
│   ├── models/            # Data models
│   ├── providers/         # State management
│   ├── services/          # Business logic
│   ├── widgets/           # Reusable components
│   └── utils/             # Helpers & constants
├── assets/                # Images, icons, fonts
├── test/                  # Unit & widget tests
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── pubspec.yaml          # Dependencies ⭐ IMPORTANT
└── README.md             # Basic project info
```

---

## 🎯 Key Files to Understand

| File | Purpose | Why It Matters |
|------|---------|----------------|
| `lib/main.dart` | App entry, Supabase init | First code that runs |
| `lib/providers/navigation_provider.dart` | Router & role management | Controls app navigation |
| `lib/providers/auth_provider.dart` | Auth state | Manages login/logout |
| `lib/services/supabase_service.dart` | Backend API wrapper | All server calls |
| `lib/utils/app_theme.dart` | Design system | UI colors & styles |
| `pubspec.yaml` | Dependencies & assets | Add packages here |

---

## 🧪 Development Workflow

### Hot Reload (Fast Development)

While the app is running, make code changes and press:
- **`r`** in terminal - Hot reload (updates UI instantly)
- **`R`** in terminal - Hot restart (full app restart)
- **`q`** in terminal - Quit

### Common Commands

```bash
# Run with specific device
flutter run -d <device-id>

# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios

# Run tests
flutter test

# Check code quality
flutter analyze

# Format code
flutter format lib/
```

---

## 🔑 Supabase Configuration

### Current Setup

The app is pre-configured with a Supabase instance:

**URL**: `https://nqszuysyvzsmphrymqxo.supabase.co`  
**Anon Key**: (See `lib/main.dart` line 16)

### To Use Your Own Supabase

1. Create account at [supabase.com](https://supabase.com)
2. Create new project
3. Get your URL and anon key from project settings
4. Update in **two locations**:

**File 1**: `lib/main.dart`
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_ANON_KEY',
);
```

**File 2**: `lib/utils/constants.dart`
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

5. Create database tables:

```sql
-- Run in Supabase SQL Editor
create table public.client_profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  first_name text,
  last_name text,
  phone text,
  created_at timestamptz default now()
);

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

6. Create storage buckets:
   - `profile-images`
   - `request-images`
   - `portfolio-images`

---

## 🎨 Customizing the App

### Change App Name

**File**: `pubspec.yaml`
```yaml
name: artisan_marketplace  # Change this
description: Your custom description
```

### Change App Colors

**File**: `lib/utils/app_theme.dart`
```dart
static const Color primaryColor = Color(0xFF1E3A8A); // Change this
static const Color accentColor = Color(0xFFF97316);  // Change this
```

### Change App Icon

1. Replace files in:
   - `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

2. Or use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) package

### Add New Dependencies

1. Add to `pubspec.yaml`:
```yaml
dependencies:
  your_package: ^1.0.0
```

2. Run:
```bash
flutter pub get
```

---

## 🐛 Troubleshooting

### Problem: "flutter: command not found"

**Solution**: Add Flutter to PATH
```bash
# macOS/Linux
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"

# Windows
# Add to System Environment Variables
```

### Problem: Build fails with "SDK version" error

**Solution**: Update Flutter
```bash
flutter upgrade
flutter pub upgrade
```

### Problem: Hot reload not working

**Solution**: 
- Try hot restart (press `R`)
- Or stop and re-run: `flutter run`

### Problem: Emulator not showing up

**Solution**:
```bash
# List available emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch <emulator-id>
```

### Problem: Gradle build fails (Android)

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problem: Pod install fails (iOS)

**Solution**:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

---

## 📚 Useful Resources

### Official Docs
- 📖 [Flutter Documentation](https://flutter.dev/docs)
- 📖 [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- 📖 [Riverpod Documentation](https://riverpod.dev)
- 📖 [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)

### IDE Setup
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Android Studio Flutter Plugin](https://plugins.jetbrains.com/plugin/9212-flutter)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)

---

## 🔥 Quick Tips

### 1. Use Code Snippets
In VS Code with Flutter extension:
- Type `stless` → StatelessWidget
- Type `stful` → StatefulWidget
- Type `cons` → ConsumerWidget

### 2. Debug Mode Tools
- Press `p` while running → Toggle performance overlay
- Press `w` → Toggle widget inspector
- Press `t` → Toggle text baseline

### 3. Keyboard Shortcuts (VS Code)
- `Ctrl+Shift+P` → Command palette
- `F5` → Start debugging
- `Ctrl+.` → Quick fix suggestions

### 4. Hot Reload Best Practices
- Works best with UI changes
- Doesn't work for:
  - `main()` changes
  - Static field initializers
  - Enum changes
  - Generic type changes

### 5. Performance Tips
- Use `const` constructors when possible
- Avoid heavy computations in `build()` method
- Use `ListView.builder` for long lists
- Enable `--profile` mode for performance testing

---

## 📝 Next Steps

Now that you're set up:

1. ✅ Read `PROJECT_OVERVIEW.md` for comprehensive project understanding
2. ✅ Read `ARCHITECTURE.md` for technical deep dive
3. ✅ Explore screens in `lib/screens/` folder
4. ✅ Try creating a test account
5. ✅ Make a small UI change and hot reload
6. ✅ Review `lib/providers/` to understand state management

### Want to Contribute?

1. Create a new branch: `git checkout -b feature/your-feature`
2. Make changes and test
3. Commit: `git commit -m "Add your feature"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 🆘 Need Help?

- Check existing issues on GitHub
- Review documentation files in this repo
- Ask in Flutter community forums
- Create a new issue with details

---

**Happy Coding! 🎉**

*You're now ready to build amazing features for the Mobile Artisan App!*
