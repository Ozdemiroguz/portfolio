# 🎨 Portfolio - Interactive Web Experience

<div align="center">

![Portfolio Banner](assets/images/my_photo.webp)

### Oğuzhan Özdemir
**Flutter Developer | Mobile & Web Specialist**

[![Live Demo](https://img.shields.io/badge/🌐_Live_Demo-Visit_Portfolio-blue?style=for-the-badge)](https://ozdemiroguz.github.io)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/oguzhanozdemirflutterdev/)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github)](https://github.com/Ozdemiroguz)

</div>

---

## ✨ About This Project

A modern, interactive portfolio built with **Flutter Web** that showcases my projects, experience, and skills through a unique iOS-inspired interface. This isn't just a portfolio—it's an experience!

### 🎯 Key Features

- 📱 **iOS-Inspired UI** - Familiar iPhone-like interface with app icons, folders, and smooth animations
- 🌍 **Bilingual Support** - Full Turkish & English localization using `easy_localization`
- 🎮 **Interactive Games** - Built-in Snake & Tetris games for fun!
- 📊 **Dynamic Content** - All content managed through centralized data structure
- 🎨 **Beautiful Animations** - Smooth transitions and engaging user interactions
- 📱 **Responsive Design** - Works seamlessly on desktop, tablet, and mobile
- 🏗️ **Clean Architecture** - Follows best practices with separation of concerns

---

## 🚀 Live Demo

**Visit:** [ozdemiroguz.github.io](https://ozdemiroguz.github.io)

### What You'll Find:

- 💼 **Portfolio** - Showcase of my professional work and projects
- 🎯 **Projects** - Detailed project descriptions with screenshots
  - Movie App - Clean Architecture showcase
  - JoyLive - Live streaming platform
  - SoundCare - Speaker cleaning app
  - TRHaber - Major news platform
  - And many more...
- 👨‍💻 **Career** - Professional experience timeline
- 🏆 **Achievements** - Certifications and accomplishments
- 📧 **Contact** - Multiple ways to get in touch
- 📸 **Gallery** - Visual showcase of all projects
- 📄 **CV** - Downloadable resume

---

## 🛠️ Tech Stack

### Core Technologies

```yaml
Flutter: 3.x
Dart: 3.x
Platform: Web (with mobile support)
```

### Key Packages

- **State Management:** `flutter_bloc` - Predictable state management
- **Routing:** `go_router` - Declarative routing solution
- **Internationalization:** `easy_localization` - Multi-language support
- **UI Components:**
  - `carousel_slider` - Image carousels
  - `flutter_map` - Interactive maps
  - `url_launcher` - External link handling
- **Icons:** `cupertino_icons` - iOS-style icons

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a clear separation of concerns:

```
lib/
├── core/                   # Core utilities and constants
│   ├── constants/         # App-wide constants (colors, sizes, strings)
│   ├── theme/            # Theme configuration
│   └── utils/            # Helper utilities (translation, URL, date)
├── data/                  # Data layer
│   ├── datasources/      # Data sources (local, remote)
│   ├── models/           # Data models
│   └── repositories/     # Repository implementations
├── domain/                # Domain layer
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository contracts
│   └── usecases/         # Business logic
└── presentation/          # Presentation layer
    ├── shared/           # Shared widgets
    └── [features]/       # Feature-specific screens & widgets
```

### Design Patterns Used

- ✅ **Repository Pattern** - Data abstraction
- ✅ **BLoC Pattern** - State management
- ✅ **Dependency Injection** - Loose coupling
- ✅ **Factory Pattern** - Object creation
- ✅ **Widget Composition** - Reusable components

---

## 🎨 Features Showcase

### 📱 Interactive Apps

Each "app" in the portfolio is a fully functional mini-application:

| App | Description | Tech Stack |
|-----|-------------|-----------|
| 📧 **Messages** | Chat interface with AI responses | BLoC, Animations |
| 📞 **Phone** | Interactive phone dialer | Custom UI |
| 🌐 **Browser** | In-app browser with Dino game | WebView alternative |
| 🎮 **Games** | Snake & Tetris | Custom game logic |
| 📸 **Gallery** | Project image showcase | Grid view |
| 📄 **CV** | PDF viewer | dart:html |
| 🗺️ **Map** | Interactive location map | flutter_map |

---

## 🚀 Getting Started

### Prerequisites

```bash
Flutter SDK: >=3.0.0
Dart SDK: >=3.0.0
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ozdemiroguz/portfolio.git
   cd portfolio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For mobile
   flutter run
   ```

4. **Build for production**
   ```bash
   # Web build
   flutter build web --release --base-href "/"
   
   # Android build
   flutter build apk --release
   
   # iOS build
   flutter build ios --release
   ```

---

## 📦 Project Structure Highlights

### Utility Helpers

**TranslationHelpers** - Centralized translation management
```dart
// Try to translate, fallback to original value
final text = TranslationHelpers.tryTranslate(key, originalValue);
```

**UrlHelpers** - Unified URL/Email/Phone handling
```dart
// Launch any type of link safely
await UrlHelpers.launchURL(url);
await UrlHelpers.launchEmail(email, subject: 'Hello');
await UrlHelpers.launchPhone(phoneNumber);
```

### Component-Based Architecture

Projects screen is broken down into reusable components:
- `ProjectImageCarouselWidget` - Image carousel
- `ProjectHeaderWidget` - Title, date, client info
- `ProjectTechnologiesWidget` - Tech stack chips
- `ProjectFeaturesWidget` - Feature bullet list
- `ProjectLinksWidget` - External links

**Benefits:**
- ✅ Highly maintainable (each component ~60-90 lines)
- ✅ Reusable across different screens
- ✅ Independently testable
- ✅ Easy to modify without affecting others

---

## 🌍 Internationalization

Full bilingual support with `easy_localization`:

```dart
// Translation files
assets/translations/
  ├── en.json    # English translations
  └── tr.json    # Turkish translations

// Usage
Text(tr('portfolio.title'))
```

**Supported Languages:** 🇬🇧 English | 🇹🇷 Türkçe

---

## 🎯 Performance Optimizations

- ⚡ **Tree-shaking** - Icon fonts reduced by 99%
- 🎨 **Lazy loading** - Components load on demand
- 📦 **Asset optimization** - WebP images for smaller size
- 🔄 **Efficient rebuilds** - BLoC pattern prevents unnecessary rebuilds
- 💾 **Caching** - Smart caching of remote data

---

## 📱 Responsive Design

The portfolio adapts seamlessly to different screen sizes:

| Screen Size | Layout | Features |
|-------------|--------|----------|
| **Desktop (≥1200px)** | Dual panel | Content + Info panel |
| **Tablet (768-1199px)** | Single panel | Optimized spacing |
| **Mobile (<768px)** | Compact | Touch-friendly UI |

---

## 🤝 Contributing

While this is a personal portfolio, I'm open to suggestions and improvements!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📈 Code Quality

- ✅ **0 Linter Errors** - Clean code
- ✅ **Null Safety** - Fully null-safe
- ✅ **Type Safety** - Strong typing throughout
- ✅ **Documentation** - Well-documented code
- ✅ **Consistent Style** - Following Dart/Flutter conventions

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 📬 Contact

**Oğuzhan Özdemir**

- 📧 Email: [ozdemiroguzhan55@gmail.com](mailto:ozdemiroguzhan55@gmail.com)
- 💼 LinkedIn: [oguzhanozdemirflutterdev](https://www.linkedin.com/in/oguzhanozdemirflutterdev/)
- 🐦 Twitter: [@birsalbe](https://x.com/birsalbe)
- 📝 Medium: [@7oughapps1](https://medium.com/@7oughapps1)
- 🌐 Portfolio: [ozdemiroguz.github.io](https://ozdemiroguz.github.io)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community packages that made this possible
- Everyone who provided feedback and support

---

<div align="center">

### ⭐ If you like this project, give it a star!

**Built with ❤️ using Flutter**

[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)

</div>
