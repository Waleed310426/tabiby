// ============================================================
// ملف: appointment_model.dart
// الوصف: نموذج بيانات الحجز (الموعد) في تطبيق طبيبي
// يُمثّل كل موعد طبي يحجزه المريض مع الطبيب
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── نوع الزيارة ────────────────────────────────────────────
enum AppointmentType {
  clinicVisit,      // زيارة حضورية للعيادة
  teleconsultation, // استشارة عن بعد (مرئية أو صوتية)
}

// ─── حالة الموعد خلال دورة حياته ────────────────────────────
enum AppointmentStatus {
  pending,     // معلق — بانتظار تأكيد الطبيب
  confirmed,   // مؤكد
  cancelled,   // ملغى
  completed,   // مكتمل
  rescheduled, // تم إعادة الجدولة
  noShow,      // المريض لم يحضر
}

// ─── حالة الدفع ─────────────────────────────────────────────
enum PaymentStatus {
  pending,  // بانتظار الدفع
  paid,     // تم الدفع
  refunded, // تم الاسترداد
}

// ─── طريقة الدفع ────────────────────────────────────────────
enum PaymentMethod {
  cash,         // نقدي عند الوصول
  kareemi,      // عبر كريمي
  mFloos,       // عبر إم فلوس
  bankTransfer, // تحويل بنكي
}

// ─── النموذج الرئيسي للحجز ──────────────────────────────────
class AppointmentModel {
  final String id;                       // معرّف الموعد الفريد
  final String patientId;                // معرّف المريض
  final String doctorId;                 // معرّف الطبيب
  final String? facilityId;              // معرّف المنشأة (اختياري)
  final DateTime appointmentDate;        // تاريخ الموعد
  final String appointmentTime;          // وقت الموعد (مثال: "10:30")
  final AppointmentType type;            // نوع الزيارة
  final AppointmentStatus status;        // حالة الموعد الحالية
  final String? patientNotes;            // ملاحظات المريض قبل الموعد
  final String? doctorNotes;             // ملاحظات الطبيب بعد الفحص
  final PaymentStatus paymentStatus;     // حالة الدفع
  final PaymentMethod paymentMethod;     // طريقة الدفع المختارة
  final DateTime createdAt;              // تاريخ إنشاء الحجز
  final DateTime updatedAt;              // تاريخ آخر تحديث

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.facilityId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.type,
    this.status = AppointmentStatus.pending,
    this.patientNotes,
    this.doctorNotes,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod = PaymentMethod.cash,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'facility_id': facilityId,
      'appointment_date': Timestamp.fromDate(appointmentDate),
      'appointment_time': appointmentTime,
      'type': type.name,
      'status': status.name,
      'patient_notes': patientNotes,
      'doctor_notes': doctorNotes,
      'payment_status': paymentStatus.name,
      'payment_method': paymentMethod.name,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'] ?? '',
      facilityId: data['facility_id'],
      appointmentDate: (data['appointment_date'] as Timestamp).toDate(),
      appointmentTime: data['appointment_time'] ?? '',
      type: AppointmentType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => AppointmentType.clinicVisit,
      ),
      status: AppointmentStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      patientNotes: data['patient_notes'],
      doctorNotes: data['doctor_notes'],
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.name == data['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (m) => m.name == data['payment_method'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── إنشاء النموذج من JSON ───────────────────────────────
  factory AppointmentModel.fromJson(Map<String, dynamic> data) {
    return AppointmentModel(
      id: data['id'] ?? '',
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'] ?? '',
      facilityId: data['facility_id'],
      appointmentDate: data['appointment_date'] != null
          ? DateTime.tryParse(data['appointment_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      appointmentTime: data['appointment_time'] ?? '',
      type: AppointmentType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => AppointmentType.clinicVisit,
      ),
      status: AppointmentStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      patientNotes: data['patient_notes'],
      doctorNotes: data['doctor_notes'],
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.name == data['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (m) => m.name == data['payment_method'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: data['updated_at'] != null 
          ? DateTime.tryParse(data['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // ─── نسخ النموذج مع تعديل حقول معينة ────────────────────
  AppointmentModel copyWith({
    AppointmentStatus? status,
    String? doctorNotes,
    PaymentStatus? paymentStatus,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      facilityId: facilityId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      type: type,
      status: status ?? this.status,
      patientNotes: patientNotes,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'AppointmentModel(id: $id, date: $appointmentDate, status: ${status.name})';
}
