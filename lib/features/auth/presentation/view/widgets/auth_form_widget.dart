// ============================================================
// ملف: features/auth/presentation/view/widgets/auth_form_widget.dart
// الوصف: ودجت النموذج المشترك بين صفحتَي تسجيل الدخول والتسجيل
// يحتوي على منطق التحقق من صحة المدخلات
// ============================================================

import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_text_field.dart';

/// ودجت مشترك يُستخدم في نماذج المصادقة
/// يوفر حقول الإدخال مع التحقق من صحتها
class AuthFormWidget extends StatelessWidget {
  // ─── متحكمات الحقول ─────────────────────────────────────────
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  // ─── مفتاح النموذج للتحقق ───────────────────────────────────
  final GlobalKey<FormState> formKey;

  const AuthFormWidget({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // ─── حقل رقم الهاتف ──────────────────────────────
          CustomTextField(
            hintText: 'أدخل رقم هاتفك',
            labelText: 'رقم الهاتف',
            controller: phoneController,
            prefixIcon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
          ),
          const SizedBox(height: 16),

          // ─── حقل كلمة المرور ─────────────────────────────
          CustomTextField(
            hintText: 'أدخل كلمة المرور',
            labelText: 'كلمة المرور',
            controller: passwordController,
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: _validatePassword,
          ),
        ],
      ),
    );
  }

  // ─── دوال التحقق من المدخلات ─────────────────────────────────

  /// التحقق من صحة رقم الهاتف اليمني
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    // ─── التحقق من صحة رقم الهاتف اليمني ───────────────────
    if (value.length < 9) {
      return 'رقم الهاتف يجب أن يكون 9 أرقام على الأقل';
    }
    return null; // المدخل صحيح
  }

  /// التحقق من صحة كلمة المرور
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null; // المدخل صحيح
  }
}
