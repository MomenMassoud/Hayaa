# تنصيب وبناء Hayaa على Ubuntu / Ubuntu VPS

دليل لتجهيز البيئة الكاملة وبناء APK بدون واجهة رسومية (headless).

## التشغيل السريع

```bash
chmod +x setup_ubuntu.sh
./setup_ubuntu.sh
```

---

## ما يفعله السكربت تلقائياً

| الخطوة | التفاصيل |
|---|---|
| حزم النظام | curl، git، unzip، OpenJDK 17، cmake، ninja، python3 |
| Android SDK | يُنزّل command-line tools ويثبّت: platform-tools، build-tools;34.0.0، platforms;android-34 |
| قبول التراخيص | `sdkmanager --licenses` + `flutter doctor --android-licenses` |
| Flutter SDK | استنساخ فرع stable من GitHub |
| حزم المشروع | `flutter pub get` |
| بناء APK | `flutter build apk --release` |
| خادم تحميل | Python HTTP server على المنفذ 8080 |

---

## تحميل الـ APK بعد انتهاء السكربت

### من المتصفح
```
http://<IP-الخادم>:8080/app-release.apk
```

### بأمر scp (من جهازك المحلي)
```bash
scp user@<IP-الخادم>:/home/user/Hayaa/build/app/outputs/flutter-apk/app-release.apk ~/hayaa.apk
```

---

## متطلبات VPS

- Ubuntu 20.04 أو 22.04
- ذاكرة RAM: **4 GB كحد أدنى** (يُفضَّل 8 GB لبناء Flutter)
- مساحة تخزين: 10 GB فارغة على الأقل
- المنفذ **8080** مفتوح في جدار الحماية (Security Group / ufw)

### فتح المنفذ في ufw
```bash
sudo ufw allow 8080/tcp
```

---

## إيقاف الخادم بعد التحميل

اضغط `Ctrl+C` في الطرفية.

---

## حل المشاكل الشائعة

| المشكلة | الحل |
|---|---|
| `flutter: command not found` | `source ~/.bashrc` أو أعد فتح الطرفية |
| `sdkmanager: Permission denied` | تأكد أن unzip اكتمل، أو أعد تشغيل السكربت |
| فشل بناء الـ APK | شغّل `flutter doctor -v` للتشخيص |
| الخادم لا يُعطي الملف | تأكد أن المنفذ 8080 مفتوح وأن السكربت لا يزال يعمل |
| نفاد الذاكرة أثناء البناء | أضف swap: `sudo fallocate -l 4G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile` |

---

## التشغيل على جوال عبر USB (للتطوير المحلي فقط)

1. على الجوال: الإعدادات → حول الهاتف → اضغط **رقم الإصدار** 7 مرات
2. خيارات المطوّر → فعّل **تصحيح USB**
3. وصّل الجوال واضغط **سماح**
4. `flutter devices` ثم `flutter run`

---

## متطلبات المشروع

- Dart SDK: `>=3.2.3 <4.0.0`
- minSdkVersion: 23 (Android 6.0+)
- ملف `android/app/google-services.json` موجود (Firebase)
- صلاحيات الميكروفون مطلوبة للغرف الصوتية (ZEGOCLOUD)
