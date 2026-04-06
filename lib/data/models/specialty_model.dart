// ============================================================
// ملف: specialty_model.dart
// الوصف: نموذج بيانات التخصص الطبي في تطبيق طبيبي
// يُمثّل كل تخصص طبي متاح في التطبيق للبحث والتصفية
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── النموذج الرئيسي للتخصص الطبي ───────────────────────────
class SpecialtyModel {
  final String id;            // معرّف التخصص الفريد
  final String nameAr;        // اسم التخصص بالعربية
  final String nameEn;        // اسم التخصص بالإنجليزية
  final String iconUrl;       // رابط أيقونة التخصص
  final String description;   // وصف مختصر للتخصص
  final int doctorsCount;     // عدد الأطباء المتاحين في هذا التخصص
  final bool isActive;        // هل التخصص نشط ومتاح؟
  final int sortOrder;        // ترتيب العرض في الواجهة

  const SpecialtyModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
    this.description = '',
    this.doctorsCount = 0,
    this.isActive = true,
    this.sortOrder = 0,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'icon_url': iconUrl,
      'description': description,
      'doctors_count': doctorsCount,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory SpecialtyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SpecialtyModel(
      id: doc.id,
      nameAr: data['name_ar'] ?? '',
      nameEn: data['name_en'] ?? '',
      iconUrl: data['icon_url'] ?? '',
      description: data['description'] ?? '',
      doctorsCount: data['doctors_count'] ?? 0,
      isActive: data['is_active'] ?? true,
      sortOrder: data['sort_order'] ?? 0,
    );
  }

  // ─── إرجاع الاسم حسب لغة التطبيق الحالية ─────────────────
  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  @override
  String toString() => 'SpecialtyModel(id: $id, nameAr: $nameAr, doctors: $doctorsCount)';
}
