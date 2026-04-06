// ============================================================
// ملف: emergency_model.dart
// الوصف: نموذج بيانات بلاغ الطوارئ في تطبيق طبيبي
// يُمثّل طلب المساعدة الطارئة الذي يُرسله المريض
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── حالة بلاغ الطوارئ ──────────────────────────────────────
enum EmergencyStatus {
  pending,          // بانتظار الاستجابة
  assigned,         // تم تعيين سيارة إسعاف
  enRoute,          // سيارة الإسعاف في الطريق
  arrived,          // وصلت سيارة الإسعاف
  transferred,      // تم نقل المريض للمستشفى
  closed,           // تم إغلاق البلاغ
}

// ─── درجة خطورة الحالة ──────────────────────────────────────
enum EmergencySeverity {
  low,      // خفيفة
  moderate, // متوسطة
  high,     // عالية
  critical, // حرجة وتستدعي تدخلاً فورياً
}

// ─── النموذج الرئيسي لبلاغ الطوارئ ──────────────────────────
class EmergencyModel {
  final String id;                    // معرّف البلاغ الفريد
  final String patientId;             // معرّف المريض مُرسل البلاغ
  final String patientName;           // اسم المريض (لسرعة الوصول)
  final String patientPhone;          // رقم هاتف المريض
  final String? patientBloodType;     // فصيلة دم المريض (مهمة في الطوارئ)
  final List<String> chronicDiseases; // الأمراض المزمنة للمريض
  final double latitude;              // خط العرض (موقع الطوارئ)
  final double longitude;             // خط الطول (موقع الطوارئ)
  final String? locationDescription;  // وصف الموقع بالكلمات (إن لم يكن GPS دقيقاً)
  final String? notes;                // تفاصيل الحالة من المريض
  final EmergencySeverity severity;   // درجة خطورة الحالة
  final EmergencyStatus status;       // حالة البلاغ الحالية
  final String? assignedAmbulanceId;  // معرّف سيارة الإسعاف المعيّنة
  final String? handledBy;            // معرّف موظف الطوارئ المسؤول
  final DateTime createdAt;           // وقت إرسال البلاغ
  final DateTime updatedAt;           // وقت آخر تحديث

  const EmergencyModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    this.patientBloodType,
    this.chronicDiseases = const [],
    required this.latitude,
    required this.longitude,
    this.locationDescription,
    this.notes,
    this.severity = EmergencySeverity.high,
    this.status = EmergencyStatus.pending,
    this.assignedAmbulanceId,
    this.handledBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_phone': patientPhone,
      'patient_blood_type': patientBloodType,
      'chronic_diseases': chronicDiseases,
      'latitude': latitude,
      'longitude': longitude,
      'location_description': locationDescription,
      'notes': notes,
      'severity': severity.name,
      'status': status.name,
      'assigned_ambulance_id': assignedAmbulanceId,
      'handled_by': handledBy,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory EmergencyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmergencyModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      patientName: data['patient_name'] ?? '',
      patientPhone: data['patient_phone'] ?? '',
      patientBloodType: data['patient_blood_type'],
      chronicDiseases: List<String>.from(data['chronic_diseases'] ?? []),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      locationDescription: data['location_description'],
      notes: data['notes'],
      severity: EmergencySeverity.values.firstWhere(
        (s) => s.name == data['severity'],
        orElse: () => EmergencySeverity.high,
      ),
      status: EmergencyStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => EmergencyStatus.pending,
      ),
      assignedAmbulanceId: data['assigned_ambulance_id'],
      handledBy: data['handled_by'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── تحديث حالة البلاغ ───────────────────────────────────
  EmergencyModel copyWith({
    EmergencyStatus? status,
    String? assignedAmbulanceId,
    String? handledBy,
    DateTime? updatedAt,
  }) {
    return EmergencyModel(
      id: id,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      patientBloodType: patientBloodType,
      chronicDiseases: chronicDiseases,
      latitude: latitude,
      longitude: longitude,
      locationDescription: locationDescription,
      notes: notes,
      severity: severity,
      status: status ?? this.status,
      assignedAmbulanceId: assignedAmbulanceId ?? this.assignedAmbulanceId,
      handledBy: handledBy ?? this.handledBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'EmergencyModel(id: $id, patient: $patientName, status: ${status.name})';
}
