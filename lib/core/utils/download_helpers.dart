import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'browser_download_stub.dart'
    if (dart.library.js_interop) 'browser_download_web.dart';

/// Download helper utility
/// Provides file download functionality for web and mobile platforms
class DownloadHelpers {
  DownloadHelpers._(); // Private constructor to prevent instantiation

  /// Download a file from the given URL
  ///
  /// For web: Creates an anchor element and triggers download
  /// For mobile: Opens the URL in external browser
  ///
  /// [url] - The URL or asset path to download
  /// [fileName] - Optional file name for the download (web only)
  ///
  /// Returns true if download was initiated successfully, false otherwise
  static Future<bool> downloadFile(
    String url, {
    String? fileName,
  }) async {
    try {
      if (kIsWeb) {
        // Web için dosyayı indir
        // Eğer URL ise direkt kullan, asset path ise web asset URL'sine çevir
        final href = _isAbsoluteUrl(url) ? url : '/${_toAssetPath(url)}';
        return triggerBrowserDownload(href, fileName: fileName);
      } else {
        // Mobil için harici tarayıcıda aç
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Download PDF file
  ///
  /// Convenience method for downloading PDF files
  ///
  /// [pdfUrl] - The PDF URL or asset path
  /// [fileName] - Optional PDF file name (defaults to 'CV.pdf')
  static Future<bool> downloadPdf(
    String pdfUrl, {
    String fileName = 'CV.pdf',
  }) {
    return downloadFile(pdfUrl, fileName: fileName);
  }

  static bool _isAbsoluteUrl(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  /// Normalizes an asset reference so it always starts with `assets/`
  static String _toAssetPath(String url) =>
      url.startsWith('assets/') ? url : 'assets/$url';
}
