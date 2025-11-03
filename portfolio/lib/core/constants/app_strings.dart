/// Application string constants
/// All hardcoded strings, keys, and IDs should be defined here
/// For user-facing text, use easy_localization with translation keys
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // App Info
  static const String appName = 'Portfolio';
  static const String appVersion = '1.0.0';

  // App Type Keys
  static const String appTypeAbout = 'about';
  static const String appTypeCareer = 'career';
  static const String appTypeProject = 'project';
  static const String appTypeContact = 'contact';
  static const String appTypeAchievement = 'achievement';
  static const String appTypeEducation = 'education';
  static const String appTypeReference = 'reference';
  static const String appTypeGame = 'game';

  // Portfolio Type
  static const String portfolioTypeMobile = 'mobile';
  static const String portfolioTypeDesktop = 'desktop';
  static const String portfolioTypeWeb = 'web';

  // Project Status
  static const String projectStatusCompleted = 'completed';
  static const String projectStatusInProgress = 'in_progress';
  static const String projectStatusPlanned = 'planned';

  // Social Media Keys
  static const String socialGithub = 'github';
  static const String socialLinkedIn = 'linkedin';
  static const String socialTwitter = 'twitter';
  static const String socialEmail = 'email';
  static const String socialWebsite = 'website';

  // Storage Keys (for local storage/cache)
  static const String keyLanguage = 'app_language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyDomain = 'portfolio_domain';

  // Default Values
  static const String defaultDomain = 'oguz';
  static const String defaultLocale = 'tr';
  static const String fallbackLocale = 'en';

  // URLs
  static const String githubBaseUrl = 'https://github.com/';
  static const String linkedInBaseUrl = 'https://linkedin.com/in/';
  static const String twitterBaseUrl = 'https://twitter.com/';

  // File Paths
  static const String imagesPath = 'assets/images/';
  static const String translationsPath = 'assets/translations/';

  // Error Messages (technical - not user facing)
  static const String errorDataNotFound = 'Data not found';
  static const String errorInvalidData = 'Invalid data format';
  static const String errorNetworkFailure = 'Network request failed';
  static const String errorUnknown = 'Unknown error occurred';

  // Date Format Patterns
  static const String dateFormatFull = 'dd MMMM yyyy';
  static const String dateFormatShort = 'dd/MM/yyyy';
  static const String dateFormatMonthYear = 'MMMM yyyy';

  // Animation Durations (in milliseconds)
  static const int animationDurationFast = 200;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;

  // Debounce Delays
  static const int debounceDelayShort = 300;
  static const int debounceDelayMedium = 500;
  static const int debounceDelayLong = 1000;
}
