// ============================================================
// ملف: notification_model.dart
// الوصف: نموذج بيانات الإشعار في تطبيق طبيبي
// يُمثّل كل إشعار يصل للمستخدم سواء كان تذكيراً أو رسالة أو تنبيهاً
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── أنواع الإشعارات في النظام ───────────────────────────────
enum NotificationType {
  appointmentReminder,  // تذكير بموعد قادم
  appointmentConfirmed, // تأكيد حجز موعد
  appointmentCancelled, // إلغاء موعد
  labResult,            // نتيجة تحليل جاهزة
  doctorMessage,        // رسالة من الطبيب
  prescription,         // وصفة طبية جديدة
  pharmacyUpdate,       // تحديث من الصيدلية (مثل: الدواء جاهز)
  emergencyAlert,       // تنبيه طوارئ
  promotion,            // عرض أو خصم خاص
  systemUpdate,         // تحديث في النظام
}

// ─── النموذج الرئيسي للإشعار ────────────────────────────────
class NotificationModel {
  final String id;                  // معرّف الإشعار الفريد
  final String userId;              // معرّف المستخدم المُرسل إليه الإشعار
  final NotificationType type;      // نوع الإشعار
  final String title;               // عنوان الإشعار
  final String message;             // نص الإشعار التفصيلي
  final bool isRead;                // هل قرأه المستخدم؟
  final String? referenceId;        // معرّف الكيان المرتبط (موعد، استشارة، إلخ)
  final DateTime createdAt;         // تاريخ ووقت الإشعار

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    this.referenceId,
    required this.createdAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'message': message,
      'is_read': isRead,
      'reference_id': referenceId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      type: NotificationType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => NotificationType.systemUpdate,
      ),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      isRead: data['is_read'] ?? false,
      referenceId: data['reference_id'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  // ─── تحديث حالة القراءة (immutable) ─────────────────────
  NotificationModel markAsRead() {
    return NotificationModel(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      isRead: true, // تحديد كمقروء
      referenceId: referenceId,
      createdAt: createdAt,
    );
  }

  @override
  String toString() =>
      'NotificationModel(id: $id, type: ${type.name}, read: $isRead)';
}
