class AppConstants {
  // SharedPreferences Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySelectedLanguage = 'selected_language';
  static const String keySelectedCountry = 'selected_country';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPhone = 'user_phone';
  
  // Hive Box Names
  static const String bookmarksBox = 'bookmarks';
  
  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'us';
  
  // Categories
  static const List<String> categories = [
    "general",
    "world",
    "nation",
    "business",
    "technology",
    "health",
    "science",
    "sports",
    "entertainment",
  ];
  
  // Languages
  static const Map<String, String> languages = {
    'en': 'English',
    'ar': 'Arabic',
    'tr': 'Turkish',
  };
  
  // Countries with their codes
  static const Map<String, String> countries = {
    'us': 'United States',
    'au': 'Australia',
    'gb': 'United Kingdom',
    'ca': 'Canada',
    'in': 'India',
    'eg': 'Egypt',
    'sa': 'Saudi Arabia',
    'ae': 'United Arab Emirates',
    'tr': 'Turkey',
    'de': 'Germany',
    'fr': 'France',
  };
}