#!/bin/bash

# Flutter Web GitHub Pages Deploy Script
# Bu script projenizi GitHub Pages için build eder ve deploy eder

set -e  # Hata durumunda scripti durdur

echo "🚀 Flutter Web deployment başlıyor..."

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Deploy türünü belirle
echo ""
echo "GitHub Pages deploy türünü seçin:"
echo "1) User/Organization page (https://ozdemiroguz.github.io/)"
echo "2) Project page (https://ozdemiroguz.github.io/repository-name/)"
read -p "Seçiminiz (1 veya 2): " deploy_type

BASE_HREF="/"

if [ "$deploy_type" = "2" ]; then
    read -p "Repository adını girin (örn: portfolio): " repo_name
    BASE_HREF="/$repo_name/"
    echo -e "${YELLOW}Base href: $BASE_HREF${NC}"
else
    echo -e "${YELLOW}Base href: $BASE_HREF${NC}"
fi

# 1. Flutter temizliği
echo ""
echo "🧹 Önceki build dosyaları temizleniyor..."
flutter clean

# 2. Dependencies güncelleniyor
echo ""
echo "📦 Dependencies güncelleniyor..."
flutter pub get

# 3. Web için build
echo ""
echo "🔨 Web için build ediliyor (base-href: $BASE_HREF)..."
flutter build web --release --base-href "$BASE_HREF"

# 4. Build başarılı mı kontrol et
if [ ! -d "build/web" ]; then
    echo -e "${RED}❌ Build başarısız! build/web klasörü oluşturulamadı.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build başarılı!${NC}"

# 5. .nojekyll dosyası ekle (GitHub Pages için gerekli)
echo ""
echo "📝 .nojekyll dosyası ekleniyor..."
touch build/web/.nojekyll

# 6. Asset'leri kontrol et
echo ""
echo "🔍 Asset'ler kontrol ediliyor..."
if [ -d "build/web/assets" ]; then
    echo -e "${GREEN}✅ Assets klasörü mevcut${NC}"
    if [ -d "build/web/assets/images" ]; then
        echo -e "${GREEN}✅ Images klasörü mevcut${NC}"
        echo "   Dosya sayısı: $(ls -1 build/web/assets/images | wc -l)"
    else
        echo -e "${RED}⚠️  Images klasörü bulunamadı!${NC}"
    fi
else
    echo -e "${RED}❌ Assets klasörü bulunamadı!${NC}"
    exit 1
fi

# 7. Deploy talimatları
echo ""
echo -e "${GREEN}✅ Build tamamlandı!${NC}"
echo ""
echo "📋 Deploy için aşağıdaki adımları izleyin:"
echo ""
echo "1️⃣  build/web klasörünün içeriğini GitHub repository'nizin root'una kopyalayın:"
echo "   cd build/web"
echo "   cp -r * ../../deployed-repo/"
echo ""
echo "2️⃣  Veya GitHub Actions ile otomatik deploy için workflow ekleyin"
echo ""
echo "3️⃣  Manuel deploy:"
echo "   cd build/web"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Deploy to GitHub Pages'"
if [ "$deploy_type" = "1" ]; then
    echo "   git remote add origin https://github.com/ozdemiroguz/ozdemiroguz.github.io.git"
else
    echo "   git remote add origin https://github.com/ozdemiroguz/$repo_name.git"
fi
echo "   git branch -M main"
echo "   git push -u origin main --force"
echo ""
echo -e "${YELLOW}⚠️  Not: GitHub Pages Settings'te Source'u 'main branch' olarak ayarlamayı unutmayın!${NC}"
echo ""

