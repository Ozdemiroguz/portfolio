# 🌐 Proje Genel Bakışı – Flutter Web Portföy Uygulaması

Bu belge, portföy oluşturma platformunun genel mimarisini, hedeflerini ve teknik yapısını özetler.

---

## 🌟 Proje Amacı

Kullanıcıların kişisel portföy sitelerini kolayca oluşturup yönetebileceği, Firebase destekli ve web tabanlı, responsive bir admin panel üzerinden çalışan bir sistem geliştirmek.

Kullanıcılar şunları yapabilir:

* Güvenli şekilde kayıt olabilir ve giriş yapabilir
* Benzersiz domain ile birden fazla portföy oluşturabilir
* Klasörler ve uygulamalar (hakkında, projeler, iletişim vs.) ekleyebilir
* Tema, renk ve düzen ayarlarını özelleştirebilir
* Portföyünü `portfolio.com/kullaniciadi` gibi bir URL ile yayınlayabilir

---

## 🧱 Teknoloji Yığını

| Katman         | Kullanılan Teknolojiler              |
| -------------- | ------------------------------------ |
| Frontend       | Flutter Web                          |
| Backend        | Firebase Firestore, Firebase Storage |
| Kimlik         | Firebase Authentication              |
| Bağımlılık     | `injectable`, `get_it`               |
| Yönlendirme    | `auto_route`                         |
| Durum Yönetimi | `flutter_riverpod`                   |
| Dil Sistemi    | JSON tabanlı (`assets/lang/`)        |

---

## 💻 Platform Desteği

* ✅ Web odaklı mimari
* ✅ Tam responsive tasarım (masaüstü + mobil)
* ✅ Flutter Web'de resim/dosya seçimi uyumlu
* ✅ Tüm modern tarayıcılarda çalışır (Chrome, Safari, Edge)

---

## 🔐 Kimlik Doğrulama Akışı

1. Kullanıcı e-posta ve şifre ile kayıt olur
2. Firestore'da `users/{userId}` dökümanı oluşturulur
3. Giriş sonrası kullanıcı portföy yönetim paneline yönlendirilir
4. Her portföy `portfolios/{portfolioId}` altında yönetilir

---

## 🗂 Firestore Koleksiyonları (Özet)

* `users/` → kullanıcı kimliği ve sahip olduğu portföyler
* `portfolios/` → her portföy: domain, tema, uygulamalar vb.
* `portfolios/{id}/folders/` → klasör yapısı
* `portfolios/{id}/apps_*` → içerik uygulamaları (anasayfa, alt menü, klasör)
* `portfolios/{id}/contact_messages/` → iletişim mesajları

📄 Detaylı yapı için: [`firebase_schema.md`](firebase_schema.md)

---

## 🛠 Admin Panel Akışı

* Kullanıcılar sadece kendi portföylerini görebilir/yönetebilir
* Domain benzersizliği zorunludur
* Dinamik olarak klasör ve uygulama eklenebilir
* Yayınlama öncesi minimum içerik kontrolü yapılır
* İletişim mesajları ilgili portföy altında tutulur

📄 Ayrıntılı akış için: [`admin_panel_flow.md`](admin_panel_flow.md)

---

## 🌍 Dil Desteği

* Desteklenen diller: **Türkçe**, **İngilizce**
* `assets/lang/` klasöründe JSON formatında tutulur
* Üçüncü parti paket kullanılmaz, özel bir yöneticisi vardır

---

## 📱 Responsive Tasarım

* Tüm ekran boyutlarına uyum sağlar
* Padding, grid ve font yapıları uyarlanabilir widget'larla belirlenir
* Portföy önizleme modu ile birlikte çalışır

---

## 🎨 Tema Desteği

* **Açık** ve **koyu** tema desteği bulunur
* Tema konfigürasyonu her portföy için ayrı saklanır
* Renkler ve stil bilgileri `core/theme/portfolio_theme.dart` dosyası üzerinden uygulanır
* Kullanıcı panel üzerinden tema seçebilir ya da özelleştirebilir

📄 Tema sistemi için: [`theme_guide.md`](theme_guide.md)

---

## 🚀 Yayınlama Notları

* `flutter build web` komutu ile production build alınır
* Firebase Hosting veya benzeri servis önerilir
* Web uyumlu Firebase servisleri tam olarak başlatılmalıdır

---

## 📌 Notlar

* Dosyalar mümkünse 600 satırı geçmemelidir
* Feature-based klasör yapısı kullanılmalıdır
* Servis sınıflarında iş mantığı olmamalı, bu görev repository'ye ait olmalı
* Dil sistemi manuel olarak JSON üzerinden çalışır

---
