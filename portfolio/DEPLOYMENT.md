# GitHub Pages Deployment Rehberi

Bu rehber, Flutter web projenizi GitHub Pages'e deploy etmek için gerekli adımları içerir.

## 🔍 Sorun Neydi?

Local'de çalışan asset'ler (CV, galeri resimleri, vs.) GitHub Pages'de 404 hatası veriyordu çünkü:
1. **Base href** ayarı yapılmamıştı
2. **PDF viewer** base href'i dikkate almıyordu
3. Build sırasında doğru parametreler kullanılmamıştı

## ✅ Yapılan Düzeltmeler

### 1. PDF Viewer Düzeltmesi
`lib/presentation/cv/widgets/pdf_viewer_widget.dart` dosyasında base href desteği eklendi.

### 2. Deploy Script
`deploy.sh` scripti eklendi - Manuel build ve deploy için.

### 3. GitHub Actions Workflow
`.github/workflows/deploy.yml` eklendi - Otomatik deployment için.

## 🚀 Deployment Seçenekleri

### Seçenek 1: Manuel Deployment (deploy.sh)

```bash
# Script'i çalıştır
./deploy.sh

# Script size soracak:
# 1) User page (https://ozdemiroguz.github.io/) için mi?
# 2) Project page (https://ozdemiroguz.github.io/repository-name/) için mi?
```

Script şunları yapacak:
- ✅ Flutter clean
- ✅ Dependencies güncelleme
- ✅ Doğru base href ile build
- ✅ .nojekyll dosyası ekleme
- ✅ Asset kontrolleri

### Seçenek 2: Otomatik Deployment (GitHub Actions)

#### Kurulum Adımları:

1. **GitHub Repository Settings'e git**
   - Repository → Settings → Pages
   - Source: "Deploy from a branch" seç
   - Branch: `gh-pages` ve `/root` seç
   - Save

2. **Base Href'i Ayarla**
   
   `.github/workflows/deploy.yml` dosyasını aç ve base href'i düzenle:

   ```yaml
   # User/Organization page için (username.github.io)
   - name: 🔨 Build Web
     run: flutter build web --release --base-href "/"
   ```

   VEYA

   ```yaml
   # Project page için (username.github.io/repository-name)
   - name: 🔨 Build Web
     run: flutter build web --release --base-href "/repository-name/"
   ```

3. **Commit ve Push**
   ```bash
   git add .
   git commit -m "Add GitHub Actions deployment"
   git push origin main
   ```

4. **İlk Deployment**
   - GitHub'da Actions tab'ına git
   - Workflow'un çalıştığını gör
   - Tamamlandığında `gh-pages` branch'i otomatik oluşturulur
   - Site 2-3 dakika içinde yayına girer

## 🔧 Hangi Deployment Türü?

### User/Organization Page
- **Repository adı:** `username.github.io`
- **URL:** `https://username.github.io/`
- **Base href:** `/`

### Project Page
- **Repository adı:** Herhangi bir isim (örn: `portfolio`)
- **URL:** `https://username.github.io/repository-name/`
- **Base href:** `/repository-name/`

## 📋 Deployment Checklist

- [ ] Base href doğru ayarlandı mı?
- [ ] `.nojekyll` dosyası var mı? (Script otomatik ekler)
- [ ] GitHub Pages Settings → Source → `gh-pages` branch seçildi mi?
- [ ] Build/web/assets klasörü doğru kopyalandı mı?
- [ ] Console'da 404 hatası var mı? (Tarayıcı DevTools → Console)

## 🐛 Sorun Giderme

### Asset'ler hala 404 veriyor

1. **Base href kontrolü:**
   ```bash
   # Build klasöründeki index.html'i kontrol et
   cat build/web/index.html | grep "<base"
   
   # Şöyle olmalı:
   # <base href="/"> veya <base href="/repository-name/">
   ```

2. **Asset klasörü kontrolü:**
   ```bash
   ls -la build/web/assets/
   ls -la build/web/assets/images/
   ```

3. **GitHub Pages source kontrolü:**
   - Settings → Pages → Source `gh-pages` branch olmalı

### PDF açılmıyor

PDF viewer artık base href'i otomatik alıyor. Eğer sorun devam ediyorsa:

```bash
# Console'u kontrol et - PDF URL'si doğru mu?
# Örnek doğru URL:
# https://ozdemiroguz.github.io/assets/Oguzhan-Ozdemir-Resume-20251030.pdf
# veya
# https://ozdemiroguz.github.io/portfolio/assets/Oguzhan-Ozdemir-Resume-20251030.pdf
```

### Build hatası alıyorum

```bash
# Flutter'ı güncelle
flutter upgrade

# Cache'i temizle
flutter clean
flutter pub get

# Tekrar build et
flutter build web --release --base-href "/"
```

## 🔄 Güncelleme Workflow'u

Değişikliklerinizi deploy etmek için:

**GitHub Actions kullanıyorsanız:**
```bash
git add .
git commit -m "Update message"
git push origin main
# Otomatik deploy başlar
```

**Manuel deploy kullanıyorsanız:**
```bash
./deploy.sh
# Script talimatlarını izleyin
```

## 📝 Notlar

- ✅ PDF viewer base href desteği eklendi
- ✅ Deploy script hazır
- ✅ GitHub Actions workflow hazır
- ✅ Asset'ler doğru şekilde kopyalanacak
- ✅ .nojekyll dosyası otomatik ekleniyor

## 🆘 Hala Sorun mu Var?

1. Console'u kontrol edin (Browser DevTools → Console)
2. Network tab'ında hangi asset'lerin 404 verdiğini görün
3. Base href ayarını tekrar kontrol edin
4. GitHub Pages Settings'i kontrol edin

---

**Son güncelleme:** Kasım 2025

