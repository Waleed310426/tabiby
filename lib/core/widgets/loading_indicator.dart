// ============================================================
// ملف: core/widgets/loading_indicator.dart
// الوصف: مؤشر التحميل الموحّد المستخدم في جميع شاشات التطبيق
// يعرض دوار مركزي مع رسالة اختيارية
// ============================================================

import 'package:flutter/material.dart';

/// مؤشر تحميل موحّد يُعرض أثناء انتظار البيانات
class LoadingIndicator extends StatelessWidget {
  // ─── خصائص المؤشر ────────────────────────────────────────────

  /// رسالة تظهر أسفل الدوار (اختياري)
  final String? message;

  /// لون الدوار (اختياري - يستخدم لون الثيم افتراضياً)
  final Color? color;

  /// هل يملأ الشاشة بالكامل أم لا؟
  final bool fullScreen;

  // ─── المُنشئ ─────────────────────────────────────────────────
  const LoadingIndicator({
    super.key,
    this.message,
    this.color,
    this.fullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).primaryColor;

    // ─── محتوى مؤشر التحميل ─────────────────────────────────
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── الدوار الرئيسي ──────────────────────────────────
        CircularProgressIndicator(
          color: indicatorColor,
          strokeWidth: 3,
        ),

        // ─── رسالة التحميل (إن وُجدت) ───────────────────────
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );

    // ─── وضع ملء الشاشة ──────────────────────────────────────
    if (fullScreen) {
      return Center(child: content);
    }

    // ─── وضع مدمج داخل الصفحة ────────────────────────────────
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: content),
    );
  }
}

/// ودجت تُعرض فوق محتوى الصفحة عند التحميل (Overlay)
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ─── المحتوى الأصلي ──────────────────────────────────
        child,
        // ─── طبقة التحميل (تظهر فقط عند isLoading = true) ───
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: LoadingIndicator(
              message: loadingMessage ?? 'جارٍ التحميل...',
            ),
          ),
      ],
    );
  }
}
