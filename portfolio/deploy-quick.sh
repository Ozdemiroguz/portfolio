#!/bin/bash

# Hızlı Deployment Script
# Bu script portfolio repository için özelleştirilmiştir

set -e

echo "🚀 Portfolio deployment başlıyor..."
echo ""

# Renk kodları
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Temizlik
echo "🧹 Temizlik yapılıyor..."
flutter clean

# 2. Dependencies
echo "📦 Dependencies yükleniyor..."
flutter pub get

# 3. Build (base-href /portfolio/ ile)
echo "🔨 Web için build ediliyor..."
flutter build web --release --base-href "/portfolio/"

# 4. .nojekyll ekle
echo "📝 .nojekyll ekleniyor..."
touch build/web/.nojekyll

# 5. Asset kontrolü
echo "🔍 Asset kontrolü..."
if [ -d "build/web/assets/assets/images" ]; then
    IMAGE_COUNT=$(ls -1 build/web/assets/assets/images | wc -l)
    echo -e "${GREEN}✅ Images klasörü mevcut - $IMAGE_COUNT dosya${NC}"
else
    echo -e "${RED}❌ Images klasörü bulunamadı!${NC}"
    exit 1
fi

if [ -f "build/web/assets/assets/Oguzhan-Ozdemir-Resume-20251030.pdf" ]; then
    echo -e "${GREEN}✅ CV dosyası mevcut${NC}"
else
    echo -e "${RED}❌ CV dosyası bulunamadı!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Build başarılı!${NC}"
echo ""
echo -e "${BLUE}📋 Deployment Seçenekleri:${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}SEÇENEK 1: GitHub Actions (ÖNERİLEN)${NC}"
echo ""
echo "1. Değişiklikleri commit edin:"
echo "   git add ."
echo "   git commit -m 'Update deployment configuration'"
echo ""
echo "2. Push yapın:"
echo "   git push origin main"
echo ""
echo "3. GitHub'da Actions tab'ına gidin ve workflow'u izleyin"
echo "   https://github.com/Ozdemiroguz/portfolio/actions"
echo ""
echo "4. GitHub Pages Settings'i kontrol edin:"
echo "   https://github.com/Ozdemiroguz/portfolio/settings/pages"
echo "   Source: 'Deploy from a branch' → 'gh-pages' branch seçin"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}SEÇENEK 2: Manuel Deployment${NC}"
echo ""
echo "1. gh-pages branch'ine geçin (veya oluşturun):"
echo "   git checkout gh-pages || git checkout --orphan gh-pages"
echo ""
echo "2. build/web içeriğini kopyalayın:"
echo "   cp -r build/web/* ."
echo ""
echo "3. Commit ve push:"
echo "   git add ."
echo "   git commit -m 'Deploy'"
echo "   git push origin gh-pages"
echo ""
echo "4. main branch'e geri dönün:"
echo "   git checkout main"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}Site URL'niz:${NC} https://ozdemiroguz.github.io/portfolio/"
echo ""
echo -e "${YELLOW}Not:${NC} İlk deployment 2-3 dakika sürebilir."
echo ""

