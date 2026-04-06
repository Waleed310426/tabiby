// ============================================================
// ملف: chat_message_model.dart
// الوصف: نموذج بيانات رسالة المحادثة في تطبيق طبيبي
// يُمثّل كل رسالة يتبادلها المريض والطبيب داخل الاستشارة النصية
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── نوع الرسالة ────────────────────────────────────────────
enum MessageType {
  text,   // رسالة نصية عادية
  image,  // صورة (مثل صورة طفح جلدي أو نتيجة تحليل)
  file,   // ملف PDF أو وثيقة طبية
  audio,  // رسالة صوتية
  system, // رسالة من النظام (مثل: بدأت الاستشارة / انتهت الاستشارة)
}

// ─── حالة تسليم الرسالة ─────────────────────────────────────
enum MessageStatus {
  sending,   // جاري الإرسال...
  sent,      // تم الإرسال
  delivered, // تم التسليم للجهاز
  read,      // تمت القراءة
  failed,    // فشل الإرسال
}

// ─── النموذج الرئيسي لرسالة المحادثة ────────────────────────
class ChatMessageModel {
  final String id;                  // معرّف الرسالة الفريد
  final String consultationId;      // معرّف الاستشارة التي تنتمي إليها الرسالة
  final String senderId;            // معرّف المُرسِل (مريض أو طبيب)
  final String receiverId;          // معرّف المُستلِم
  final MessageType type;           // نوع الرسالة
  final String content;             // محتوى النص أو رابط الملف/الصورة
  final String? thumbnailUrl;       // صورة مصغرة للملفات والصور (اختياري)
  final MessageStatus status;       // حالة تسليم الرسالة
  final DateTime createdAt;         // وقت إرسال الرسالة
  final bool isDeleted;             // هل تم حذف الرسالة؟

  const ChatMessageModel({
    required this.id,
    required this.consultationId,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.content,
    this.thumbnailUrl,
    this.status = MessageStatus.sending,
    required this.createdAt,
    this.isDeleted = false,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'consultation_id': consultationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'type': type.name,
      'content': content,
      'thumbnail_url': thumbnailUrl,
      'status': status.name,
      'created_at': Timestamp.fromDate(createdAt),
      'is_deleted': isDeleted,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      consultationId: data['consultation_id'] ?? '',
      senderId: data['sender_id'] ?? '',
      receiverId: data['receiver_id'] ?? '',
      type: MessageType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => MessageType.text,
      ),
      content: data['content'] ?? '',
      thumbnailUrl: data['thumbnail_url'],
      status: MessageStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => MessageStatus.sent,
      ),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      isDeleted: data['is_deleted'] ?? false,
    );
  }

  // ─── تحديث حالة الرسالة (مثل: تحديث إلى "مقروءة") ───────
  ChatMessageModel copyWith({MessageStatus? status, bool? isDeleted}) {
    return ChatMessageModel(
      id: id,
      consultationId: consultationId,
      senderId: senderId,
      receiverId: receiverId,
      type: type,
      content: content,
      thumbnailUrl: thumbnailUrl,
      status: status ?? this.status,
      createdAt: createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  // ─── هل أرسلها المستخدم الحالي؟ (مساعدة للواجهة) ─────────
  bool isSentByMe(String currentUserId) => senderId == currentUserId;

  @override
  String toString() =>
      'ChatMessageModel(id: $id, type: ${type.name}, status: ${status.name})';
}
