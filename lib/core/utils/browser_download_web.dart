import 'package:web/web.dart' as web;

/// Triggers a browser download for [href] by clicking a temporary anchor.
bool triggerBrowserDownload(String href, {String? fileName}) {
  final anchor = web.HTMLAnchorElement()..href = href;
  if (fileName != null) {
    anchor.setAttribute('download', fileName);
  }
  anchor.click();
  return true;
}
