import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

/// URL helper utilities
/// Common URL operations used across the app
class UrlHelpers {
  UrlHelpers._(); // Private constructor

  /// Launch a URL (handles web, app store, etc.)
  static Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      debugPrint('❌ Cannot launch URL: $url');
      return false;
    } catch (e) {
      debugPrint('❌ Error launching URL: $e');
      return false;
    }
  }

  /// Launch email with optional subject and body
  static Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    try {
      final emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: _encodeQueryParameters({
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        }),
      );

      return await launchURL(emailUri.toString());
    } catch (e) {
      debugPrint('❌ Error launching email: $e');
      return false;
    }
  }

  /// Launch phone call
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final telUri = Uri(scheme: 'tel', path: phoneNumber);
      return await launchURL(telUri.toString());
    } catch (e) {
      debugPrint('❌ Error launching phone: $e');
      return false;
    }
  }

  /// Helper to encode query parameters
  static String? _encodeQueryParameters(Map<String, String> params) {
    if (params.isEmpty) return null;
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  /// Validate if a string is a valid URL
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.hasAuthority || uri.hasAbsolutePath);
    } catch (e) {
      return false;
    }
  }
}


