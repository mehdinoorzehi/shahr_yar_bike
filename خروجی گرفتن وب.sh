#!/bin/bash

# تبدیل فایل pubspec.yaml به فرمت یونیکس
dos2unix pubspec.yaml

echo "Incrementing build version..."
# افزایش نسخه در فایل pubspec.yaml
perl -i -pe 's/^(version:\s+\d+\.\d+\.)(\d+)\+(\d+)$/$1.($2+1)."+".($3+1)/e' pubspec.yaml

flutter clean
flutter packages get

echo "Building web (lightweight mode)..."
flutter build web --release --wasm --tree-shake-icons --pwa-strategy=none

# بروزرسانی base href در index.html
echo "Updating base href..."
baseHref="/"
sed -i "s|<base href=\"/\">|<base href=\"$baseHref\">|g" build/web/index.html

# خواندن نسخه از pubspec.yaml
echo "Reading version from pubspec.yaml..."
version=$(grep version: pubspec.yaml | sed 's/version: //g' | sed 's/+//g')

# اضافه کردن نسخه به فایل‌های JS و bootstrap
echo "Patching version in js partial URLs in main.dart.js..."
sed -i "s/\"main.dart.js\"/\"main.dart.js?v=$version\"/g" build/web/flutter.js
sed -i "s/\"main.dart.js\"/\"main.dart.js?v=$version\"/g" build/web/flutter_bootstrap.js
sed -i "s/\"main.dart.js\"/\"main.dart.js?v=$version\"/g" build/web/index.html

# بروزرسانی درخواست‌ها در main.dart.js برای اضافه کردن نسخه
echo "Patching assets loader with v=$version in main.dart.js..."
sed -i "s/self\.window\.fetch(a),/self.window.fetch(a + '?v=$version'),/g" build/web/main.dart.js

# اضافه کردن نسخه به manifest.json
echo "Adding v= to manifest.json..."
sed -i 's/"manifest.json"/"manifest.json?v='"$version"'"/' build/web/index.html

# بروزرسانی Service Worker (اگر PWA استفاده می‌کنید)
# echo "Updating service worker for cache invalidation..."
# sed -i "s/'CACHE_NAME', 'my-cache-v1'/'CACHE_NAME', 'my-cache-v${version}'/g" build/web/flutter_service_worker.js

# حذف Service Worker قدیمی (در صورتی که استفاده می‌کنید)
echo "Unregistering old service workers..."
sed -i "s/serviceWorker.unregister()//g" build/web/index.html

echo "Build completed with version $version!"
