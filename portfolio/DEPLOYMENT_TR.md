# 🚀 GitHub Pages Deployment - Hızlı Başlangıç

## ✅ Sorun Çözüldü!

**Sorun Neydi?**
- Local'de çalışan asset'ler (CV, galeri resimleri) GitHub Pages'de 404 hatası veriyordu
- Sebep: Base href yanlış ayarlanmıştı (`/` yerine `/portfolio/` olmalıydı)

**Yapılan Düzeltmeler:**
- ✅ Base href `/portfolio/` olarak ayarlandı
- ✅ PDF viewer base href desteği eklendi
- ✅ Deployment scriptleri hazırlandı
- ✅ GitHub Actions workflow oluşturuldu

---

## 🎯 Şimdi Ne Yapmalısınız?

### ⚡ En Hızlı Yol (GitHub Actions - ÖNERİLEN)

1. **Değişiklikleri commit edin:**
```bash
git add .
git commit -m "Fix GitHub Pages deployment with correct base href"
git push origin main
```

2. **GitHub Pages Settings'i ayarlayın:**
   - https://github.com/Ozdemiroguz/portfolio/settings/pages adresine gidin
   - **Source:** "Deploy from a branch" seçin
   - **Branch:** `gh-pages` ve `/root` seçin
   - **Save** butonuna tıklayın

3. **Workflow'u izleyin:**
   - https://github.com/Ozdemiroguz/portfolio/actions adresine gidin
   - "Deploy to GitHub Pages" workflow'unun çalıştığını görün
   - ✅ İşareti bekleyin (2-3 dakika sürer)

4. **Sitenizi kontrol edin:**
   - 🌐 https://ozdemiroguz.github.io/portfolio/

---

### 🔧 Alternatif: Manuel Deployment

Eğer GitHub Actions kullanmak istemiyorsanız:

```bash
# Script'i çalıştırın
./deploy-quick.sh

# Ardından çıkan talimatları izleyin
```

---

## 📊 Deployment Sonrası Kontroller

### ✅ Her Şey Çalışıyor mu?

1. **Ana sayfa:** https://ozdemiroguz.github.io/portfolio/
2. **Asset'ler:** Resimleri görebiliyor musunuz?
3. **CV:** PDF açılıyor mu?
4. **Galeri:** Fotoğraflar yükleniyor mu?

### 🐛 Sorun Giderme

**Hala 404 hatası alıyorsanız:**

1. **Base href kontrolü:**
```bash
curl -s https://ozdemiroguz.github.io/portfolio/ | grep '<base'
# Çıktı: <base href="/portfolio/"> olmalı
```

2. **Asset yolu kontrolü:**
   - Console'u açın (F12 → Console)
   - Hangi URL'lere istek atıldığını görün
   - Doğru format: `https://ozdemiroguz.github.io/portfolio/assets/...`

3. **GitHub Pages ayarlarını kontrol edin:**
   - Settings → Pages
   - Source: `gh-pages` branch olmalı
   - Custom domain yoksa boş bırakın

4. **Cache temizliği:**
   - Tarayıcı cache'ini temizleyin (Ctrl+Shift+Delete)
   - Veya gizli mod kullanın

**Yeni değişiklik yaptıysanız:**
```bash
git add .
git commit -m "Update"
git push origin main
# GitHub Actions otomatik deploy eder
```

---

## 📁 Proje Dosyaları

Oluşturulan dosyalar:

1. **`.github/workflows/deploy.yml`** - Otomatik deployment
2. **`deploy.sh`** - Genel deployment scripti
3. **`deploy-quick.sh`** - Hızlı deployment (portfolio için özel)
4. **`DEPLOYMENT.md`** - Detaylı İngilizce rehber
5. **`DEPLOYMENT_TR.md`** - Bu dosya (Türkçe)

---

## 🔄 Güncellemeler İçin

Projede değişiklik yaptığınızda:

```bash
# 1. Değişiklikleri kaydedin
git add .
git commit -m "Yaptığınız değişiklik"

# 2. Push yapın
git push origin main

# ✅ GitHub Actions otomatik deploy edecek
# ⏱️  2-3 dakika sonra değişiklikler yayında olacak
```

---

## 📞 Yardım

Sorun devam ederse:

1. Console'daki hataları kontrol edin (F12)
2. Network tab'ında hangi dosyaların 404 verdiğini görün
3. GitHub Actions logs'larını inceleyin

---

**Site URL:** 🌐 https://ozdemiroguz.github.io/portfolio/

**Son güncelleme:** 3 Kasım 2025

---

## 🎉 Başarılar!

Asset sorunları çözüldü. Artık local'de nasıl çalışıyorsa, GitHub Pages'de de aynı şekilde çalışacak!

