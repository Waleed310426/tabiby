// ============================================================
// ملف: facility_model.dart
// الوصف: نموذج بيانات المنشأة الصحية (عيادة / مستشفى / مركز)
// يُمثّل أي منشأة صحية مسجلة في تطبيق طبيبي
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_model.dart'; // لاستخدام WorkingHours

// ─── نوع المنشأة الصحية ─────────────────────────────────────
enum FacilityType {
  clinic,        // عيادة خاصة
  hospital,      // مستشفى
  medicalCenter, // مركز صحي
}

// ─── حالة المنشأة ───────────────────────────────────────────
enum FacilityStatus {
  active,   // نشطة
  inactive, // غير نشطة
}

// ─── النموذج الرئيسي للمنشأة الصحية ─────────────────────────
class FacilityModel {
  final String id;                       // معرّف المنشأة الفريد
  final String name;                     // اسم المنشأة
  final FacilityType type;               // نوع المنشأة
  final String address;                  // العنوان التفصيلي
  final double? latitude;                // خط العرض الجغرافي
  final double? longitude;               // خط الطول الجغرافي
  final String phoneNumber;              // رقم الهاتف
  final String? email;                   // البريد الإلكتروني
  final String? description;             // وصف المنشأة وخدماتها
  final List<String> servicesOffered;    // قائمة الخدمات المقدمة
  final List<String> imagesUrls;         // روابط صور المنشأة
  final List<WorkingHours> workingHours; // جدول أوقات العمل
  final List<String> doctorsIds;         // معرّفات الأطباء العاملين فيها
  final bool isApprovedByAdmin;          // هل وافق عليها الأدمن؟
  final FacilityStatus status;           // حالة المنشأة

  const FacilityModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    this.latitude,
    this.longitude,
    required this.phoneNumber,
    this.email,
    this.description,
    this.servicesOffered = const [],
    this.imagesUrls = const [],
    this.workingHours = const [],
    this.doctorsIds = const [],
    this.isApprovedByAdmin = false,
    this.status = FacilityStatus.active,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'email': email,
      'description': description,
      'services_offered': servicesOffered,
      'images_urls': imagesUrls,
      'working_hours': workingHours.map((w) => w.toMap()).toList(),
      'doctors_ids': doctorsIds,
      'is_approved_by_admin': isApprovedByAdmin,
      'status': status.name,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory FacilityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FacilityModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: FacilityType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => FacilityType.clinic,
      ),
      address: data['address'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      phoneNumber: data['phone_number'] ?? '',
      email: data['email'],
      description: data['description'],
      servicesOffered: List<String>.from(data['services_offered'] ?? []),
      imagesUrls: List<String>.from(data['images_urls'] ?? []),
      workingHours: (data['working_hours'] as List<dynamic>? ?? [])
          .map((w) => WorkingHours.fromMap(w))
          .toList(),
      doctorsIds: List<String>.from(data['doctors_ids'] ?? []),
      isApprovedByAdmin: data['is_approved_by_admin'] ?? false,
      status: FacilityStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => FacilityStatus.active,
      ),
    );
  }

  @override
  String toString() => 'FacilityModel(id: $id, name: $name, type: ${type.name})';
}
