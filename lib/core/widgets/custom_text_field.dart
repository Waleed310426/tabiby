// ============================================================
// ملف: core/widgets/custom_text_field.dart
// الوصف: حقل نص مخصص موحّد يُستخدم في جميع نماذج التطبيق
// يدعم: الأيقونات، إخفاء النص (كلمة المرور)، التحقق
// ============================================================

import 'package:flutter/material.dart';

/// حقل نص مخصص موحّد لجميع شاشات التطبيق
/// يدعم أيقونة الرأس، أيقونة الذيل، وإخفاء النص
class CustomTextField extends StatefulWidget {
  // ─── خصائص الحقل ─────────────────────────────────────────────

  /// النص الإرشادي داخل الحقل
  final String hintText;

  /// التسمية التوضيحية فوق الحقل
  final String? labelText;

  /// متحكم النص (اختياري)
  final TextEditingController? controller;

  /// أيقونة في بداية الحقل
  final IconData? prefixIcon;

  /// أيقونة في نهاية الحقل (اختياري)
  final IconData? suffixIcon;

  /// هل هذا حقل كلمة مرور؟ (يُخفي النص تلقائياً)
  final bool isPassword;

  /// نوع لوحة المفاتيح
  final TextInputType keyboardType;

  /// دالة التحقق من الإدخال
  final String? Function(String?)? validator;

  /// هل الحقل معطل؟
  final bool isEnabled;

  /// دالة تُنفَّذ عند تغيير النص
  final void Function(String)? onChanged;

  /// الحد الأقصى لعدد الأسطر
  final int maxLines;

  // ─── المُنشئ ─────────────────────────────────────────────────
  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isEnabled = true,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // ─── حالة إظهار/إخفاء كلمة المرور ──────────────────────────
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      // ─── إخفاء النص إذا كان حقل كلمة مرور ─────────────────
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      enabled: widget.isEnabled,
      onChanged: widget.onChanged,
      validator: widget.validator,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      // ─── اتجاه النص من اليمين لليسار (عربي) ────────────────
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        // ─── أيقونة البداية ──────────────────────────────────
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: theme.primaryColor)
            : null,
        // ─── أيقونة النهاية ──────────────────────────────────
        suffixIcon: _buildSuffixIcon(theme),
        // ─── تنسيق الحدود ────────────────────────────────────
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        // ─── خلفية الحقل ─────────────────────────────────────
        filled: true,
        fillColor: widget.isEnabled ? Colors.grey.shade50 : Colors.grey.shade100,
        // ─── المسافات الداخلية ───────────────────────────────
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  /// بناء أيقونة النهاية (زر إظهار/إخفاء كلمة المرور أو أيقونة عادية)
  Widget? _buildSuffixIcon(ThemeData theme) {
    // ─── حقل كلمة المرور: زر إظهار/إخفاء ───────────────────
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // ─── أيقونة عادية ────────────────────────────────────────
    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, color: Colors.grey);
    }

    return null;
  }
}
