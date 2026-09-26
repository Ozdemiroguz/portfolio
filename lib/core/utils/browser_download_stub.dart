// Non-web implementation. Browser downloads only exist on the web,
// so this no-op keeps the helper compiling on other platforms.

/// Triggers a browser download for [href]. Always false outside the web.
bool triggerBrowserDownload(String href, {String? fileName}) => false;
