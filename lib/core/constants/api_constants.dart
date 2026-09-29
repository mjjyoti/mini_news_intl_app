class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://newsapi.org/v2';

  static const String apiKey = 'dd52527adc384baeaf8acaafea306a50';

  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  static const List<String> categories = [
    'business',
    'technology',
    'science',
    'health',
    'entertainment',
    'sports',
    'general',
  ];

  static const int pageSize = 20;
  static const String defaultCountry = 'us';
}
