#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Hayaa — سكربت تنصيب تلقائي على Ubuntu / Ubuntu VPS
# يثبّت كل المتطلبات بدون واجهة رسومية (headless)
# ويبني APK ويشغّل خادم HTTP لتحميله.
#
# الاستخدام على VPS:
#   chmod +x setup_ubuntu.sh
#   ./setup_ubuntu.sh
#
# بعد الانتهاء:
#   افتح المتصفح على: http://<IP>:8080/app-release.apk
# ─────────────────────────────────────────────────────────────
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}==>${NC} $1"; }
warn()  { echo -e "${YELLOW}!!${NC} $1"; }
error() { echo -e "${RED}xx${NC} $1"; exit 1; }

FLUTTER_DIR="$HOME/flutter"
ANDROID_DIR="$HOME/android-sdk"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APK_OUT="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"

export ANDROID_SDK_ROOT="$ANDROID_DIR"
export ANDROID_HOME="$ANDROID_DIR"

# ─── 1) حزم النظام ───────────────────────────────────────────
info "تحديث النظام وتثبيت الحزم الأساسية..."
sudo apt-get update -y
sudo apt-get install -y \
  curl git unzip xz-utils zip wget \
  libglu1-mesa lib32stdc++6 libpulse0 \
  clang cmake ninja-build pkg-config \
  python3 openjdk-17-jdk-headless

# ─── 2) Android SDK (command-line tools) ─────────────────────
if [ ! -d "$ANDROID_DIR/cmdline-tools/latest/bin" ]; then
  info "تنزيل Android Command-Line Tools..."
  mkdir -p "$ANDROID_DIR/cmdline-tools"
  TMP_ZIP="$(mktemp /tmp/cmdtools-XXXX.zip)"
  wget -q --show-progress -O "$TMP_ZIP" "$CMDTOOLS_URL"
  unzip -q "$TMP_ZIP" -d "$ANDROID_DIR/cmdline-tools"
  # sdkmanager يتوقع المسار: cmdline-tools/latest/
  mv "$ANDROID_DIR/cmdline-tools/cmdline-tools" "$ANDROID_DIR/cmdline-tools/latest" 2>/dev/null || true
  rm "$TMP_ZIP"
else
  info "Android Command-Line Tools موجودة بالفعل."
fi

SDKMANAGER="$ANDROID_DIR/cmdline-tools/latest/bin/sdkmanager"

# ─── 3) Android SDK components ───────────────────────────────
info "تثبيت مكونات Android SDK (platform-tools, build-tools, platform)..."
yes | "$SDKMANAGER" --sdk_root="$ANDROID_DIR" \
  "platform-tools" \
  "build-tools;34.0.0" \
  "platforms;android-34" \
  "cmdline-tools;latest" 2>/dev/null

info "قبول تراخيص Android SDK..."
yes | "$SDKMANAGER" --sdk_root="$ANDROID_DIR" --licenses 2>/dev/null || true

# ─── 4) PATH ──────────────────────────────────────────────────
export PATH="$ANDROID_DIR/cmdline-tools/latest/bin:$ANDROID_DIR/platform-tools:$PATH"

for LINE in \
  "export ANDROID_SDK_ROOT=\"$ANDROID_DIR\"" \
  "export ANDROID_HOME=\"$ANDROID_DIR\"" \
  "export PATH=\"$ANDROID_DIR/cmdline-tools/latest/bin:\$ANDROID_DIR/platform-tools:\$PATH\"" \
  "export PATH=\"\$HOME/flutter/bin:\$PATH\""
do
  grep -qF "$LINE" "$HOME/.bashrc" || echo "$LINE" >> "$HOME/.bashrc"
done

# ─── 5) Flutter SDK ───────────────────────────────────────────
if [ ! -d "$FLUTTER_DIR" ]; then
  info "تنزيل Flutter SDK (stable)..."
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
else
  info "Flutter موجود — تحديث..."
  git -C "$FLUTTER_DIR" pull || warn "تعذّر التحديث، سنكمل بالنسخة الحالية."
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# تنزيل Dart/engine مباشرة
info "تهيئة Flutter (تنزيل engine)..."
flutter precache --android --no-ios --no-web --no-linux --no-macos --no-windows

# ─── 6) موافقة تراخيص Flutter ────────────────────────────────
info "قبول تراخيص Flutter/Android..."
yes | flutter doctor --android-licenses 2>/dev/null || true

# ─── 7) تثبيت حزم المشروع ────────────────────────────────────
info "تثبيت حزم المشروع (flutter pub get)..."
cd "$PROJECT_DIR"
flutter pub get

# ─── 8) فحص البيئة ───────────────────────────────────────────
info "فحص البيئة (flutter doctor):"
flutter doctor -v || true

# ─── 9) بناء APK ──────────────────────────────────────────────
info "بناء APK (release)... قد يستغرق 5-15 دقيقة"
flutter build apk --release

if [ -f "$APK_OUT" ]; then
  SIZE=$(du -sh "$APK_OUT" | cut -f1)
  info "✅ تم بناء APK بنجاح! الحجم: $SIZE"
  info "   المسار: $APK_OUT"
else
  error "فشل بناء APK — لم يُعثر على الملف."
fi

# ─── 10) خادم HTTP لتحميل APK ────────────────────────────────
APK_DIR="$(dirname "$APK_OUT")"
PORT=8080

info "تشغيل خادم HTTP على المنفذ $PORT ..."
echo ""
echo "════════════════════════════════════════════════════"
echo "  رابط التحميل:"
echo ""

# محاولة الحصول على IP العام
PUBLIC_IP=$(curl -s --connect-timeout 5 ifconfig.me 2>/dev/null || \
            curl -s --connect-timeout 5 api.ipify.org 2>/dev/null || \
            hostname -I | awk '{print $1}')

echo "  http://${PUBLIC_IP}:${PORT}/app-release.apk"
echo ""
echo "  أو عبر scp من جهازك المحلي:"
echo "  scp user@${PUBLIC_IP}:${APK_OUT} ~/hayaa.apk"
echo ""
echo "  اضغط Ctrl+C لإيقاف الخادم."
echo "════════════════════════════════════════════════════"
echo ""

warn "تأكد من أن المنفذ $PORT مفتوح في جدار الحماية (firewall/security group)."
echo ""

cd "$APK_DIR"
python3 -m http.server "$PORT"
