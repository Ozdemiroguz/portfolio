/// App türlerine göre icon eşleştirmesi için utility sınıfı
/// Firebase structure'dan tüm app türleri için detaylı mapping
class AppIconUtils {
  /// App türüne göre asset icon path'ini döndürür
  static String getAssetByType(String type) {
    switch (type.toLowerCase()) {
      // === DETAYLI APPS (Form ile oluşturulan) ===

      // Project Apps
      case 'project':
      case 'projects':
        return 'projects';

      // Education Apps
      case 'education':
      case 'school':
      case 'university':
      case 'course':
      case 'learning':
        return 'education';

      // Career Apps
      case 'career':
      case 'work':
      case 'job':
      case 'employment':
      case 'experience':
        return 'career';

      // Contact Apps
      case 'contact':
      case 'communication':
      case 'message':
      case 'mail':
      case 'email':
        return 'communication';

      // Achievement Apps
      case 'achievement':
      case 'award':
      case 'certificate':
      case 'recognition':
      case 'competition':
      case 'success':
        return 'achievement';

      // About Apps
      case 'about':
      case 'profile':
      case 'bio':
      case 'personal':
      case 'info':
        return 'about';

      // Reference Apps
      case 'reference':
      case 'recommendation':
      case 'testimonial':
      case 'review':
        return 'reference';

      // === SISTEM APPS (Telefon benzeri) ===

      // Camera Apps
      case 'camera':
      case 'photo':
      case 'picture':
      case 'gallery':
        return 'camera';

      // Phone Apps
      case 'phone':
      case 'call':
      case 'dialer':
      case 'contacts':
        return 'phone';

      // Message Apps
      case 'messages':
      case 'sms':
      case 'chat':
      case 'messenger':
        return 'communication';

      // Email Apps
      case 'gmail':
      case 'outlook':
      case 'yahoo':
        return 'gmail';

      // === SOSYAL MEDYA & LINKLER ===

      // GitHub
      case 'github':
      case 'git':
      case 'repository':
      case 'repo':
        return 'github';

      // LinkedIn
      case 'linkedin':
      case 'professional':
        return 'linkedin';

      // Instagram
      case 'instagram':
      case 'insta':
        return 'instagram';

      // Twitter
      case 'twitter':
      case 'x':
        return 'twitter';

      // YouTube
      case 'youtube':
      case 'video':
        return 'youtube';

      // Website
      case 'website':
      case 'web':
      case 'site':
      case 'portfolio':
        return 'website';

      // === OYUN APPS ===

      // Snake Game
      case 'game1':
      case 'snake':
      case 'snake_game':
        return 'snake';

      // Dice Game
      case 'game2':
      case 'dice':
      case 'dice_game':
        return 'dice';

      // Ghost Game
      case 'game3':
      case 'ghost':
      case 'ghost_game':
        return 'ghost';

      // Generic Games
      case 'game':
      case 'games':
      case 'gaming':
        return 'dice'; // Default game icon

      // === ÖZEL APPS ===

      // Download/Files
      case 'custom1':
      case 'download':
      case 'downloads':
      case 'file':
      case 'files':
        return 'download';

      // App Store
      case 'custom2':
      case 'appstore':
      case 'app_store':
      case 'store':
        return 'appstore';

      // Live/Streaming
      case 'custom3':
      case 'live':
      case 'streaming':
      case 'broadcast':
        return 'live';

      // === VARSAYILAN ===

      default:
        return 'unknown';
    }
  }

  /// App türüne göre fallback icon döndürür (Material Icons)
  static String getFallbackIconByType(String type) {
    switch (type.toLowerCase()) {
      case 'project':
      case 'projects':
        return 'work';

      case 'education':
      case 'school':
      case 'university':
        return 'school';

      case 'career':
      case 'work':
      case 'job':
        return 'work_outline';

      case 'contact':
      case 'communication':
        return 'contact_mail';

      case 'achievement':
      case 'award':
        return 'emoji_events';

      case 'about':
      case 'profile':
        return 'person';

      case 'reference':
        return 'recommend';

      case 'camera':
      case 'photo':
        return 'camera_alt';

      case 'phone':
      case 'call':
        return 'phone';

      case 'messages':
      case 'sms':
      case 'chat':
        return 'message';

      case 'game':
      case 'games':
      case 'game1':
      case 'game2':
      case 'game3':
        return 'games';

      case 'download':
      case 'downloads':
        return 'download';

      default:
        return 'apps';
    }
  }

  /// Tüm desteklenen app türlerini döndürür
  static List<String> getSupportedTypes() {
    return [
      // Detaylı Apps
      'project',
      'education',
      'career',
      'contact',
      'achievement',
      'about',
      'reference',

      // Sistem Apps
      'camera', 'phone', 'messages',

      // Oyun Apps
      'game1', 'game2', 'game3',

      // Özel Apps
      'custom1', 'custom2', 'custom3',

      // Sosyal Medya
      'github', 'linkedin', 'instagram', 'twitter', 'youtube', 'website',
    ];
  }
}
