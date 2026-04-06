// ============================================================
// ملف: pharmacy_model.dart
// الوصف: نموذج بيانات الصيدلية في تطبيق طبيبي
// يحتوي على معلومات الصيدلية وخدمات التوصيل المتاحة
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
// استيراد نموذج ساعات العمل المشترك من نموذج الطبيب
import 'doctor_model.dart';

// ─── حالة الصيدلية ──────────────────────────────────────────
enum PharmacyStatus {
  active,   // نشطة
  inactive, // غير نشطة
}

// ─── النموذج الرئيسي للصيدلية ───────────────────────────────
class PharmacyModel {
  final String id;                       // معرّف الصيدلية الفريد
  final String userId;                   // معرّف حساب المستخدم المرتبط
  final String name;                     // اسم الصيدلية
  final String address;                  // العنوان التفصيلي
  final double? latitude;                // خط العرض الجغرافي
  final double? longitude;               // خط الطول الجغرافي
  final String phoneNumber;              // رقم الهاتف
  final String? email;                   // البريد الإلكتروني
  final List<WorkingHours> workingHours; // جدول أوقات العمل
  final bool deliveryAvailable;          // هل يتوفر توصيل للمنازل؟
  final double deliveryRadiusKm;         // نطاق التوصيل بالكيلومترات
  final bool isApprovedByAdmin;          // هل وافق عليها الأدمن؟
  final PharmacyStatus status;           // حالة الصيدلية

  const PharmacyModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.phoneNumber,
    this.email,
    this.workingHours = const [],
    this.deliveryAvailable = false,
    this.deliveryRadiusKm = 0.0,
    this.isApprovedByAdmin = false,
    this.status = PharmacyStatus.active,
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
      'delivery_available': deliveryAvailable,
      'delivery_radius_km': deliveryRadiusKm,
      'is_approved_by_admin': isApprovedByAdmin,
      'status': status.name,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory PharmacyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PharmacyModel(
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
      deliveryAvailable: data['delivery_available'] ?? false,
      deliveryRadiusKm: (data['delivery_radius_km'] ?? 0.0).toDouble(),
      isApprovedByAdmin: data['is_approved_by_admin'] ?? false,
      status: PharmacyStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => PharmacyStatus.active,
      ),
    );
  }

  @override
  String toString() => 'PharmacyModel(id: $id, name: $name)';
}
