# 🎨 Tema Rehberi – Portföy Web Uygulaması

Bu belge, portföy web uygulamasında kullanılan **statik tema sistemini** açıklar. Uygulamanın hem açık (light) hem de koyu (dark) modları için merkezi bir `ThemeData` tanımı içerir.

---

## 🌟 Amaç

Bu dosya, uygulamanın tüm kullanıcı arayüz bileşenlerinin tutarlı, sade ve modern bir tema ile görünmesini sağlar.

* Renkler, boşluklar ve yazı stillerini merkezi olarak yönetir
* İsteğe bağlı olarak açık/koyu mod geçişine olanak tanır
* Gelecekte Firestore üzerinden dinamik tema desteği için genişletilebilir yapıdadır

---

## 📁 Dosya Konumu

```bash
lib/core/theme/portfolio_theme.dart
```

---

## 🎨 ThemeData Yapısı

Bu tema dosyası iki adet `ThemeData` tanımı içerir:

```dart
class PortfolioTheme {
  static ThemeData get light => ThemeData(...);
  static ThemeData get dark => ThemeData(...);
}
```

Her tema şunları içerir:

* Renk şeması (colorScheme)
* Uygulama çubuğu ayarları (appBarTheme)
* Yazı tipi stilleri (textTheme)
* Kart tasarımı (cardTheme)
* İkon temaları (iconTheme)

---

## 🔍 Renk Paleti (Örnek)

| Alan        | Açık Tema | Koyu Tema |
| ----------- | --------- | --------- |
| Ana Renk    | `#1E88E5` | `#90CAF9` |
| Arka Plan   | `#F9F9F9` | `#121212` |
| Metin Rengi | `#212121` | `#FFFFFF` |
| Vurgu Rengi | `#FF4081` | `#F48FB1` |

---

## ✏️ Yazı Tipi Kuralları

* Başlık: `titleLarge` → 24pt, kalın
* Metin: `bodyMedium` → 16pt
* Açıklama: `bodySmall` → 13pt, gri tonlu

Tüm yazı stilleri `TextTheme` içinde tanımlanır ve uygulama genelinde kullanılabilir.

---

## 🗂 Kart Tasarımı

Tüm kartlar sabit boşluk ve gölge yapısına sahiptir:

```dart
CardTheme(
  elevation: 2,
  margin: EdgeInsets.all(12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## 🌐 Duyarlılık (Responsiveness)

`ThemeData` doğrudan layout yönetimi yapmasa da tema, responsive bileşenlerle uyumlu şekilde tasarlanmıştır:

* Renkler ve yazı stilleri farklı ekran boyutlarında sorunsuz görünür
* `LayoutBuilder` ve `MediaQuery` gibi yapılarla birlikte kullanılabilir

---

## 📌 Gelecekteki Geliştirmeler

* Opsiyonel: Tema renklerini bir model (`ThemeConfig`) olarak tanımlayıp her portföy için Firestore'dan almak
* Opsiyonel: Kullanıcının admin panel üzerinden kendi temasını seçmesine izin vermek

---

Bu belge
