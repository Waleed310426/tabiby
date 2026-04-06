// ============================================================
// ملف: app_constants.dart
// الوصف: الثوابت العامة والإعدادات الرقمية لتطبيق طبيبي
// تشمل: مهلات الشبكة، حدود الصفحة، مفاتيح التخزين...
// ============================================================

class AppConstants {
  // منع إنشاء كائن من هذه الكلاس
  AppConstants._();

  // ─── معلومات التطبيق ─────────────────────────────────────
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ─── إعدادات الشبكة ──────────────────────────────────────
  // المهلة القصوى لانتظار استجابة الخادم (بالثواني)
  static const int networkTimeoutSeconds = 30;

  // ─── إعدادات الصفحات (Pagination) ───────────────────────
  // عدد العناصر التي تُحمَّل في كل طلب للقوائم
  static const int defaultPageSize = 20;

  // عدد الأطباء المميزين المعروضين في الشاشة الرئيسية
  static const int featuredDoctorsLimit = 6;

  // عدد المقالات المعروضة في الشاشة الرئيسية
  static const int featuredArticlesLimit = 4;

  // ─── إعدادات حجز المواعيد ────────────────────────────────
  // مدة القفل المؤقت للموعد أثناء عملية الدفع (بالدقائق)
  static const int appointmentLockMinutes = 10;

  // أقصى عدد من الأيام للحجز المسبق
  static const int maxAdvanceBookingDays = 30;

  // مدة التذكير بالموعد قبل وقته (بالساعات)
  static const int appointmentReminderHours1 = 24; // تذكير أول
  static const int appointmentReminderHours2 = 3;  // تذكير ثانٍ

  // ─── إعدادات الاستشارات ──────────────────────────────────
  // الحد الأقصى لحجم الملف المرفق في الاستشارة (بالميجابايت)
  static const int maxAttachmentSizeMB = 10;

  // أقصى عدد من الصور في استشارة واحدة
  static const int maxAttachmentsCount = 5;

  // ─── إعدادات الصور ───────────────────────────────────────
  // الحد الأقصى لحجم الصورة الشخصية (بالميجابايت)
  static const int maxProfileImageSizeMB = 2;

  // جودة ضغط الصور (0-100) — 80 توازن جيد بين الجودة والحجم
  static const int imageCompressionQuality = 80;

  // ─── إعدادات الموقع الجغرافي ─────────────────────────────
  // نطاق البحث عن الأطباء القريبين افتراضياً (بالكيلومترات)
  static const double defaultSearchRadiusKm = 10.0;

  // أقصى نطاق للبحث الجغرافي (بالكيلومترات)
  static const double maxSearchRadiusKm = 50.0;

  // ─── مفاتيح التخزين المحلي (Hive / SharedPreferences) ────
  // تُستخدم هذه المفاتيح للتخزين المحلي على الجهاز
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyLanguage = 'app_language';
  static const String keyDarkMode = 'dark_mode';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyLastSyncTime = 'last_sync_time';

  // ─── إعدادات التقييمات ───────────────────────────────────
  // الحد الأدنى لعدد التقييمات قبل عرض المتوسط
  static const int minReviewsToShowRating = 3;

  // ─── مهلة انتهاء صلاحية الوصفة الطبية (بالأيام) ─────────
  static const int prescriptionExpiryDays = 30;

  // ─── حدود الصيدلية ───────────────────────────────────────
  // الحد الأدنى لكمية الدواء في المخزون قبل إرسال التنبيه
  static const int pharmacyLowStockDefault = 10;

  // ─── إعدادات رمز التحقق OTP ──────────────────────────────
  // مدة صلاحية رمز التحقق (بالثواني)
  static const int otpExpirySeconds = 120; // دقيقتان

  // عدد الأرقام في رمز التحقق
  static const int otpLength = 6;

  // ─── إعدادات Google Maps ─────────────────────────────────
  // الإحداثيات الافتراضية (مركز مدينة صنعاء — اليمن)
  static const double defaultLatitude = 15.3694;
  static const double defaultLongitude = 44.1910;
  static const double defaultMapZoom = 13.0;
}
