📱 Flutter Web Portfolio – Telefon UI Temalı Proje Tanımı

🎯 Amaç

Gerçek bir mobil işletim sistemi hissiyatı veren, etkileşimli ve yaratıcı bir geliştirici portföy uygulaması oluşturmak.

🧭 Temel Prensipler

Navigasyon tamamen bir "telefon ekranı UI" üzerinden sağlanır.

Desktop'ta sağda sabit hoş geldin paneli yer alır.

Mobilde açıklama paneli telefonun altında, scrollable yapıdadır.

Fullscreen mod opsiyoneldir, aktif olduğunda yalnızca ekran gösterilir.

Blur’lu alt açıklama paneli yalnızca proje/eğitim gibi içerik ekranlarında görünür.

🧱 UI Özellikleri

1. Telefon UI

Gerçek telefon gibi görünür (çerçeve, durum çubuğu, ikon grid’i).

Klasör & ikon verileri dinamik: Firestore’dan (folders + apps_home) çekilir.

Örnek klasörler: Projeler, Eğitim, İletişim.

Gösterim düzeni

Üst grid → Home uygulamaları ve klasör ikonları aynı satırlı sistem ikonu diziliminde.



Alt satır (bottom apps) → Firestore’dan apps_bottom koleksiyonu dinamik olarak çekilir; alt dock’ta gösterilir.

Frame (telefon çerçevesi) yalnızca normal modda görünür; fullscreen modda gizlenir.

2. Açıklama Paneli Açıklama Paneli

Desktop: Sağda sabit hoş geldin paneli

Mobil: Telefonun altında scrollable

İçeriği yalnızca "tanıtım/karşılama" metni

3. Proje Açma (Project View)

Tam‑ekran özel uygulama olarak açılır; arka plan hâlâ telefon çerçevesi içinde kalır.

Üst bölüm → Tam ekranı kaplayan kaydırılabilir carousel (proje ekran görüntüleri). Her görsel kenardan kenara (edge‑to‑edge) gösterilir.

Alt bölüm → Kapatılabilir Blur’lu Bottom Sheet (varsayılan kapalı).

Proje başlığı & kısa açıklama

Teknoloji rozetleri

Dinamik link listesi (GitHub, Play Store …)

Sheet’i yukarı sürükle → açılır, aşağı sürükle → kapanır (veya "↓" ikonu).

Veri alanları ↗️ firebase_structure.md → apps_folder (type: project)

7. Fullscreen Mod Fullscreen Mod. Fullscreen Mod

Frame kaldırılır, sadece ekran gösterilir

İçerik varsa blur açıklama paneli gösterilir

ESC veya "geri" ile çıkılır

🧩 UI Bileşenleri

Bileşen

Görev

PhoneUI

Navigasyon ekranı

PhoneFrame

Frame çizimi

FolderOverlay

Blur + klasör içeriği

ProjectView

Proje içeriği ekranı

BottomPanel

Açılır açıklama paneli (fullscreen için)

ContentPanel

Hoş geldin paneli (desktop/mobil)

NavigationState

Aktif ekran bilgisi + fullscreen durumu

ThemeConfig

Tema verisi kontrolü

🗂️ Özel Uygulama Veri Tipleri

Bu portföy temasında belli başlı “özel uygulama” türleri, kendi ayrıntılı veri şemasına sahiptir. Frontend, bu AppData yapılarını bire bir okur ve ekrana uygun bileşenle render eder.

Uygulama Türü

Veri Modeli (koleksiyon)

İçerik

Blur Panel

project

ProjectAppData

Detaylı proje info + görseller

✔️ (alt sheet)

education

EducationAppData

Okul/bölüm/yıl listesi

✔️

career

CareerAppData

İş deneyimi zaman çizelgesi

✔️

contact

ContactAppData

Link ikonları + opsiyonel form

❌ (panel yok)

achievement

AchievementAppData

Ödül/başarı kartları

✔️/opsiyonel

about

AboutAppData

Biyografi, öne çıkanlar

✔️

reference

ReferenceAppData

Referans kişi veya alıntılar

✔️

Diğer tüm uygulama ikonları (ör. Kamerayı Aç, Ayarlar, vs.) yalnızca name, type, icon gibi temel alanlara sahiptir; tıklandığında gereken davranış frontend logic ile (örn. sayfa yönlendirme veya toast) yönetilir.

Ayrıntılı alan listeleri ve Firestore koleksiyon şeması için ↗️ firebase_structure.md dosyasına bakınız.

