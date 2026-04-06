// ============================================================
// ملف: lab_test_request_model.dart
// الوصف: نموذج بيانات طلب الفحص المخبري أو الأشعة
// يُمثّل طلب الطبيب بإجراء تحليل أو فحص أشعة لمريض معين
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── حالة طلب الفحص ─────────────────────────────────────────
enum LabTestStatus {
  pending,        // بانتظار قبول المختبر
  accepted,       // تم القبول وبانتظار المريض
  sampleCollected, // تم أخذ العينة / إجراء الأشعة
  processing,     // جاري معالجة العينة في المختبر
  resultsReady,   // النتائج جاهزة وتم رفعها
  delivered,      // وصلت النتائج للطبيب والمريض
  cancelled,      // ملغى
}

// ─── النموذج الرئيسي لطلب الفحص ─────────────────────────────
class LabTestRequestModel {
  final String id;                    // معرّف الطلب الفريد
  final String patientId;             // معرّف المريض
  final String doctorId;              // معرّف الطبيب الطالب للفحص
  final String labId;                 // معرّف المختبر / مركز الأشعة
  final String? appointmentId;        // معرّف الموعد المرتبط (اختياري)
  final List<String> testsRequested;  // قائمة أسماء الفحوصات المطلوبة
  final String? clinicalNotes;        // ملاحظات سريرية من الطبيب للمختبر
  final LabTestStatus status;         // حالة الطلب الحالية
  final List<String> resultsUrls;     // روابط ملفات النتائج بعد رفعها
  final String? resultsNotes;         // ملاحظات المختبر على النتائج
  final bool homeVisitRequested;      // هل طُلبت زيارة منزلية لأخذ العينة؟
  final DateTime? scheduledDate;      // التاريخ المحدد للفحص (اختياري)
  final double totalCost;             // التكلفة الإجمالية للفحوصات
  final DateTime createdAt;           // تاريخ إنشاء الطلب
  final DateTime updatedAt;           // تاريخ آخر تحديث

  const LabTestRequestModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.labId,
    this.appointmentId,
    required this.testsRequested,
    this.clinicalNotes,
    this.status = LabTestStatus.pending,
    this.resultsUrls = const [],
    this.resultsNotes,
    this.homeVisitRequested = false,
    this.scheduledDate,
    this.totalCost = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'lab_id': labId,
      'appointment_id': appointmentId,
      'tests_requested': testsRequested,
      'clinical_notes': clinicalNotes,
      'status': status.name,
      'results_urls': resultsUrls,
      'results_notes': resultsNotes,
      'home_visit_requested': homeVisitRequested,
      'scheduled_date': scheduledDate != null
          ? Timestamp.fromDate(scheduledDate!)
          : null,
      'total_cost': totalCost,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory LabTestRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LabTestRequestModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'] ?? '',
      labId: data['lab_id'] ?? '',
      appointmentId: data['appointment_id'],
      testsRequested: List<String>.from(data['tests_requested'] ?? []),
      clinicalNotes: data['clinical_notes'],
      status: LabTestStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => LabTestStatus.pending,
      ),
      resultsUrls: List<String>.from(data['results_urls'] ?? []),
      resultsNotes: data['results_notes'],
      homeVisitRequested: data['home_visit_requested'] ?? false,
      scheduledDate: data['scheduled_date'] != null
          ? (data['scheduled_date'] as Timestamp).toDate()
          : null,
      totalCost: (data['total_cost'] ?? 0.0).toDouble(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── رفع نتائج الفحص وتحديث الحالة ──────────────────────
  LabTestRequestModel withResults({
    required List<String> urls,
    String? notes,
  }) {
    return LabTestRequestModel(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      labId: labId,
      appointmentId: appointmentId,
      testsRequested: testsRequested,
      clinicalNotes: clinicalNotes,
      status: LabTestStatus.resultsReady,
      resultsUrls: urls,
      resultsNotes: notes,
      homeVisitRequested: homeVisitRequested,
      scheduledDate: scheduledDate,
      totalCost: totalCost,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'LabTestRequestModel(id: $id, tests: ${testsRequested.length}, status: ${status.name})';
}
