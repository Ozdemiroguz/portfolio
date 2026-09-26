import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

/// Returns the `<base href>` of the page, or null when no base element exists.
String? readBaseHref() =>
    web.document.querySelector('base')?.getAttribute('href');

/// Registers an iframe platform view that renders [src].
void registerPdfViewFactory(String viewType, String src) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = web.HTMLIFrameElement()..src = src;
    iframe.style
      ..border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..margin = '0'
      ..padding = '0';
    return iframe;
  });
}
