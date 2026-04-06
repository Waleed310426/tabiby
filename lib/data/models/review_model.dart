// ============================================================
// ملف: review_model.dart
// الوصف: نموذج بيانات التقييم والمراجعة في تطبيق طبيبي
// يُمثّل تقييم مريض لطبيب أو منشأة صحية بعد الزيارة
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── نوع الكيان الذي تمت مراجعته ────────────────────────────
enum ReviewTargetType {
  doctor,   // طبيب
  facility, // منشأة صحية (عيادة أو مستشفى)
  pharmacy, // صيدلية
  lab,      // مختبر
}

// ─── النموذج الرئيسي للتقييم ─────────────────────────────────
class ReviewModel {
  final String id;                    // معرّف التقييم الفريد
  final String patientId;             // معرّف المريض صاحب التقييم
  final String targetId;              // معرّف الطبيب / المنشأة الذي تم تقييمه
  final ReviewTargetType targetType;  // نوع الكيان الذي تم تقييمه
  final double rating;                // التقييم من 1 إلى 5 نجوم
  final String? comment;              // تعليق نصي تفصيلي (اختياري)
  final String? doctorReply;          // رد الطبيب أو المنشأة على التقييم
  final String? appointmentId;        // معرّف الموعد المرتبط بالتقييم
  final DateTime createdAt;           // تاريخ نشر التقييم
  final DateTime updatedAt;           // تاريخ آخر تحديث

  const ReviewModel({
    required this.id,
    required this.patientId,
    required this.targetId,
    required this.targetType,
    required this.rating,
    this.comment,
    this.doctorReply,
    this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'target_id': targetId,
      'target_type': targetType.name,
      'rating': rating,
      'comment': comment,
      'doctor_reply': doctorReply,
      'appointment_id': appointmentId,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      targetId: data['target_id'] ?? '',
      targetType: ReviewTargetType.values.firstWhere(
        (t) => t.name == data['target_type'],
        orElse: () => ReviewTargetType.doctor,
      ),
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'],
      doctorReply: data['doctor_reply'],
      appointmentId: data['appointment_id'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── إضافة رد الطبيب على التقييم ────────────────────────
  ReviewModel withDoctorReply(String reply) {
    return ReviewModel(
      id: id,
      patientId: patientId,
      targetId: targetId,
      targetType: targetType,
      rating: rating,
      comment: comment,
      doctorReply: reply,
      appointmentId: appointmentId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'ReviewModel(id: $id, rating: $rating, target: $targetId)';
}
