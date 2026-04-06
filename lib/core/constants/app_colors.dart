// ============================================================
// ملف: app_colors.dart
// الوصف: جميع ألوان تطبيق طبيبي المركزية
// استيراد هذا الملف يُغني عن تعريف الألوان في كل مكان
//
// القاعدة: لا تستخدم قيم ألوان مباشرة في الشاشات أو الودجات
//           استخدم دائماً الثوابت المعرفة هنا
// ============================================================

import 'package:flutter/material.dart';

// ─── الألوان الأساسية (Primary) ─────────────────────────────
class AppColors {
  // منع إنشاء كائن من هذه الكلاس (utility class)
  AppColors._();

  // اللون الأزرق الطبي الرئيسي — يُستخدم في AppBar والأزرار الرئيسية
  static const Color primary = Color(0xFF1565C0);

  // درجة أفتح من اللون الرئيسي — للخلفيات والعناصر الثانوية
  static const Color primaryLight = Color(0xFF42A5F5);

  // درجة أغمق من اللون الرئيسي — للنصوص المميزة والحدود
  static const Color primaryDark = Color(0xFF0D47A1);

  // ─── الألوان الثانوية (Secondary) ─────────────────────────
  // الأخضر الصحي — للحالات النشطة والنجاح والموافقة
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color secondaryDark = Color(0xFF00796B);

  // ─── ألوان الحالات (Status Colors) ────────────────────────
  // نجاح: تأكيد الحجز، عملية ناجحة، حالة مكتملة
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);

  // تحذير: مواعيد قادمة، مخزون منخفض، تنبيهات
  static const Color warning = Color(0xFFF57F17);
  static const Color warningLight = Color(0xFFFFFDE7);

  // خطأ: فشل العملية، رفض الطلب، بيانات غير صحيحة
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFFFEBEE);

  // معلومات: إشعارات عامة، تلميحات
  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ─── ألوان الطوارئ ─────────────────────────────────────────
  // أحمر فاقع — للأزرار والتنبيهات الطارئة
  static const Color emergency = Color(0xFFD32F2F);
  static const Color emergencyLight = Color(0xFFFFCDD2);

  // ─── ألوان محايدة (Neutral) ────────────────────────────────
  // تُستخدم للنصوص والحدود والخلفيات
  static const Color textPrimary = Color(0xFF212121);    // نص رئيسي
  static const Color textSecondary = Color(0xFF757575);  // نص ثانوي
  static const Color textHint = Color(0xFFBDBDBD);       // نص تلميح
  static const Color textDisabled = Color(0xFFE0E0E0);   // نص معطّل

  // ─── ألوان الخلفيات ────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F5F5); // خلفية فاتحة
  static const Color backgroundCard = Color(0xFFFFFFFF);  // خلفية البطاقات
  static const Color backgroundDark = Color(0xFF121212);  // خلفية داكنة

  // ─── ألوان الحدود والفواصل ─────────────────────────────────
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // ─── ألوان النجوم (التقييمات) ──────────────────────────────
  static const Color starFilled = Color(0xFFFFA000);  // نجمة مملوءة
  static const Color starEmpty = Color(0xFFE0E0E0);   // نجمة فارغة

  // ─── ألوان أصحاب المصلحة ───────────────────────────────────
  // لون مميز لكل صاحب مصلحة يُستخدم في شارات الأدوار والأيقونات
  static const Color patientColor = Color(0xFF1565C0);    // المريض — أزرق
  static const Color doctorColor = Color(0xFF00897B);     // الطبيب — أخضر مزرق
  static const Color pharmacyColor = Color(0xFF558B2F);   // الصيدلية — أخضر
  static const Color labColor = Color(0xFF6A1B9A);        // المختبر — بنفسجي
  static const Color emergencyColor = Color(0xFFD32F2F);  // الطوارئ — أحمر
  static const Color adminColor = Color(0xFF37474F);      // الأدمن — رمادي داكن
}
