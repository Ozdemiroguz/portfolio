import 'package:intl/intl.dart';
import '../constants/app_strings.dart';

/// Helper functions for date operations
class DateHelpers {
  DateHelpers._(); // Private constructor

  /// Parse dynamic value to DateTime
  /// Handles String and DateTime types
  static DateTime parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  /// Format DateTime to full date string (dd MMMM yyyy)
  static String formatDateFull(DateTime date, [String? locale]) {
    final formatter = DateFormat(AppStrings.dateFormatFull, locale);
    return formatter.format(date);
  }

  /// Format DateTime to short date string (dd/MM/yyyy)
  static String formatDateShort(DateTime date, [String? locale]) {
    final formatter = DateFormat(AppStrings.dateFormatShort, locale);
    return formatter.format(date);
  }

  /// Format DateTime to month and year (MMMM yyyy)
  static String formatMonthYear(DateTime date, [String? locale]) {
    final formatter = DateFormat(AppStrings.dateFormatMonthYear, locale);
    return formatter.format(date);
  }

  /// Calculate duration between two dates
  /// Returns formatted string like "2 years 3 months"
  static String calculateDuration(
    DateTime startDate,
    DateTime? endDate, {
    String? locale,
  }) {
    final end = endDate ?? DateTime.now();
    final difference = end.difference(startDate);

    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0 && months > 0) {
      return '$years year${years > 1 ? 's' : ''} $months month${months > 1 ? 's' : ''}';
    } else if (years > 0) {
      return '$years year${years > 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months month${months > 1 ? 's' : ''}';
    } else {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Get relative time string (e.g., "2 hours ago", "3 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = difference.inDays ~/ 365;
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = difference.inDays ~/ 30;
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
