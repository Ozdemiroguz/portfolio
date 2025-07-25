# 📂 Firestore Portfolio Yapısı (Güncel Model Tabanlı)

Bu yapı **Flutter model dosyalarından** türetilmiş olup hem **admin paneli** hem de **frontend portföy sunumu** için referans olarak kullanılır.

---

## 👤 users (Koleksiyon)

Her kullanıcıya ait genel bilgiler burada tutulur.

📄 `users/{userId}`

```json
{
  "id": "user_abc123",
  "displayName": "Oğuzhan Özdemir",
  "email": "oguzhan@example.com",
  "createdAt": "2025-06-21T10:00:00Z",
  "profilePhoto": "https://cdn.domain.com/user_avatar.jpg",
  "portfolios": ["oguzhan", "oguzhan-basic"]
}
```

> *"portfolios" alanı, kullanıcının sahip olduğu domain isimlerini tutar.*

---

## 🌐 portfolios (Koleksiyon)

Tüm portföyler burada tutulur. Her biri eşsiz bir `domain` değeri taşır.

📄 `portfolios/{portfolioId}` (örnek: `oguzhan`, `oguzhan-basic`)

```json
{
  "id": "oguzhan-basic",
  "domain": "oguzhan-basic",
  "title": "Oğuzhan Özdemir | Mobil Geliştirici",
  "description": "Flutter ile geliştirdiğim projeleri, eğitim geçmişimi ve iletişim bilgilerimi bu portföyde bulabilirsiniz.",
  "ownerId": "user_abc123",
  "createdAt": "2025-06-21T10:00:00Z",
  "updatedAt": "2025-06-21T10:15:00Z",
  "isPublic": true,
  "customDomain": null,
  "coverImage": "https://cdn.domain.com/cover.jpg",
  "profilePhoto": "https://cdn.domain.com/avatar.jpg",
  "portfolioType": "mobile",

  "theme": {
    "mode": "dark",
    "primaryColor": "#1E88E5",
    "backgroundColor": "#121212",
    "textColor": "#FFFFFF",
    "accentColor": "#FF4081"
  },

  "socialLinks": [
    { "type": "github", "url": "https://github.com/oguzhan" },
    { "type": "linkedin", "url": "https://linkedin.com/in/oguzhanozdemir" },
    { "type": "email", "url": "mailto:oguzhan@example.com" },
    { "type": "twitter", "url": null }
  ],

  "skills": ["Flutter", "Firebase", "Riverpod", "Clean Architecture", "REST API"],
  "tags": ["Mobile", "Developer", "Flutter", "Portfolio"],
  "languages": ["tr", "en"],
  "defaultLocale": "tr"
}
```

---

## 📁 folders (Subcollection of `portfolios/{portfolioId}`)

📄 `portfolios/{portfolioId}/folders/{folderId}`

```json
{
  "id": "folderId_xyz",
  "title": "Projeler",
  "description": "Geliştirdiğim mobil uygulamalar",
  "icon": "folder_projects.png",
  "color": "#2196F3",
  "appIds": ["appId_1", "appId_2", "appId_3"],
  "order": 1,
  "isActive": true,
  "createdAt": "2025-06-21T10:00:00Z",
  "updatedAt": "2025-06-21T10:15:00Z"
}
```

---

## 📱 apps (Subcollection of `portfolios/{portfolioId}`)

**Tüm uygulamalar tek bir `apps` koleksiyonunda tutulur.** Her app ortak bir yapıya sahiptir ve `data` alanında type-specific veriler bulunur.

📄 `portfolios/{portfolioId}/apps/{appId}`

### 🏗️ Ortak App Yapısı

```json
{
  "id": "app_abc123",
  "type": "project", // project, about, education, contact, career, achievement, reference
  "title": "Not Al",
  "description": "Gelişmiş not alma uygulaması",
  "icon": "notal_icon.png",
  "images": [
    "https://cdn.domain.com/project1.png",
    "https://cdn.domain.com/project2.png"
  ],
  "createdAt": "2025-06-21T10:00:00Z",
  "updatedAt": "2025-06-21T10:15:00Z",
  "isActive": true,
  "order": 1,
  "data": {
    // Type-specific data (aşağıda detaylandırılmıştır)
  }
}
```

---

### 📋 App Türleri ve Data Yapıları

#### 1. **PROJECT APP** (`type: "project"`)

```json
{
  "data": {
    "projects": [
      {
        "title": "Not Al",
        "description": "Flutter ile geliştirilmiş not alma uygulaması",
        "githubUrl": "https://github.com/oguzhan/notal",
        "playStoreUrl": "https://play.google.com/store/apps/details?id=notal",
        "appStoreUrl": null,
        "webUrl": null,
        "demoUrl": "https://demo.notal.app",
        "technologies": ["Flutter", "Firebase", "Riverpod"],
        "features": ["Offline çalışma", "Senkronizasyon", "Kategoriler"],
        "status": "completed", // completed, in-progress, planned
        "startDate": "2024-01-01T00:00:00Z",
        "endDate": "2024-06-01T00:00:00Z",
        "teamSize": 1,
        "role": "Mobile Developer",
        "ownProject": true,
        "clientName": null,
        "displayOn": {
          "playStore": true,
          "appStore": false,
          "github": true,
          "web": false
        },
        "images": [
          "https://cdn.domain.com/notal_screen1.png",
          "https://cdn.domain.com/notal_screen2.png"
        ]
      }
      // ... en fazla 10 proje
    ]
  }
}
```

