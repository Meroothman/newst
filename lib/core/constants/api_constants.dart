class ApiConstants {
  // Base URL
  static const String baseUrl = "https://gnews.io/api/v4";

  // API Key - Replace with your own key
  static const String apiKey = "258e614a59084eba63d41f093206a12e";

  // Endpoints
  static const String topHeadlines = "/top-headlines";
  static const String search = "/search";

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
