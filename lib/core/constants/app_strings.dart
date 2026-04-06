// ============================================================
// ملف: app_strings.dart
// الوصف: جميع النصوص الثابتة لتطبيق طبيبي
// يحتوي على النصوص العربية المستخدمة في الواجهات
//
// القاعدة: لا تكتب نصوصاً مباشرة في الشاشات أو الودجات
//           استخدم دائماً الثوابت المعرفة هنا للحفاظ
//           على الاتساق وتسهيل الترجمة مستقبلاً
// ============================================================

class AppStrings {
  // منع إنشاء كائن من هذه الكلاس
  AppStrings._();

  // ─── اسم التطبيق ────────────────────────────────────────────
  static const String appName = 'طبيبي';
  static const String appNameEn = 'Tabiby';
  static const String appTagline = 'رعايتك أولويتنا';

  // ─── شاشة تسجيل الدخول والتسجيل ────────────────────────────
  static const String login = 'تسجيل الدخول';
  static const String signup = 'إنشاء حساب جديد';
  static const String logout = 'تسجيل الخروج';
  static const String phoneNumber = 'رقم الهاتف';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String fullName = 'الاسم الكامل';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String alreadyHaveAccount = 'لدي حساب بالفعل';
  static const String dontHaveAccount = 'لا تملك حساباً؟';
  static const String orSignInWith = 'أو سجّل الدخول بواسطة';
  static const String verifyPhone = 'التحقق من رقم الهاتف';
  static const String sendOtp = 'إرسال رمز التحقق';
  static const String enterOtp = 'أدخل رمز التحقق المُرسَل إليك';

  // ─── الشاشة الرئيسية ────────────────────────────────────────
  static const String home = 'الرئيسية';
  static const String searchHint = 'ابحث عن طبيب، تخصص، عيادة...';
  static const String featuredDoctors = 'أطباء مميزون';
  static const String healthArticles = 'مقالات صحية';
  static const String viewAll = 'عرض الكل';

  // ─── خدمات التطبيق الرئيسية ─────────────────────────────────
  static const String bookAppointment = 'حجز موعد';
  static const String instantConsultation = 'استشارة فورية';
  static const String pharmacy = 'الصيدلية';
  static const String labsAndRadiology = 'المختبرات والأشعة';
  static const String emergency = 'الطوارئ';

  // ─── شاشة الطبيب ────────────────────────────────────────────
  static const String aboutDoctor = 'نبذة عن الطبيب';
  static const String services = 'الخدمات';
  static const String workingHours = 'ساعات العمل';
  static const String ratingsAndReviews = 'التقييمات والمراجعات';
  static const String clinicLocation = 'موقع العيادة';
  static const String viewOnMap = 'عرض على الخريطة';
  static const String consultationFee = 'رسوم الاستشارة';
  static const String yearsOfExperience = 'سنوات الخبرة';

  // ─── شاشة الحجز ─────────────────────────────────────────────
  static const String selectDate = 'اختر التاريخ';
  static const String selectTime = 'اختر الوقت';
  static const String visitType = 'نوع الزيارة';
  static const String clinicVisit = 'زيارة عيادة';
  static const String teleconsultation = 'استشارة عن بعد';
  static const String addNotes = 'إضافة ملاحظات';
  static const String confirmBooking = 'تأكيد الحجز';
  static const String bookingConfirmed = 'تم الحجز بنجاح!';

  // ─── أوضاع الدفع ────────────────────────────────────────────
  static const String paymentMethod = 'طريقة الدفع';
  static const String cashOnArrival = 'دفع عند الوصول';
  static const String kareemi = 'كريمي';
  static const String mFloos = 'إم فلوس';
  static const String bankTransfer = 'تحويل بنكي';

  // ─── السجل الطبي ────────────────────────────────────────────
  static const String medicalRecord = 'السجل الطبي';
  static const String prescriptions = 'الوصفات الطبية';
  static const String labResults = 'نتائج التحاليل';
  static const String vaccinations = 'التطعيمات';
  static const String addManualRecord = 'إضافة سجل يدوي';
  static const String shareRecord = 'مشاركة السجل';

  // ─── الإشعارات ──────────────────────────────────────────────
  static const String notifications = 'الإشعارات';
  static const String noNotifications = 'لا توجد إشعارات';
  static const String markAllRead = 'تحديد الكل كمقروء';

  // ─── رسائل الخطأ والتحقق ────────────────────────────────────
  static const String fieldRequired = 'هذا الحقل مطلوب';
  static const String invalidPhone = 'رقم الهاتف غير صحيح';
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';
  static const String passwordTooShort = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
  static const String passwordMismatch = 'كلمتا المرور غير متطابقتين';
  static const String somethingWentWrong = 'حدث خطأ، يرجى المحاولة مجدداً';
  static const String noInternetConnection = 'لا يوجد اتصال بالإنترنت';

  // ─── أزرار مشتركة ───────────────────────────────────────────
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String edit = 'تعديل';
  static const String delete = 'حذف';
  static const String back = 'رجوع';
  static const String next = 'التالي';
  static const String done = 'تم';
  static const String retry = 'إعادة المحاولة';
  static const String loading = 'جارٍ التحميل...';
  static const String noDataFound = 'لا توجد بيانات';

  // ─── القائمة الجانبية ───────────────────────────────────────
  static const String profile = 'الملف الشخصي';
  static const String myFamily = 'ملفات العائلة';
  static const String myAppointments = 'حجوزاتي';
  static const String myConsultations = 'استشاراتي';
  static const String myMedicalFile = 'ملفي الطبي';
  static const String settings = 'الإعدادات';
  static const String helpAndSupport = 'المساعدة والدعم';
  static const String faq = 'الأسئلة الشائعة';
  static const String contactUs = 'تواصل معنا';

  // ─── الإعدادات ──────────────────────────────────────────────
  static const String language = 'اللغة';
  static const String arabic = 'العربية';
  static const String english = 'English';
  static const String darkMode = 'الوضع الليلي';
  static const String lightMode = 'الوضع النهاري';
  static const String manageNotifications = 'إدارة التنبيهات';

  // ─── أسماء مجموعات Firestore ─────────────────────────────────
  // ثوابت أسماء المجموعات في قاعدة البيانات لتجنب الأخطاء الإملائية
  static const String colUsers = 'users';
  static const String colDoctors = 'doctors';
  static const String colAppointments = 'appointments';
  static const String colConsultations = 'consultations';
  static const String colMedicalRecords = 'medical_records';
  static const String colPrescriptions = 'prescriptions';
  static const String colPharmacies = 'pharmacies';
  static const String colMedicines = 'medicines';
  static const String colInventory = 'pharmacy_inventory';
  static const String colLabs = 'labs';
  static const String colLabTests = 'lab_test_requests';
  static const String colEmergencies = 'emergencies';
  static const String colAmbulances = 'ambulances';
  static const String colNotifications = 'notifications';
  static const String colReviews = 'reviews';
  static const String colPayments = 'payments';
  static const String colArticles = 'articles';
  static const String colSpecialties = 'specialties';
  static const String colFacilities = 'facilities';
  static const String colFamilyMembers = 'family_members';
  static const String colComplaints = 'complaints';
  static const String colChatMessages = 'chat_messages';
}