#### 2. **EDUCATION APP** (`type: "education"`)

```json
{
  "data": {
    "educations": [
      {
        "institution": "İstanbul Teknik Üniversitesi",
        "degree": "Lisans",
        "field": "Bilgisayar Mühendisliği",
        "startDate": "2018-09-01T00:00:00Z",
        "endDate": "2023-06-01T00:00:00Z",
        "gpa": 3.45,
        "gpaScale": "4.0",
        "courses": ["Veri Yapıları", "Algoritma", "Mobil Programlama"],
        "achievements": ["Yüksek Onur Listesi", "En İyi Proje Ödülü"],
        "status": "completed", // completed, ongoing, paused
        "location": "İstanbul, Türkiye",
        "website": "https://itu.edu.tr"
      }
    ]
  }
}
```

#### 3. **CAREER APP** (`type: "career"`)

```json
{
  "data": {
    "company": "TechCorp Ltd.",
    "position": "Senior Mobile Developer",
    "department": "Mobil Geliştirme",
    "startDate": "2023-01-01T00:00:00Z",
    "endDate": null,
    "employmentType": "full-time", // full-time, part-time, contract, internship
    "location": "İstanbul, Türkiye",
    "website": "https://techcorp.com",
    "responsibilities": [
      "Flutter uygulamaları geliştirme",
      "Clean Architecture uygulama",
      "Code review süreçleri"
    ],
    "achievements": [
      "Performansı %40 artıran optimizasyon",
      "CI/CD pipeline kurulumu"
    ],
    "technologies": ["Flutter", "Dart", "Firebase", "REST API"],
    "salary": null,
    "currentJob": true
  }
}
```

#### 4. **CONTACT APP** (`type: "contact"`)

```json
{
  "data": {
    "contactPersons": [
      {
        "name": "Oğuzhan Özdemir",
        "position": "Mobile Developer",
        "department": "Teknoloji",
        "email": "oguzhan@example.com",
        "phone": "+90 555 123 4567",
        "linkedin": "https://linkedin.com/in/oguzhanozdemir",
        "description": "Flutter ve mobil geliştirme konularında deneyimli"
      }
    ],
    "contactForm": {
      "enabled": true,
      "submitEndpoint": "https://functions.domain.com/sendMessage",
      "requiredFields": ["email", "message"],
      "successMessage": "Mesajınız başarıyla gönderildi!",
      "errorMessage": "Bir hata oluştu, lütfen tekrar deneyin."
    },
    "address": "İstanbul, Türkiye",
    "phone": "+90 555 123 4567",
    "email": "oguzhan@example.com",
    "socialLinks": {
      "github": "https://github.com/oguzhan",
      "linkedin": "https://linkedin.com/in/oguzhanozdemir",
      "twitter": "https://twitter.com/oguzhan"
    },
    "workingHours": "09:00 - 18:00",
    "timezone": "Europe/Istanbul"
  }
}
```

#### 5. **ACHIEVEMENT APP** (`type: "achievement"`)

```json
{
  "data": {
    "category": "certificate", // award, certificate, recognition, competition
    "issuer": "Google",
    "issueDate": "2024-03-15T00:00:00Z",
    "expiryDate": "2027-03-15T00:00:00Z",
    "credentialId": "CERT123456",
    "credentialUrl": "https://credentials.google.com/cert123456",
    "verificationUrl": "https://verify.google.com/cert123456",
    "level": "advanced", // beginner, intermediate, advanced, expert
    "skills": ["Flutter", "Mobile Development"],
    "score": "95/100",
    "grade": "A+"
  }
}
```

#### 6. **ABOUT APP** (`type: "about"`)

```json
{
  "data": {
    "summary": "5+ yıllık deneyime sahip mobil geliştirici. Flutter ve native Android konularında uzman.",
    "mission": "Kaliteli ve kullanıcı dostu mobil uygulamalar geliştirmek",
    "vision": "Mobil teknolojilerle dünyayı daha iyi bir yer yapmak",
    "interests": ["Mobil Geliştirme", "UI/UX", "Açık Kaynak"],
    "hobbies": ["Kitap okuma", "Seyahat", "Fotoğrafçılık"],
    "personalInfo": {
      "age": "28",
      "location": "İstanbul, Türkiye",
      "nationality": "Türk"
    },
    "languages": ["Türkçe (Ana dil)", "İngilizce (İleri)"],
    "cv": "https://cdn.domain.com/cv.pdf",
    "portfolio": "https://portfolio.oguzhan.dev"
  }
}
```

