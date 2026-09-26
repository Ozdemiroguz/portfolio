// Non-web implementation. The PDF iframe only exists on the web,
// so these are no-ops that keep the widget compiling on other platforms.

/// Returns the `<base href>` of the page, or null when not on the web.
String? readBaseHref() => null;

/// Registers the iframe platform view. No-op outside the web.
void registerPdfViewFactory(String viewType, String src) {}
