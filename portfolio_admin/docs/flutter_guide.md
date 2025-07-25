# Flutter Proje Geliştirme Rehberi

Bu belge, Flutter projelerinde sürdürülebilir, okunabilir ve modüler bir yapı oluşturmak için uyulması gereken temel kuralları içerir.

---

## 🚀 Genel Kurallar

* Null Safety **zorunludur**.
* Tüm kodlar Dart dil standartlarına uygun yazılmalıdır.
* Proje feature-based yapı ile düzenlenecektir.
* Kodlar test edilebilir, bölünebilir ve yeniden kullanılabilir şekilde yazılmalıdır.
* Sadece ilgili modüller birbirini tanımalıdır. **Katmanlı yapı** ve sorumluluk ayrımı esastır.
* Her bir dosya mümkünse **maksimum 600 satır** civarında tutulmalıdır.

---

## 📁 Dosya ve Klasör Yapısı

```bash
lib/
├── core/                 # Tema, sabitler ve yardımcılar
│   ├── constants/        # Renkler, yazı stilleri, padding, vs.
│   ├── theme/            # Light/Dark tema tanımları
│   └── utils/            # Genel yardımcı fonksiyonlar
│
├── features/             # Her özellik kendi içinde modüler yapıdadır
│   ├── feature_name/
│   │   ├── data/         # Repository, modeller, dto vb.
│   │   ├── logic/        # Bloc/controller/provider sınıfları
│   │   ├── ui/           # Sayfalar ve özel UI bileşenleri
│   │   └── widgets/      # O feature'a özel tekrar kullanılabilir widgetlar
│
├── shared/               # Globalde kullanılan ortak widgetlar
│   └── widgets/
│
├── services/             # Firebase, storage, API gibi altyapı servisleri
│                         # Bu servisler DI ile inject edilir, doğrudan çağrılmaz
│
├── app/                  # Router, global providerlar, bağımlılık konfigürasyonu
│   ├── app.dart
│   ├── router.dart       # auto_route ayarları
│   ├── providers.dart    # Global providerlar
│   └── di.dart           # get_it & injectable setup dosyası
│
└── main.dart             # Uygulama giriş noktası
`
```

---

## 🄤 İsimlendirme Kuralları

| Öğrе                       | Kural                                        |
| -------------------------- | -------------------------------------------- |
| Dosyalar                   | `snake_case.dart` (örnek: `login_page.dart`) |
| Sınıflar                   | `PascalCase` (örnek: `LoginPage`)            |
| Fonksiyonlar & değişkenler | `camelCase`                                  |
| Widget isimleri            | Sonu `Widget` ile bitmemeli (gereksizse)     |

---

## 🎨 Tema ve UI Standartları

* Tüm renkler `core/constants/app_colors.dart` içinde tutulur.
* Yazı stilleri `core/constants/app_text_styles.dart` dosyasına yazılır.
* Temalar `core/theme/` altında merkezi olarak yönetilir.
* Responsive yapı zorunludur. UI mobil öncelikli olmalıdır.
* Sadece bir sayfada kullanılan küçük widget’lar, eğer sayfa 600 satırı geçmiyorsa aynı dosya içinde tanımlanır.
* Bu widget’lar `_PrivateWidgetName` gibi **private class** olarak tanımlanmalıdır.
* Yalnızca çok basit widget’lar fonksiyon şeklinde (`Widget buildXYZ()`) tanımlanabilir, diğerleri class olmalıdır.

---

## ⚙️ State Management

* **Riverpod 2.0** kullanılmalıdır.
* Her feature kendi provider'larına sahip olmalıdır.
* Global provider'lar `app/providers.dart` içinde tanımlanır.
* Widget içinde `ref.watch` / `ref.read` ile veri tüketilir.

---

## 🔀 Katmanlı Mimari (Özet)

Tüm bağımlılıklar **`injectable`**\*\* ve \*\***`get_it`** ile yönetilecektir. Sınıflar `@injectable` anotasyonu ile işaretlenir, uygulama başlatılırken `configureDependencies()` çağrısı yapılır.

### Service

* `services/` klasöründedir.
* Firebase, storage, API gibi altyapı servisleri içerir.
* **Genel görevleri** yapar, business logic içermez.
* DI ile inject edilir, doğrudan kullanılmaz.

### Feature Logic

* `features/feature_name/logic/` içinde yer alır.
* Provider, controller veya bloc sınıfları içerir.
* Feature'a özel mantık buradadır.
* Gerekli bağımlılıklar `@injectable` ya da constructor ile alınır.

### Data

* `features/feature_name/data/` içinde yer alır.
* Repository, model, DTO, converter gibi yapılar burada tanımlanır.
* Repository'ler servislere bağımlıdır ve DI ile bağlanır.

### UI

* `features/feature_name/ui/` içinde yer alır.
* Sayfa ve widget’lar burada yer alır.
* UI logic UI içinde kalmalıdır.
* Sadece o sayfada kullanılan widget’lar, eğer sayfa 600 satırı geçmiyorsa sayfa içinde private class olarak tanımlanmalıdır.

---

## 🌐 L10n ve Çoklu Dil Desteği

* Dil dosyaları `assets/lang/` klasöründe `.json` formatında tutulacaktır.
* `intl`, `easy_localization`, `flutter_translate` gibi paketler **kullanılmayacaktır**.
* Çeviri işlemleri, uygulama içinde manuel olarak yönetilecektir.
* Varsayılan dil Türkçe'dir. Desteklenen diller: Türkçe, İngilizce.

---

## 🪰 Geliştirme Standartları

* Commit mesajları anlamlı ve eylem odaklı yazılmalı.
  Örnek: `feat(auth): implement email login`, `fix(profile): fix photo upload bug`
* PR başına tek konu.
* Her özellik ayrı branch'te geliştirilir.
* Kod review zorunludur.
* Sayfalarda gereksiz import bırakılmamalıdır. `auto_import` özelliği açık kullanılmalıdır.
* Kod yazarken `withOpacity` gibi fonksiyonlar kullanılmalı, `withAlpha` tercih edilmemelidir.

---

## 📚 Kütüphaneler

Zorunlu kütüphaneler:

* `flutter_riverpod`
* `auto_route`
* `freezed`, `json_serializable`
* `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
* `flutter_hooks` (isteğe bağlı)
* `injectable`, `get_it` (dependency injection için)

---

Bu rehber, tüm geliştiricilerin aynı kod standardı ve yapı ile çalışmasını sağlamak için hazırlanmıştır. Projeye özel kurallar için `project_guide.md` dosyasına başvurulmalıdır.
