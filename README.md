# 📰 Newst - Flutter News Application

<div align="center">
  <img src="assets/images/app_logo.png" alt="Newst Logo" width="150"/>
  
  <p><strong>A modern, feature-rich news application built with Flutter</strong></p>
  
  [![Flutter Version](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey.svg)](https://flutter.dev/)
</div>

---

## 📱 About

**Newst** is a beautiful and intuitive news application that brings you the latest headlines from around the world. Built with Flutter and following Clean Architecture principles, it provides a seamless experience across iOS and Android devices.

### ✨ Key Features

- 🌍 **Multi-Language Support** - English, Arabic, and Turkish
- 🌎 **Multi-Country News** - 11+ countries including US, UK, Egypt, Saudi Arabia
- 📑 **9 News Categories** - General, Technology, Sports, Business, Health, Science, Entertainment, World, and Nation
- 🔍 **Smart Search** - Find news articles with intelligent debounced search
- 🔖 **Bookmark System** - Save articles for offline reading
- 🎨 **Beautiful UI** - Modern design with smooth animations
- 🔄 **Pull to Refresh** - Easy content updates
- 💪 **Robust Error Handling** - Professional error recovery
- 🌐 **Network Awareness** - Smart connectivity checking
- ⚡ **Fast & Efficient** - Optimized performance

---

## 📸 Screenshots

<div align="center">
  <img src="screenshots/home.png" width="250" alt="Home Screen"/>
  <img src="screenshots/search.png" width="250" alt="Search Screen"/>
  <img src="screenshots/bookmarks.png" width="250" alt="Bookmarks Screen"/>
</div>

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** pattern for state management.

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   │   ├── api_constants.dart     # API configuration
│   │   ├── app_colors.dart        # Color palette
│   │   └── app_constants.dart     # General constants
│   ├── error/                      # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure types
│   ├── network/                    # Network utilities
│   │   ├── network_info.dart      # Network interface
│   │   └── network_info_impl.dart # Network implementation
│   └── utils/                      # Utility functions
│       └── date_time_helper.dart  # Date formatting
│
├── features/                       # Feature modules
│   ├── bookmark/                   # Bookmark feature
│   │   ├── data/
│   │   │   ├── datasources/       # Local data source
│   │   │   └── repositories/      # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/          # Bookmark entity
│   │   │   ├── repositories/      # Repository interface
│   │   │   └── usecases/          # Business logic
│   │   └── presentation/
│   │       ├── cubit/             # State management
│   │       └── pages/             # UI screens
│   │
│   ├── news/                       # News feature
│   │   ├── data/
│   │   │   ├── datasources/       # Remote API data source
│   │   │   ├── models/            # Data models
│   │   │   └── repositories/      # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/          # News entity
│   │   │   ├── repositories/      # Repository interface
│   │   │   └── usecases/          # Business logic
│   │   └── presentation/
│   │       ├── cubit/             # State management
│   │       ├── pages/             # UI screens
│   │       └── widgets/           # Reusable widgets
│   │
│   ├── settings/                   # Settings feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── presentation/               # Shared UI
│       ├── main_navigation_screen.dart
│       └── onboarding_screen.dart
│
├── injection_container.dart        # Dependency injection
├── main.dart                       # App entry point
└── splash_screen.dart             # Splash screen
```

### 🔄 Architecture Layers

1. **Presentation Layer**
   - BLoC/Cubit for state management
   - UI components and screens
   - User interaction handling

2. **Domain Layer**
   - Business logic (Use Cases)
   - Entity definitions
   - Repository interfaces

3. **Data Layer**
   - Repository implementations
   - Data sources (Remote & Local)
   - Data models

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/newst.git
   cd newst
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get your API Key**
   - Visit [GNews.io](https://gnews.io/)
   - Sign up for a free account
   - Copy your API key

4. **Configure API Key**
   
   Open `lib/core/constants/api_constants.dart`:
   ```dart
   static const String apiKey = "YOUR_API_KEY_HERE";
   ```

5. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Networking
  dio: ^5.3.3
  connectivity_plus: ^5.0.2
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # UI
  shimmer: ^3.0.0
  intl: ^0.18.1

dev_dependencies:
  # Code Generation
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

---

## 🔧 Configuration

### API Configuration

**File**: `lib/core/constants/api_constants.dart`

```dart
class ApiConstants {
  static const String baseUrl = "https://gnews.io/api/v4";
  static const String apiKey = "YOUR_API_KEY_HERE";
  static const String topHeadlines = "/top-headlines";
  static const String search = "/search";
  
  // Free tier limits
  static const int dailyLimit = 100;      // requests per day
  static const int minuteLimit = 10;      // requests per minute
}
```

### App Configuration

**File**: `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // Default Settings
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'us';
  
  // Categories
  static const List<String> categories = [
    "general", "world", "nation", "business",
    "technology", "health", "science", "sports",
    "entertainment",
  ];
  
  // Languages
  static const Map<String, String> languages = {
    'en': 'English',
    'ar': 'Arabic',
    'tr': 'Turkish',
  };
  
  // Countries
  static const Map<String, String> countries = {
    'us': 'United States',
    'gb': 'United Kingdom',
    'eg': 'Egypt',
    'sa': 'Saudi Arabia',
    // ... more countries
  };
}
```

---

## 🎨 Features in Detail

### 1. News Feed
- **Trending Section**: Top 5 headlines with image carousel
- **Category Tabs**: Quick category switching
- **Infinite Scroll**: Load more articles as you scroll
- **Pull to Refresh**: Swipe down to refresh content
- **Error Recovery**: Retry button for failed loads

### 2. Search
- **Debounced Search**: 500ms delay to reduce API calls
- **Minimum Characters**: Requires 2+ characters
- **Popular Topics**: Quick search chips
- **Search History**: Remember recent searches (future feature)
- **Smart Filtering**: Respects language and country settings

### 3. Bookmarks
- **Offline Storage**: Save articles locally with Hive
- **Quick Access**: Tap to bookmark/unbookmark
- **Persistent**: Data survives app restarts
- **Visual Indicator**: Red bookmark icon for saved articles

### 4. Settings
- **Language Selection**: 3 languages supported
- **Country Selection**: 11+ countries
- **Profile Info**: Store name, email, phone
- **Onboarding**: First-time user experience

### 5. Error Handling
- **Network Errors**: Detect no internet connection
- **API Errors**: Handle 401, 403, 429, 500 status codes
- **Timeouts**: Connection and receive timeout handling
- **User-Friendly Messages**: Clear error descriptions
- **Retry Options**: Easy recovery from errors

---

## 🔒 API Rate Limits

### Free Tier (GNews.io)
- ⚠️ **100 requests per day**
- ⚠️ **10 requests per minute**

### Best Practices
1. Use search debouncing (implemented)
2. Cache results when possible
3. Limit initial data load
4. Monitor API usage in GNews dashboard

### Upgrade Options
- **Pro**: $9/month - 10,000 requests/day
- **Business**: $49/month - 100,000 requests/day
- **Enterprise**: Custom pricing

---

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **Error 403: API Access Denied**
**Problem**: Invalid or expired API key

**Solution**:
```bash
1. Get new API key from https://gnews.io/
2. Update lib/core/constants/api_constants.dart
3. Restart app
```

#### 2. **Data Not Loading**
**Problem**: Network or initialization issue

**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

#### 3. **Build Errors**
**Problem**: Code generation needed

**Solution**:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 4. **Hive Errors**
**Problem**: Database schema changed

**Solution**:
```bash
# Clear app data
flutter clean

