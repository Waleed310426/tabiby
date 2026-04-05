<div align="center">

<img src="assets/icons/app_icon.png" alt="Tabiby Logo" width="120" height="120" />

# 🏥 طبيبي — Tabiby

### منصة الرعاية الصحية الذكية

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?style=for-the-badge&logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)](LICENSE)

</div>

---

## 📖 نبذة عن التطبيق

**طبيبي (Tabiby)** هو تطبيق صحي شامل يهدف إلى تسهيل التواصل بين المرضى والأطباء في اليمن. يتيح التطبيق للمرضى حجز المواعيد، والاستشارة الطبية عن بُعد، ومتابعة سجلاتهم الطبية بكل سهولة ويسر، بينما يمنح الأطباء أدوات احترافية لإدارة عياداتهم ومرضاهم.

---

## ✨ المميزات الرئيسية

### 👤 للمريض
- 🔍 **البحث عن أطباء** متخصصين حسب التخصص والموقع والتقييم
- 📅 **حجز المواعيد** بسهولة وتلقي تأكيد فوري
- 💬 **الاستشارة عن بُعد** عبر المحادثات النصية
- 📋 **السجل الطبي** متابعة التاريخ المرضي والوصفات
- 🔔 **الإشعارات الفورية** تذكيرات المواعيد والمستجدات الطبية
- 🗺️ **خرائط تفاعلية** لتحديد موقع العيادة بدقة
- ⭐ **تقييم الأطباء** ومشاركة التجارب

### 🩺 للطبيب
- 📊 **لوحة تحكم احترافية** لإدارة المواعيد اليومية
- 👥 **إدارة قائمة المرضى** وسجلاتهم الطبية
- 📝 **إصدار الوصفات الطبية** إلكترونياً
- 📈 **إحصائيات وتقارير** شاملة عن العيادة
- 🕐 **إدارة أوقات العمل** والإجازات

### 🛡️ للمشرف (Admin)
- 👨‍⚕️ **إدارة حسابات الأطباء** والتحقق من بياناتهم
- 📦 **إدارة التخصصات الطبية** والفئات
- 📊 **لوحة إحصاءات عامة** للمنصة
- 🚨 **إدارة البلاغات والشكاوى**

---

## 🛠️ التقنيات المستخدمة

### الإطار والبرمجة
| التقنية | الوصف |
|---------|--------|
| **Flutter 3.x** | إطار تطوير التطبيق متعدد المنصات |
| **Dart 3.x** | لغة البرمجة الأساسية |

### الخدمات السحابية (Firebase)
| الخدمة | الاستخدام |
|--------|-----------|
| **Firebase Auth** | تسجيل الدخول والمصادقة |
| **Cloud Firestore** | قاعدة البيانات الرئيسية |
| **Firebase Storage** | تخزين الصور والملفات |
| **Firebase Messaging** | الإشعارات الفورية (Push) |

### المكتبات الأساسية
| المكتبة | الغرض |
|---------|--------|
| `provider` | إدارة الحالة (State Management) |
| `go_router` | التنقل بين الشاشات |
| `dio` | طلبات الشبكة HTTP |
| `google_maps_flutter` | الخرائط التفاعلية |
| `geolocator` | تحديد الموقع الجغرافي |
| `cached_network_image` | تحميل الصور بكفاءة |
| `hive_flutter` | التخزين المحلي السريع |
| `lottie` | الرسوم المتحركة |
| `google_fonts` | خطوط احترافية |
| `flutter_animate` | تأثيرات بصرية سلسة |

---

## 📁 هيكل المشروع

```
tabiby/
├── lib/
│   ├── core/
│   │   ├── constants/        # الثوابت والألوان والنصوص
│   │   ├── routes/           # إعداد التنقل (GoRouter)
│   │   ├── theme/            # الثيمات والأنماط البصرية
│   │   └── utils/            # أدوات مساعدة
│   ├── data/
│   │   ├── models/           # نماذج البيانات
│   │   ├── repositories/     # طبقة الوصول للبيانات
│   │   └── services/         # خدمات Firebase والـ API
│   ├── presentation/
│   │   ├── screens/          # شاشات التطبيق
│   │   │   ├── auth/         # تسجيل الدخول والتسجيل
│   │   │   ├── patient/      # شاشات المريض
│   │   │   ├── doctor/       # شاشات الطبيب
│   │   │   └── admin/        # شاشات المشرف
│   │   ├── widgets/          # المكونات القابلة لإعادة الاستخدام
│   │   └── providers/        # مزودو الحالة
│   └── main.dart             # نقطة البداية
├── assets/
│   ├── images/               # الصور
│   ├── icons/                # الأيقونات
│   ├── fonts/                # خطوط Cairo
│   ├── animations/           # ملفات Lottie
│   └── data/                 # البيانات الثابتة (JSON)
├── pubspec.yaml
└── README.md
```

---

## 🚀 كيفية تشغيل المشروع

### المتطلبات الأساسية
- ✅ Flutter SDK `^3.8.1`
- ✅ Dart SDK `^3.8.1`
- ✅ Android Studio / VS Code
- ✅ حساب Firebase مفعّل

### خطوات التشغيل

```bash
# 1. استنساخ المشروع
git clone https://github.com/your-username/tabiby.git
cd tabiby

# 2. تثبيت الحزم
flutter pub get

# 3. إعداد Firebase
# ضع ملف google-services.json داخل android/app/
# ضع ملف GoogleService-Info.plist داخل ios/Runner/

# 4. تشغيل التطبيق
flutter run
```

### إعداد أيقونة التطبيق
```bash
# بعد وضع app_icon.png في assets/icons/
flutter pub run flutter_launcher_icons
```

---

## 📱 المنصات المدعومة

| المنصة | الحالة |
|--------|--------|
| ✅ Android | مدعوم |
| ✅ iOS | مدعوم |
| 🔄 Web | قيد التطوير |

---

## 🔐 الأمان والخصوصية

- 🔒 تشفير كامل للبيانات المنقولة عبر HTTPS
- 🛡️ قواعد أمان Firestore لحماية بيانات المستخدمين
- 🔑 مصادقة متعددة الطبقات عبر Firebase Auth
- 📵 عدم مشاركة البيانات الطبية مع أطراف ثالثة

---

## 🗂️ المتغيرات البيئية

أنشئ ملف `.env` في جذر المشروع وأضف:
```env
GOOGLE_MAPS_API_KEY=your_api_key_here
```

---

## 🤝 المساهمة في التطوير

هذا مشروع خاص وغير مفتوح للمساهمة العامة حالياً.

---

## 📄 الترخيص

هذا المشروع محمي بحقوق الملكية الفكرية. جميع الحقوق محفوظة © 2026

---

<div align="center">

## 👨‍💻 المطوّر

<br>

**م. وليد العنسي**

مطور تطبيقات الجوال | Flutter Developer

<br>

📞 **للتواصل والطلب:**

[![WhatsApp](https://img.shields.io/badge/WhatsApp-+967_773157823-25D366?style=for-the-badge&logo=whatsapp)](https://wa.me/967773157823)

<br>

> *"نحو رعاية صحية رقمية أفضل في اليمن"*

<br>

---

صُنع بـ ❤️ في اليمن

</div>
