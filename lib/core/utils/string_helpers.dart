/// Helper functions for string operations
class StringHelpers {
  StringHelpers._(); // Private constructor

  /// Check if string is null or empty
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Check if string is not null and not empty
  static bool isNotNullOrEmpty(String? value) {
    return !isNullOrEmpty(value);
  }

  /// Capitalize first letter of string
  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate string to max length with ellipsis
  static String truncate(String value, int maxLength, {String ellipsis = '...'}) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}$ellipsis';
  }

  /// Remove all whitespace from string
  static String removeWhitespace(String value) {
    return value.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string is a valid email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Check if string is a valid URL
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Format phone number (basic)
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 10) return phone;

    // Format as: +XX XXX XXX XXXX
    if (digits.length == 10) {
      return '+${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8)}';
    }

    return phone;
  }

  /// Parse comma-separated string to list
  static List<String> parseCommaSeparated(String value) {
    return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Join list to comma-separated string
  static String joinWithComma(List<String> values) {
    return values.join(', ');
  }

  /// Remove HTML tags from string
  static String stripHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Convert string to slug (URL-friendly)
  static String toSlug(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// Get initials from full name
  static String getInitials(String fullName, {int maxLength = 2}) {
    final words = fullName.trim().split(RegExp(r'\s+'));
    final initials = words.map((word) => word.isNotEmpty ? word[0].toUpperCase() : '').join();
    return initials.substring(0, initials.length > maxLength ? maxLength : initials.length);
  }

  /// Mask sensitive data (e.g., email, phone)
  static String mask(String value, {int visibleStart = 3, int visibleEnd = 2, String maskChar = '*'}) {
    if (value.length <= visibleStart + visibleEnd) return value;

    final start = value.substring(0, visibleStart);
    final end = value.substring(value.length - visibleEnd);
    final masked = maskChar * (value.length - visibleStart - visibleEnd);

    return '$start$masked$end';
  }
}
