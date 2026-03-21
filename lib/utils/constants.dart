class AppConstants {
  static const String appName = 'ProfileForge AI';
  static const String appVersion = '1.0.0';
  static const String defaultEndpoint = 'https://sai.sharedllm.com/v1/chat/completions';
  static const String defaultModel = 'gpt-oss:120b';

  static const List<String> availableModels = [
    'gpt-oss:120b',
    'gpt-oss:70b',
    'gpt-oss:8b',
  ];

  static const List<String> targetRoles = [
    'Software Engineer',
    'Product Manager',
    'Data Scientist',
    'UX Designer',
    'Marketing Manager',
    'Sales Executive',
    'HR Professional',
    'Finance Analyst',
    'Consultant',
    'Entrepreneur',
    'Other',
  ];

  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String endpointKey = 'api_endpoint';
  static const String modelKey = 'api_model';
  static const String themeKey = 'dark_theme';
  static const String favoritesKey = 'favorites';
}
