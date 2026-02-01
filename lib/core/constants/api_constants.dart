class ApiConstants {
  // Base URL
  static const String baseUrl = "https://gnews.io/api/v4";
  
  // API Key - Replace with your own key
  static const String apiKey = "c0b62ba29edceb47ce72700aae117f85";
  
  // Endpoints
  static const String topHeadlines = "/top-headlines";
  static const String search = "/search";
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}