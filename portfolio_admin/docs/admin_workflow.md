# 🛠️ Admin Panel Akışı (Portföy Yönetimi)

Bu belge, portföy oluşturma ve yönetme sürecinin **admin paneli** tarafındaki adımlarını detaylandırmak için hazırlanmıştır.

---

## 1⃣⃣ Kullanıcı Giriş & Kayıt Sistemi

### 🔐 Kimlik Doğrulama

* Kullanıcılar email ve şifre ile **giriş** ve **kayıt** yapar.
* Firebase Authentication kullanılır.

### 🆕 Kayıt Ekranı

* Kullanıcıdan alınacak alanlar:

  * **İsim (displayName)**
  * **E-mail (email)**
  * **Şifre (password)**
* Form doğrulama:

  * Geçerli email kontrolü
  * Minimum şifre uzunluğu (örneğin 6 karakter)

### 🔓 Giriş Ekranı

* Kullanıcıdan alınacak alanlar:

  * **E-mail (email)**
  * **Şifre (password)**
* Hatalı girişlerde kullanıcıya geri bildirim verilir.

### ✅ Kayıt Sonrası

* Kullanıcı ilk kez kayıt olduğunda `users/{userId}` dokümanı oluşturulur.

```json
{
  "displayName": "",
  "email": "user@example.com",
  "createdAt": "...",
  "portfolios": []
}
```

---

## 2⃣⃣ Portföy Yönetim Paneli

### 📂 Portföy Listesi

* Giriş yapan kullanıcı, kendisine ait tüm portföyleri listeler.
* Her portföy kartında:

  * **Domain adı**
  * **Yayın durumu (yayında / taslak)**
  * **Düzenle** ve **Sil** seçenekleri bulunur.

### ➕ Yeni Portföy Oluşturma

1. **Domain Adı Girilir**

   * Örn: `oguzhan-basic`
   * Sistem, `portfolios` koleksiyonunda bu domain var mı diye kontrol eder.
   * Varsa: Uyarı verilir.
   * Yoksa: Yeni döküman, Firestore tarafından otomatik ID atanarak oluşturulur.
   * `portfolioType`: "mobile" olarak atanır. ( Şu an sadece bu desteklenmektedir.)

2. **Portföy Belgesi Oluşturulur**

   * Oluşturulan dökümana aşağıdaki alanlar set edilir:

     * `domain`: kullanıcı tarafından girilen domain ("oguzhan-basic")
     * `ownerId`: kullanıcı id’si
     * `createdAt`: tarih
     * `isPublic`: false
     * `portfolioType`: "mobile"
     * Diğer tüm başlangıç değerleri (boş tema, başlık vs.)

3. **Kullanıcı Bilgileri Güncellenir**

   * `users/{userId}` içindeki `portfolios` listesine bu yeni domain eklenir.

---

## 3⃣⃣ Portföy Düzenleme Süreci

* Kullanıcı bir portföyü seçtiğinde aşağıdaki alanları düzenleyebilir:

  * Tema ayarları
  * Sosyal linkler (GitHub, LinkedIn, E-posta vs.)
  * Skills / Tags
  * Diller
  * Default locale

> Gerekli bilgiler tamamlanmadan portföy "yayına alınamaz" durumu gösterilir.

### ✏️ Bilgi Güncelleme

* Her bilgi alanı, kullanıcı tarafından parça parça değiştirilebilir.
* Değiştirilmek istenen bilgi, bir dialog penceresinde (popup) açılır.
* Kullanıcı değişikliği yapıp "Güncelle" butonuna bastığında ilgili alan veritabanında güncellenir.

---

## 4⃣⃣ Uygulama ve Klasör Ekleme

* Kullanıcı portföye uygulama eklemeden önce isteğe bağlı olarak **folder (klasör)** oluşturabilir.
* Folder oluşturulurken:

  * Başlık girilir
  * İkon belirlenir (varsayılan kullanılabilir)
  * Klasöre ait uygulamalar listelenebilir

### 📁 Folder Altına Uygulama Ekleme

* Kullanıcı klasör altına desteklenen çeşitli uygulama türlerini ekleyebilir:

  * Örn: `project`, `about`, `education`, `contact`, `reference`, `awards`, `certificate`
* Uygulama tipine göre özelleşmiş alanlar açılır ve kullanıcıdan alınır.

### 🏠 Ana Ekrana Uygulama Ekleme (apps\_home)

* Kullanıcı istediği türde uygulamayı direkt anasayfaya ekleyebilir.
* Her uygulama tipi, kendi form bileşenine sahiptir.

> Kullanıcı, klasör eklemek zorunda değildir. Ana ekrana da doğrudan uygulama ekleyebilir.

---

## 5⃣⃣ Yayınlama & Önizleme

* Portföy yayına alınmadan önce:

  * Temel bilgilerin dolu olması gerekir.
  * En az bir uygulama veya içerik olması önerilir.

* Yayına alındığında `isPublic: true` olarak güncellenir.

* Yayınlanmış portföy URL’si gösterilir:

  * `portfolio.com/{domain}`

---

## 6⃣⃣ İletişim Mesajları Yönetimi

* Kullanıcıların iletişim uygulamasından gönderdiği mesajlar Firestore'da saklanır:

  * `portfolios/{portfolioId}/contact_messages/{messageId}` yapısında tutulur.

* Her mesaj:

  * `email`: gönderenin e-posta adresi
  * `title`: mesaj başlığı
  * `content`: mesaj içeriği
  * `createdAt`: gönderim tarihi

* Admin panelde, kullanıcıya ait portföy içinden bu mesajlar listelenebilir ve görüntülenebilir.

---

## 📌 Notlar

* Admin paneli, kullanıcıların sadece **kendi** portföylerini görebileceği şekilde sınırlandırılmalı.
* Domain kontrolü hassas ve anlık yapılmalı (Firestore indexlenmiş sorgularla).
* Domain eşsizliği domain alanı üzerinden yapılır, döküman ID ile bağlantılı değildir.
* Her aşamada otomatik **taslak kayıt** yapılabilir.

---

Bu yapı sayesinde kullanıcılar kendi portföylerini sıfırdan oluşturabilir, klasör ve uygulamalar ekleyebilir, kişisel sayfalarını düzenleyebilir, iletişim mesajlarını okuyabilir ve yayınlayabilir.
