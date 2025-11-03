# Flutter Portfolio Project - Coding Rules & Architecture

## 🏗️ Architecture: MVVM + Clean Architecture + Cubit

### Layer Structure
lib/ ├── core/ # Shared utilities, constants, base classes │ ├── constants/ # App constants, colors, strings │ ├── theme/ # Theme configuration │ ├── utils/ # Helper functions, extensions │ └── widgets/ # Reusable base widgets ├── data/ # Data Layer │ ├── models/ # Data models (JSON serializable) │ ├── repositories/ # Repository implementations │ └── datasources/ # Data sources (local, remote) ├── domain/ # Domain Layer (Business Logic) │ ├── entities/ # Business entities │ ├── repositories/ # Repository interfaces │ └── usecases/ # Business use cases ├── presentation/ # Presentation Layer (UI) │ ├── about/ │ │ ├── cubit/ # State management │ │ ├── widgets/ # Feature-specific widgets │ │ └── about_screen.dart │ ├── career/ │ ├── projects/ │ ├── contact/ │ └── ... └── main.dart

---

## 🚫 STRICT RULES - NO EXCEPTIONS

### 1. Widget Rules
- ❌ **NO function widgets** (`Widget _buildSomething()`)
- ✅ **ONLY class-based widgets** (`class SomethingWidget extends StatelessWidget`)
- ✅ Each widget in its **own separate file**
- ✅ Widget names must end with `Widget` (e.g., `HeaderWidget`, `ProfileCardWidget`)

### 2. File & Class Rules
- ❌ **NO multiple classes in one file** (except private helper classes if absolutely necessary)
- ✅ One file = One public class
- ✅ File name = Class name in snake_case (e.g., `profile_card_widget.dart` → `ProfileCardWidget`)

### 3. Screen Rules
- ✅ Screens **ONLY contain**:
  - Widget tree composition
  - Cubit/State listeners
  - Navigation logic
- ❌ Screens **MUST NOT contain**:
  - UI implementation (buttons, cards, etc.)
  - Business logic
  - Data fetching
  - Build methods longer than 100 lines
- ✅ All UI elements must be **extracted to separate widget classes**

### 4. State Management (Cubit)
- ✅ Each feature has its own Cubit
- ✅ Cubit handles ALL business logic and state
- ✅ Screens listen to Cubit state changes via BlocBuilder/BlocListener
- ❌ NO direct data manipulation in widgets
- ✅ Cubit files: `feature_cubit.dart` and `feature_state.dart`

### 5. Data Flow
User Action → Screen → Cubit → UseCase → Repository → DataSource ↑ ↓ State Updated State

### 6. Helper Functions & Utils
- ✅ Helper functions in `core/utils/` directory
- ✅ Group related helpers in same file (e.g., `date_helpers.dart`, `string_helpers.dart`)
- ✅ Use extensions where appropriate
- ❌ NO random helper functions scattered in widgets/screens

### 7. Constants
- ✅ All constants in `core/constants/` directory
- ✅ Separate by type: `app_colors.dart`, `app_strings.dart`, `app_sizes.dart`
- ❌ NO magic numbers or hardcoded strings in UI

### 8. Naming Conventions
- Screens: `feature_screen.dart` → `FeatureScreen`
- Widgets: `component_widget.dart` → `ComponentWidget`
- Cubits: `feature_cubit.dart` → `FeatureCubit`
- States: `feature_state.dart` → `FeatureState`
- Models: `feature_model.dart` → `FeatureModel`
- Entities: `feature_entity.dart` → `FeatureEntity`
- Repositories: `feature_repository.dart` → `IFeatureRepository` (interface), `FeatureRepositoryImpl` (implementation)

### 9. Import Rules
- ✅ Relative imports for project files
- ✅ Group imports: Flutter → Packages → Project
- ✅ Use barrel files (index.dart) for exporting multiple files

### 10. Code Quality
- ✅ Max file length: 300 lines
- ✅ Max function length: 50 lines
- ✅ Max parameters: 5 (use objects for more)
- ✅ Always use `const` where possible
- ✅ Meaningful variable names (no `a`, `b`, `temp`)

### 11. Color API Rules
- ❌ **NO `withOpacity()`** - deprecated method
- ✅ **USE `withValues(alpha: value)`** - modern API
- ❌ **NO deprecated color properties** (`.value`, `.red`, `.green`, `.blue`, `.alpha`)
- ✅ **USE component accessors** (`.r`, `.g`, `.b`, `.a` for normalized 0.0-1.0 values)
- ✅ **USE `toARGB32()`** instead of `.value` for integer conversion

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3        # State management
  equatable: ^2.0.5           # Value equality
  get_it: ^7.6.4              # Dependency injection
  url_launcher: ^6.2.5        # External links
🎯 Example Structure
BAD ❌
class HomeScreen extends StatelessWidget {
  Widget _buildHeader() { ... }  // Function widget
  Widget _buildContent() { ... } // Function widget
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildContent(),
      ],
    );
  }
}
GOOD ✅
// home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            HomeHeaderWidget(data: state.headerData),
            HomeContentWidget(data: state.contentData),
          ],
        );
      },
    );
  }
}

// home_header_widget.dart
class HomeHeaderWidget extends StatelessWidget {
  final HeaderData data;
  const HomeHeaderWidget({required this.data});
  
  @override
  Widget build(BuildContext context) { ... }
}

// home_content_widget.dart
class HomeContentWidget extends StatelessWidget {
  final ContentData data;
  const HomeContentWidget({required this.data});
  
  @override
  Widget build(BuildContext context) { ... }
}
🔄 Refactoring Checklist
 Install flutter_bloc, equatable, get_it
 Create new folder structure
 Move constants to core/constants/
 Create entities from models
 Create repository interfaces
 Implement repositories
 Create Cubits for each feature
 Extract all function widgets to class widgets
 Split large widgets into smaller ones
 Clean up screens (remove UI code)
 Setup dependency injection
 Test all features
📝 Notes
Every widget must be self-contained and reusable
State is immutable (use Equatable)
Follow Single Responsibility Principle
Keep widgets dumb (presentation only)
Keep Cubits smart (business logic)

## Refactoring Plan

Şimdi bu kurallara göre projeyi yeniden yapılandırma planını göstereyim mi? Adım adım ilerleyeceğiz:

1. **Hazırlık**: Paketleri ekle, klasör yapısını oluştur
2. **Core Layer**: Constants, utils, theme ayarla
3. **Data Layer**: Models ve repositories
4. **Domain Layer**: Entities ve use cases
5. **Presentation Layer**: Her özellik için widget'lara böl
6. **State Management**: Cubit'leri oluştur
7. **Cleanup**: Eski dosyaları temizle