# Reinstall app
flutter run
```

#### 5. **Arabic/Wrong Language Results**
**Problem**: Language settings

**Solution**:
- Check `defaultLanguage` in `app_constants.dart`
- Change to `'en'` for English
- Or update in app: Profile → Language → English

---

## 📈 Performance Optimization

### Implemented Optimizations

1. **Image Caching**
   - Network images cached automatically
   - Reduces bandwidth usage

2. **Lazy Loading**
   - BLoC providers created only when needed
   - Singleton pattern for SettingsCubit

3. **Debounced Search**
   - Reduces API calls by 90%
   - Better user experience

4. **Shimmer Loading**
   - Shows placeholder while loading
   - Perceived performance improvement

5. **Result Limiting**
   - Headlines: 10 articles
   - Search: 20 articles
   - Prevents overwhelming UI

---

## 🔐 Security

### Best Practices Implemented

1. **API Key Protection**
   - Never commit API keys to version control
   - Use environment variables in production
   - Implement key rotation

2. **Data Validation**
   - Input sanitization
   - Null safety
   - Error boundaries

3. **Network Security**
   - HTTPS only
   - Certificate pinning (future)
   - Timeout protection

---

## 🚢 Deployment

### Android Release

1. **Configure signing**
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. **Update build.gradle**
   ```gradle
   signingConfigs {
       release {
           storeFile file("~/key.jks")
           storePassword "password"
           keyAlias "key"
           keyPassword "password"
       }
   }
   ```

3. **Build APK**
   ```bash
   flutter build apk --release
   ```

4. **Build App Bundle** (recommended)
   ```bash
   flutter build appbundle --release
   ```

### iOS Release

1. **Configure in Xcode**
   - Open `ios/Runner.xcworkspace`
   - Set up signing & capabilities
   - Configure bundle ID

2. **Build IPA**
   ```bash
   flutter build ipa --release
   ```

3. **Upload to App Store Connect**
   ```bash
   xcrun altool --upload-app --type ios --file build/ios/ipa/*.ipa --username "your@email.com" --password "app-specific-password"
   ```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Contribution Guidelines

- Follow Flutter style guide
- Write meaningful commit messages
- Add tests for new features
- Update documentation
- Ensure all tests pass

---

## 📝 Changelog

### Version 1.1.0 (Current)
- ✅ Added comprehensive error handling
- ✅ Implemented network connectivity checking
- ✅ Added debounced search
- ✅ Improved UI/UX with retry buttons
- ✅ Better loading states
- ✅ Pull-to-refresh functionality
- ✅ Enhanced error messages
- 🐛 Fixed dependency injection order
- 🐛 Fixed data not loading on startup
- 🐛 Fixed 403 API errors

### Version 1.0.0
- 🎉 Initial release
- ✅ News feed with categories
- ✅ Search functionality
- ✅ Bookmark system
- ✅ Multi-language support
- ✅ Settings management
- ✅ Onboarding flow

---

## 📚 Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GNews API Docs](https://gnews.io/docs/v4)

### Tutorials
- [Flutter BLoC Tutorial](https://bloclibrary.dev/#/gettingstarted)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Hive Database](https://docs.hivedb.dev/)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 Newst

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👥 Authors

- **Your Name** - *Initial work* - [YourGitHub](https://github.com/yourusername)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- [GNews.io](https://gnews.io/) for the news API
- BLoC library maintainers
- Clean Architecture community
- All contributors and testers

---

## 📞 Support

### Having Issues?

1. Check [Troubleshooting](#-troubleshooting) section
2. Search [Issues](https://github.com/yourusername/newst/issues)
3. Create a new issue with:
   - Flutter version (`flutter --version`)
   - Device/Emulator info
   - Steps to reproduce
   - Screenshots if applicable

### Feature Requests

Have an idea? [Open a feature request](https://github.com/yourusername/newst/issues/new?template=feature_request.md)

---

## 🌟 Star History

If you found this project helpful, please give it a ⭐️!

---

## 📱 Connect

- **GitHub**: [@yourusername](https://github.com/yourusername)
- **Twitter**: [@yourhandle](https://twitter.com/yourhandle)
- **LinkedIn**: [Your Name](https://linkedin.com/in/yourname)
- **Email**: your.email@example.com

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>© 2026 Newst. All rights reserved.</p>
</div>