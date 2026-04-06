// ============================================================
// ملف: consultation_model.dart
// الوصف: نموذج بيانات الاستشارة الطبية في تطبيق طبيبي
// يُمثّل كل استشارة نصية أو صوتية أو مرئية بين المريض والطبيب
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_model.dart'; // لاستخدام PaymentStatus و PaymentMethod

// ─── نوع الاستشارة ───────────────────────────────────────────
enum ConsultationType {
  text,  // استشارة نصية (دردشة)
  audio, // استشارة صوتية (مكالمة)
  video, // استشارة مرئية (مكالمة فيديو)
}

// ─── حالة الاستشارة ─────────────────────────────────────────
enum ConsultationStatus {
  pending,   // بانتظار قبول الطبيب
  active,    // جارية الآن
  completed, // مكتملة
  cancelled, // ملغاة
}

// ─── النموذج الرئيسي للاستشارة ──────────────────────────────
class ConsultationModel {
  final String id;                        // معرّف الاستشارة الفريد
  final String patientId;                 // معرّف المريض
  final String doctorId;                  // معرّف الطبيب
  final DateTime startTime;               // وقت بدء الاستشارة
  final DateTime? endTime;                // وقت انتهاء الاستشارة
  final ConsultationType type;            // نوع الاستشارة
  final ConsultationStatus status;        // الحالة الحالية للاستشارة
  final String patientSymptoms;           // وصف المريض لأعراضه
  final List<String> attachmentsUrls;     // روابط الملفات المرفقة (صور، تقارير)
  final String? doctorDiagnosis;          // تشخيص الطبيب
  final String? doctorRecommendations;    // توصيات وتعليمات الطبيب
  final double price;                     // سعر الاستشارة
  final PaymentStatus paymentStatus;      // حالة الدفع
  final DateTime createdAt;              // تاريخ إنشاء طلب الاستشارة
  final DateTime updatedAt;              // تاريخ آخر تحديث

  const ConsultationModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.startTime,
    this.endTime,
    required this.type,
    this.status = ConsultationStatus.pending,
    required this.patientSymptoms,
    this.attachmentsUrls = const [],
    this.doctorDiagnosis,
    this.doctorRecommendations,
    required this.price,
    this.paymentStatus = PaymentStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'start_time': Timestamp.fromDate(startTime),
      'end_time': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'type': type.name,
      'status': status.name,
      'patient_symptoms': patientSymptoms,
      'attachments_urls': attachmentsUrls,
      'doctor_diagnosis': doctorDiagnosis,
      'doctor_recommendations': doctorRecommendations,
      'price': price,
      'payment_status': paymentStatus.name,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory ConsultationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConsultationModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'] ?? '',
      startTime: (data['start_time'] as Timestamp).toDate(),
      endTime: data['end_time'] != null
          ? (data['end_time'] as Timestamp).toDate()
          : null,
      type: ConsultationType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => ConsultationType.text,
      ),
      status: ConsultationStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => ConsultationStatus.pending,
      ),
      patientSymptoms: data['patient_symptoms'] ?? '',
      attachmentsUrls: List<String>.from(data['attachments_urls'] ?? []),
      doctorDiagnosis: data['doctor_diagnosis'],
      doctorRecommendations: data['doctor_recommendations'],
      price: (data['price'] ?? 0.0).toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.name == data['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── نسخ النموذج مع تعديل حقول معينة ────────────────────
  ConsultationModel copyWith({
    DateTime? endTime,
    ConsultationStatus? status,
    String? doctorDiagnosis,
    String? doctorRecommendations,
    PaymentStatus? paymentStatus,
    DateTime? updatedAt,
  }) {
    return ConsultationModel(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      type: type,
      status: status ?? this.status,
      patientSymptoms: patientSymptoms,
      attachmentsUrls: attachmentsUrls,
      doctorDiagnosis: doctorDiagnosis ?? this.doctorDiagnosis,
      doctorRecommendations:
          doctorRecommendations ?? this.doctorRecommendations,
      price: price,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'ConsultationModel(id: $id, type: ${type.name}, status: ${status.name})';
}
