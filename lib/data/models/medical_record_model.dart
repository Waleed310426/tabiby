// ============================================================
// ملف: medical_record_model.dart
// الوصف: نموذج بيانات السجل الطبي في تطبيق طبيبي
// يُمثّل أي وثيقة أو سجل طبي خاص بمريض معين
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── أنواع السجلات الطبية المدعومة ──────────────────────────
enum RecordType {
  prescription,      // وصفة طبية
  labResult,         // نتيجة تحليل مخبري
  radiologyReport,   // تقرير أشعة
  medicalReport,     // تقرير طبي عام
  vaccination,       // سجل تطعيمات
  manualEntry,       // إدخال يدوي من المريض (مثل قياسات السكر)
}

// ─── النموذج الرئيسي للسجل الطبي ────────────────────────────
class MedicalRecordModel {
  final String id;                   // معرّف السجل الفريد
  final String patientId;            // معرّف المريض صاحب السجل
  final String? doctorId;            // معرّف الطبيب (اختياري، قد يكون إدخالاً يدوياً)
  final RecordType recordType;       // نوع السجل الطبي
  final String title;                // عنوان السجل (مثال: "نتيجة تحليل الدم")
  final String description;          // تفاصيل ووصف السجل
  final DateTime recordDate;         // تاريخ صدور السجل
  final List<String> attachmentsUrls; // روابط الملفات المرفقة (PDF، صور)
  final DateTime createdAt;          // تاريخ الإضافة في النظام
  final DateTime updatedAt;          // تاريخ آخر تحديث
  final List<String> sharedWith;     // قائمة معرّفات من تم مشاركة السجل معهم

  const MedicalRecordModel({
    required this.id,
    required this.patientId,
    this.doctorId,
    required this.recordType,
    required this.title,
    required this.description,
    required this.recordDate,
    this.attachmentsUrls = const [],
    required this.createdAt,
    required this.updatedAt,
    this.sharedWith = const [],
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'record_type': recordType.name,
      'title': title,
      'description': description,
      'record_date': Timestamp.fromDate(recordDate),
      'attachments_urls': attachmentsUrls,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'shared_with': sharedWith,
    };
  }

  factory MedicalRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicalRecordModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'],
      recordType: RecordType.values.firstWhere(
        (r) => r.name == data['record_type'],
        orElse: () => RecordType.medicalReport,
      ),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      recordDate: (data['record_date'] as Timestamp).toDate(),
      attachmentsUrls: List<String>.from(data['attachments_urls'] ?? []),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      sharedWith: List<String>.from(data['shared_with'] ?? []),
    );
  }

  // ─── إنشاء النموذج من JSON ───────────────────────────────
  factory MedicalRecordModel.fromJson(Map<String, dynamic> data) {
    return MedicalRecordModel(
      id: data['id'] ?? '',
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'],
      recordType: RecordType.values.firstWhere(
        (r) => r.name == data['record_type'],
        orElse: () => RecordType.medicalReport,
      ),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      recordDate: data['record_date'] != null
          ? DateTime.tryParse(data['record_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      attachmentsUrls: List<String>.from(data['attachments_urls'] ?? []),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: data['updated_at'] != null 
          ? DateTime.tryParse(data['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      sharedWith: List<String>.from(data['shared_with'] ?? []),
    );
  }

  // ─── نسخ النموذج مع تعديل قائمة المشاركة ─────────────────
  MedicalRecordModel copyWith({
    String? title,
    String? description,
    List<String>? attachmentsUrls,
    List<String>? sharedWith,
    DateTime? updatedAt,
  }) {
    return MedicalRecordModel(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      recordType: recordType,
      title: title ?? this.title,
      description: description ?? this.description,
      recordDate: recordDate,
      attachmentsUrls: attachmentsUrls ?? this.attachmentsUrls,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }

  @override
  String toString() =>
      'MedicalRecordModel(id: $id, type: ${recordType.name}, title: $title)';
}
