// ============================================================
// ملف: payment_model.dart
// الوصف: نموذج بيانات المعاملة المالية في تطبيق طبيبي
// يُسجّل كل عملية دفع أو رد مبلغ تتم عبر التطبيق
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_model.dart'; // لاستخدام PaymentMethod

// ─── نوع المعاملة المالية ────────────────────────────────────
enum TransactionType {
  payment,  // دفع (خصم من المريض)
  refund,   // استرداد (إعادة المبلغ للمريض)
  payout,   // صرف للطبيب / الصيدلية
  topUp,    // شحن المحفظة الداخلية
}

// ─── حالة المعاملة المالية ───────────────────────────────────
enum TransactionStatus {
  pending,   // قيد المعالجة
  completed, // مكتملة بنجاح
  failed,    // فشلت
  refunded,  // تم الاسترداد
}

// ─── الكيان المرتبط بالمعاملة ────────────────────────────────
enum TransactionReference {
  appointment,   // موعد طبي
  consultation,  // استشارة عن بعد
  prescription,  // وصفة / صرف أدوية
  labTest,       // فحص مخبري
  walletTopUp,   // شحن المحفظة
}

// ─── النموذج الرئيسي للمعاملة المالية ───────────────────────
class PaymentModel {
  final String id;                         // معرّف المعاملة الفريد
  final String payerId;                    // معرّف الدافع (المريض عادةً)
  final String? receiverId;                // معرّف المُستلِم (الطبيب / الصيدلية)
  final double amount;                     // المبلغ بالعملة المحددة
  final String currency;                   // العملة (مثال: "YER"، "USD")
  final PaymentMethod method;              // طريقة الدفع
  final TransactionType type;              // نوع المعاملة
  final TransactionStatus status;          // حالة المعاملة
  final TransactionReference referenceType; // نوع الكيان المدفوع من أجله
  final String referenceId;               // معرّف الكيان (موعد، استشارة...)
  final String? transactionRef;            // رقم مرجعية الدفع من بوابة الدفع
  final String? failureReason;             // سبب الفشل إن وُجد
  final DateTime createdAt;               // تاريخ المعاملة
  final DateTime updatedAt;               // تاريخ آخر تحديث

  const PaymentModel({
    required this.id,
    required this.payerId,
    this.receiverId,
    required this.amount,
    this.currency = 'YER',
    required this.method,
    required this.type,
    this.status = TransactionStatus.pending,
    required this.referenceType,
    required this.referenceId,
    this.transactionRef,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'payer_id': payerId,
      'receiver_id': receiverId,
      'amount': amount,
      'currency': currency,
      'method': method.name,
      'type': type.name,
      'status': status.name,
      'reference_type': referenceType.name,
      'reference_id': referenceId,
      'transaction_ref': transactionRef,
      'failure_reason': failureReason,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      payerId: data['payer_id'] ?? '',
      receiverId: data['receiver_id'],
      amount: (data['amount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'YER',
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == data['method'],
        orElse: () => PaymentMethod.cash,
      ),
      type: TransactionType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => TransactionType.payment,
      ),
      status: TransactionStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => TransactionStatus.pending,
      ),
      referenceType: TransactionReference.values.firstWhere(
        (r) => r.name == data['reference_type'],
        orElse: () => TransactionReference.appointment,
      ),
      referenceId: data['reference_id'] ?? '',
      transactionRef: data['transaction_ref'],
      failureReason: data['failure_reason'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() =>
      'PaymentModel(id: $id, amount: $amount $currency, status: ${status.name})';
}
