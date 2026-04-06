// ============================================================
// ملف: lab_model.dart
// الوصف: نموذج بيانات المختبر ومركز الأشعة في تطبيق طبيبي
// يحتوي على معلومات المختبر والفحوصات التي يقدمها
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_model.dart'; // لاستخدام نموذج WorkingHours

// ─── حالة المختبر ───────────────────────────────────────────
enum LabStatus {
  active,   // نشط
  inactive, // غير نشط
}

// ─── النموذج الرئيسي للمختبر / مركز الأشعة ─────────────────
class LabModel {
  final String id;                       // معرّف المختبر الفريد
  final String userId;                   // معرّف حساب المستخدم المرتبط
  final String name;                     // اسم المختبر أو مركز الأشعة
  final String address;                  // العنوان التفصيلي
  final double? latitude;                // خط العرض الجغرافي
  final double? longitude;               // خط الطول الجغرافي
  final String phoneNumber;              // رقم الهاتف
  final String? email;                   // البريد الإلكتروني
  final List<WorkingHours> workingHours; // جدول أوقات العمل
  final List<String> testsOffered;       // قائمة بأنواع الفحوصات المتاحة
  final bool homeVisitAvailable;         // هل يتوفر زيارة منزلية لأخذ العينات؟
  final bool isApprovedByAdmin;          // هل وافق عليه الأدمن؟
  final LabStatus status;                // حالة المختبر

  const LabModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.phoneNumber,
    this.email,
    this.workingHours = const [],
    this.testsOffered = const [],
    this.homeVisitAvailable = false,
    this.isApprovedByAdmin = false,
    this.status = LabStatus.active,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'email': email,
      'working_hours': workingHours.map((w) => w.toMap()).toList(),
      'tests_offered': testsOffered,
      'home_visit_available': homeVisitAvailable,
      'is_approved_by_admin': isApprovedByAdmin,
      'status': status.name,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory LabModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LabModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      phoneNumber: data['phone_number'] ?? '',
      email: data['email'],
      workingHours: (data['working_hours'] as List<dynamic>? ?? [])
          .map((w) => WorkingHours.fromMap(w))
          .toList(),
      testsOffered: List<String>.from(data['tests_offered'] ?? []),
      homeVisitAvailable: data['home_visit_available'] ?? false,
      isApprovedByAdmin: data['is_approved_by_admin'] ?? false,
      status: LabStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => LabStatus.active,
      ),
    );
  }

  @override
  String toString() => 'LabModel(id: $id, name: $name)';
}