#### 7. **REFERENCE APP** (`type: "reference"`)

```json
{
  "data": {
    "references": [
      {
        "name": "Ahmet Yılmaz",
        "position": "Tech Lead",
        "company": "TechCorp Ltd.",
        "email": "ahmet@techcorp.com",
        "phone": "+90 555 987 6543",
        "linkedin": "https://linkedin.com/in/ahmetyilmaz",
        "relationship": "manager", // colleague, manager, client, mentor
        "recommendation": "Oğuzhan, çok yetenekli ve güvenilir bir geliştirici...",
        "canContact": true,
        "workTogether": "2023-01-01T00:00:00Z"
      }
    ]
  }
}
```

#### 8. **SYSTEM APPS** (`type: "camera" | "phone" | "messages"`)

Telefon benzeri sistem uygulamaları - basit yapıya sahip, özel data içermez.

```json
{
  "data": {}
}
```

#### 9. **GAME APPS** (`type: "game1" | "game2" | "game3"`)

Oyun uygulamaları - demo veya basit oyunlar için.

```json
{
  "data": {}
}
```

#### 10. **CUSTOM APPS** (`type: "custom1" | "custom2" | "custom3"`)

Özelleştirilebilir uygulamalar - kullanıcının istediği her türlü içerik.

```json
{
  "data": {}
}
```

---

### 🎯 **App Türü Kullanım Senaryoları**

#### **Detaylı Apps (Form ile oluşturulan)**
- `project` - Yazılım projeleri, uygulamalar, web siteleri
- `education` - Üniversite, kurs, sertifika eğitimleri
- `career` - İş deneyimi, çalışma geçmişi
- `contact` - İletişim bilgileri ve form sistemi
- `achievement` - Ödüller, sertifikalar, başarılar
- `about` - Kişisel bilgiler, özgeçmiş, hakkında
- `reference` - Referans kişiler ve öneriler

#### **Sistem Apps (Basit oluşturma - Sadece temel bilgiler)**
- `camera` - Kamera uygulaması simülasyonu
- `phone` - Telefon uygulaması simülasyonu
- `messages` - Mesaj uygulaması simülasyonu

#### **Oyun Apps (Basit oluşturma - Sadece temel bilgiler)**
- `game1`, `game2`, `game3` - Demo oyunlar, mini games

#### **Özel Apps (Basit oluşturma - Sadece temel bilgiler)**
- `custom1`, `custom2`, `custom3` - Özel kullanım amaçlı uygulamalar

---

## 📬 contact_messages (Subcollection of `portfolios/{portfolioId}`)

İletişim formu üzerinden gelen mesajlar burada tutulur.

📄 `portfolios/{portfolioId}/contact_messages/{messageId}`

```json
{
  "email": "ziyaretci@example.com",
  "title": "İş Birliği Talebi",
  "message": "Merhaba, uygulamanızdan çok etkilendim. Bir proje hakkında görüşmek isterim.",
  "sentAt": "2025-06-21T12:30:00Z"
}
```

---

## ✅ Genel Kurallar

### 🔗 Domain ve Portföy Yönetimi
* Her domain eşsizdir, sistemde yalnızca bir kez yer alabilir
* Domain adında `-` kullanılabilir, `/` kullanılamaz
* Kullanıcılar birden fazla portföye sahip olabilir
* Portföyün sahibi `ownerId` ile belirlenir

### 📱 App Yönetimi
* Tüm uygulamalar tek bir `apps` subcollection'ında tutulur
* Her app'in bir `type` alanı vardır:
  * **Detaylı Apps**: `project`, `about`, `education`, `contact`, `career`, `achievement`, `reference`
  * **Sistem Apps**: `camera`, `phone`, `messages`
  * **Oyun Apps**: `game1`, `game2`, `game3`
  * **Özel Apps**: `custom1`, `custom2`, `custom3`
* Type-specific veriler `data` alanında JSON olarak saklanır
* Ortak alanlar: id, type, title, description, icon, images, createdAt, updatedAt, isActive, order
* **Proje türü** birden fazla oluşturulabilir (maksimum 10 proje)
* **Diğer tüm türler** her portföyde tek instance olarak tutulur

### 📁 Folder Sistemi
* Folder'lar uygulamaları gruplamak için kullanılır
* Her folder'da `appIds` array'i bulunur
* Folder'lar renkli ve sıralı olabilir

### 🎨 Tema Yapısı
* Tema bilgileri doğrudan portfolio document'ında tutulur
* Ayrı theme_config subcollection'ı kaldırıldı

---

## 🌐 Örnek URL'ler

| URL                           | Açıklama                       |
| ----------------------------- | ------------------------------ |
| `portfolio.com/oguzhan`       | Default portföy                |
| `portfolio.com/oguzhan-basic` | İkinci portföy                 |
| `portfolio.com/furkan-web`    | Farklı kullanıcıya ait portföy |

> Sistemde her domain, direkt olarak `portfolios` koleksiyonunda tutulduğu için yönetim ve erişim basittir.
