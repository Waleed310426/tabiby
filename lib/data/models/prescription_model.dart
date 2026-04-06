// ============================================================
// ملف: prescription_model.dart
// الوصف: نموذج بيانات الوصفة الطبية الرقمية في تطبيق طبيبي
// يُمثّل الوصفة التي يُصدرها الطبيب وترسل للمريض والصيدلية
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── حالة الوصفة الطبية ─────────────────────────────────────
enum PrescriptionStatus {
  active,    // نشطة وقابلة للصرف
  dispensed, // تم صرفها من الصيدلية
  refilled,  // تم إعادة صرفها
  cancelled, // ملغاة
  expired,   // منتهية الصلاحية
}

// ─── نموذج دواء واحد داخل الوصفة ────────────────────────────
class MedicationItem {
  final String name;         // اسم الدواء
  final String dosage;       // الجرعة (مثال: "500mg")
  final String frequency;    // التكرار (مثال: "مرتين يومياً")
  final String duration;     // مدة العلاج (مثال: "7 أيام")
  final String? notes;       // ملاحظات إضافية للدواء

  const MedicationItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.notes,
  });

  // تحويل إلى Map لحفظه في Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'notes': notes,
    };
  }

  // إنشاء من Map مسترجع من Firebase
  factory MedicationItem.fromMap(Map<String, dynamic> map) {
    return MedicationItem(
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      duration: map['duration'] ?? '',
      notes: map['notes'],
    );
  }
}

// ─── النموذج الرئيسي للوصفة الطبية ──────────────────────────
class PrescriptionModel {
  final String id;                       // معرّف الوصفة الفريد
  final String patientId;                // معرّف المريض
  final String doctorId;                 // معرّف الطبيب مُصدر الوصفة
  final String? pharmacyId;              // معرّف الصيدلية (اختياري)
  final DateTime issueDate;              // تاريخ إصدار الوصفة
  final List<MedicationItem> medications; // قائمة الأدوية في الوصفة
  final String? instructions;            // تعليمات عامة للمريض
  final PrescriptionStatus status;       // حالة الوصفة الحالية
  final DateTime? dispenseDate;          // تاريخ الصرف فعلياً
  final DateTime createdAt;             // تاريخ الإنشاء
  final DateTime updatedAt;             // تاريخ آخر تحديث

  const PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.pharmacyId,
    required this.issueDate,
    required this.medications,
    this.instructions,
    this.status = PrescriptionStatus.active,
    this.dispenseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'pharmacy_id': pharmacyId,
      'issue_date': Timestamp.fromDate(issueDate),
      'medications': medications.map((m) => m.toMap()).toList(),
      'instructions': instructions,
      'status': status.name,
      'dispense_date':
          dispenseDate != null ? Timestamp.fromDate(dispenseDate!) : null,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory PrescriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrescriptionModel(
      id: doc.id,
      patientId: data['patient_id'] ?? '',
      doctorId: data['doctor_id'] ?? '',
      pharmacyId: data['pharmacy_id'],
      issueDate: (data['issue_date'] as Timestamp).toDate(),
      medications: (data['medications'] as List<dynamic>? ?? [])
          .map((m) => MedicationItem.fromMap(m))
          .toList(),
      instructions: data['instructions'],
      status: PrescriptionStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => PrescriptionStatus.active,
      ),
      dispenseDate: data['dispense_date'] != null
          ? (data['dispense_date'] as Timestamp).toDate()
          : null,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── نسخ النموذج مع تعديل الحالة ────────────────────────
  PrescriptionModel copyWith({
    String? pharmacyId,
    PrescriptionStatus? status,
    DateTime? dispenseDate,
    DateTime? updatedAt,
  }) {
    return PrescriptionModel(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      issueDate: issueDate,
      medications: medications,
      instructions: instructions,
      status: status ?? this.status,
      dispenseDate: dispenseDate ?? this.dispenseDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'PrescriptionModel(id: $id, status: ${status.name}, meds: ${medications.length})';
}
