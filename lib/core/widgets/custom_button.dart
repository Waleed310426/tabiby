// ============================================================
// ملف: core/widgets/custom_button.dart
// الوصف: زر مخصص قابل لإعادة الاستخدام في جميع أنحاء التطبيق
// يدعم الزر الحالات: عادي، تحميل، معطل
// ============================================================

import 'package:flutter/material.dart';

/// زر مخصص موحّد يُستخدم في جميع شاشات التطبيق
/// يدعم حالة التحميل وحالة التعطيل
class CustomButton extends StatelessWidget {
  // ─── خصائص الزر ─────────────────────────────────────────────

  /// النص الذي يظهر داخل الزر
  final String text;

  /// الدالة التي تُنفَّذ عند الضغط على الزر
  final VoidCallback? onPressed;

  /// هل الزر في حالة تحميل؟ (يُظهر دوار بدل النص)
  final bool isLoading;

  /// هل الزر معطل؟
  final bool isDisabled;

  /// لون خلفية الزر (اختياري - يستخدم لون الثيم افتراضياً)
  final Color? backgroundColor;

  /// لون النص (اختياري)
  final Color? textColor;

  /// عرض الزر (اختياري - يأخذ العرض الكامل افتراضياً)
  final double? width;

  /// ارتفاع الزر
  final double height;

  /// حجم الخط
  final double fontSize;

  /// نصف قطر حواف الزر
  final double borderRadius;

  // ─── المُنشئ ─────────────────────────────────────────────────
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.fontSize = 16,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    // ─── تحديد لون الخلفية ──────────────────────────────────
    final bgColor = isDisabled
        ? Colors.grey.shade400
        : (backgroundColor ?? Theme.of(context).primaryColor);

    // ─── تحديد الدالة (null إذا كان معطلاً أو يتحمل) ───────
    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          // ─── إزالة ظل الزر الافتراضي ────────────────────
          elevation: isDisabled ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  /// بناء محتوى الزر (نص أو دوار تحميل)
  Widget _buildButtonContent(BuildContext context) {
    // ─── حالة التحميل: إظهار دوار ───────────────────────────
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5,
        ),
      );
    }

    // ─── الحالة العادية: إظهار النص ─────────────────────────
    return Text(
      text,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
