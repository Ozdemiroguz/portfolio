import 'dart:ui_web' as ui_web;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';

/// PDF viewer widget
/// Shows PDF in iframe for web, or opens in external browser for mobile
class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerWidget({super.key, required this.pdfUrl});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  String _getPdfSrc() {
    // Eğer URL ise direkt kullan
    if (widget.pdfUrl.startsWith('http://') || widget.pdfUrl.startsWith('https://')) {
      return widget.pdfUrl;
    }
    // Asset path ise (assets/ ile başlıyorsa veya başlamıyorsa), web için asset URL'sine çevir
    final assetPath = widget.pdfUrl.startsWith('assets/')
        ? widget.pdfUrl
        : 'assets/${widget.pdfUrl}';
    // Web'de asset'leri /assets/ prefix'i ile kullanırız
    return '/$assetPath';
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Register platform view for web
      final pdfSrc = _getPdfSrc();
      ui_web.platformViewRegistry.registerViewFactory('pdf-viewer', (
        int viewId,
      ) {
        final iframe = html.IFrameElement()
          ..src = pdfSrc
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.margin = '0'
          ..style.padding = '0';
        return iframe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Web için iframe kullan
      return Container(
        color: AppColors.backgroundDark1,
        child: HtmlElementView(viewType: 'pdf-viewer'),
      );
    } else {
      // Mobil için PDF'i harici tarayıcıda açma mesajı göster
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              tr('cv.openInExternalBrowser'),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }
  }
}
