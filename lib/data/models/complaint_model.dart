// ============================================================
// ملف: complaint_model.dart
// الوصف: نموذج بيانات الشكوى أو طلب الدعم الفني في تطبيق طبيبي
//
// يُمثّل أي شكوى أو بلاغ يرسله المستخدم لفريق الدعم،
// ويُتابعه الأدمن من لوحة الإدارة العليا حتى الحل.
//
// أصحاب المصلحة المرتبطون:
//   👤 المريض / الطبيب / الصيدلية / الطوارئ / المختبر
//       ← إرسال الشكوى
//   🛡️ الأدمن (الإدارة العليا)
//       ← مراجعة الشكاوى وتعيينها وإغلاقها
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── تصنيف نوع الشكوى أو الطلب ─────────────────────────────
enum ComplaintType {
  technicalIssue,    // مشكلة تقنية في التطبيق
  doctorBehavior,    // شكوى من سلوك طبيب
  appointmentIssue,  // مشكلة في الحجز أو الموعد
  paymentIssue,      // مشكلة في الدفع أو الاسترداد
  pharmacyIssue,     // مشكلة مع الصيدلية أو الدواء
  labIssue,          // مشكلة مع المختبر أو النتائج
  emergencyIssue,    // مشكلة في خدمة الطوارئ
  accountIssue,      // مشكلة في الحساب أو التحقق
  suggestion,        // اقتراح لتحسين التطبيق
  other,             // أخرى
}

// ─── حالة الشكوى ────────────────────────────────────────────
enum ComplaintStatus {
  open,          // جديدة ولم يُتابعها أحد بعد
  inProgress,    // قيد المعالجة (تم تعيينها لموظف دعم)
  resolved,      // تم الحل
  closed,        // مغلقة (حُلّت أو رُفضت)
  rejected,      // مرفوضة (غير مشروعة أو خارج نطاق الدعم)
}

// ─── درجة أولوية الشكوى ─────────────────────────────────────
enum ComplaintPriority {
  low,      // منخفضة الأولوية
  medium,   // متوسطة
  high,     // عالية (تحتاج استجابة سريعة)
  urgent,   // عاجلة جداً (مثلاً: مشكلة دفع كبيرة)
}

// ─── النموذج الرئيسي للشكوى ──────────────────────────────────
class ComplaintModel {
  final String id;                    // معرّف الشكوى الفريد
  final String userId;               // معرّف المستخدم مُرسل الشكوى
  final String userName;             // اسم المستخدم (لسرعة القراءة)
  final String userRole;             // دور المستخدم (مريض، طبيب، إلخ)
  final ComplaintType type;          // تصنيف الشكوى
  final String title;                // عنوان الشكوى
  final String description;          // وصف تفصيلي للمشكلة
  final List<String> attachmentsUrls; // صور أو ملفات مرفقة كدليل
  final ComplaintStatus status;      // الحالة الحالية للشكوى
  final ComplaintPriority priority;  // درجة الأولوية
  final String? relatedEntityId;     // معرّف الكيان المرتبط بالشكوى
                                     // (مثلاً: معرّف الموعد أو الطبيب)
  final String? relatedEntityType;   // نوع الكيان (مثلاً: \"appointment\"، \"doctor\")
  final String? assignedTo;          // معرّف موظف الدعم المسؤول
  final String? adminNotes;          // ملاحظات الأدمن (داخلية)
  final String? resolutionNote;      // ملاحظة الحل الموجهة للمستخدم
  final DateTime createdAt;          // تاريخ إرسال الشكوى
  final DateTime updatedAt;          // تاريخ آخر تحديث

  const ComplaintModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.type,
    required this.title,
    required this.description,
    this.attachmentsUrls = const [],
    this.status = ComplaintStatus.open,
    this.priority = ComplaintPriority.medium,
    this.relatedEntityId,
    this.relatedEntityType,
    this.assignedTo,
    this.adminNotes,
    this.resolutionNote,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_role': userRole,
      'type': type.name,
      'title': title,
      'description': description,
      'attachments_urls': attachmentsUrls,
      'status': status.name,
      'priority': priority.name,
      'related_entity_id': relatedEntityId,
      'related_entity_type': relatedEntityType,
      'assigned_to': assignedTo,
      'admin_notes': adminNotes,
      'resolution_note': resolutionNote,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory ComplaintModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ComplaintModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
      userRole: data['user_role'] ?? '',
      type: ComplaintType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => ComplaintType.other,
      ),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      attachmentsUrls: List<String>.from(data['attachments_urls'] ?? []),
      status: ComplaintStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => ComplaintStatus.open,
      ),
      priority: ComplaintPriority.values.firstWhere(
        (p) => p.name == data['priority'],
        orElse: () => ComplaintPriority.medium,
      ),
      relatedEntityId: data['related_entity_id'],
      relatedEntityType: data['related_entity_type'],
      assignedTo: data['assigned_to'],
      adminNotes: data['admin_notes'],
      resolutionNote: data['resolution_note'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  // ─── نسخ النموذج عند تحديث الحالة ───────────────────────
  ComplaintModel copyWith({
    ComplaintStatus? status,
    ComplaintPriority? priority,
    String? assignedTo,
    String? adminNotes,
    String? resolutionNote,
    DateTime? updatedAt,
  }) {
    return ComplaintModel(
      id: id,
      userId: userId,
      userName: userName,
      userRole: userRole,
      type: type,
      title: title,
      description: description,
      attachmentsUrls: attachmentsUrls,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
      assignedTo: assignedTo ?? this.assignedTo,
      adminNotes: adminNotes ?? this.adminNotes,
      resolutionNote: resolutionNote ?? this.resolutionNote,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'ComplaintModel(id: $id, type: ${type.name}, status: ${status.name})';
}
