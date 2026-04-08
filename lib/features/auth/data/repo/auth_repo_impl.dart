// ============================================================
// ملف: features/auth/data/repo/auth_repo_impl.dart
// الوصف: تنفيذ مستودع المصادقة
// يعمل كوسيط بين طبقة العرض ومصدر البيانات البعيد
// ============================================================

import '../../../../data/models/user_model.dart';
import '../manage/auth_remote_data_source.dart';

/// مستودع المصادقة - يُنسّق بين مصادر البيانات وطبقة العرض
/// يتعامل مع الأخطاء ويوفر واجهة نظيفة لـ [AuthProvider]
class AuthRepoImpl {
  // ─── حقن التبعية ────────────────────────────────────────────
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  // ─── تسجيل الدخول ───────────────────────────────────────────

  /// تسجيل دخول المستخدم
  /// يُرجع [UserModel] عند النجاح أو يرمي [Exception]
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login(
        phoneNumber: phoneNumber,
        password: password,
      );
    } catch (e) {
      // ─── إعادة رمي الخطأ مع رسالة واضحة ────────────────
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }

  // ─── إنشاء حساب جديد ────────────────────────────────────────

  /// تسجيل مستخدم جديد
  Future<UserModel> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      return await _remoteDataSource.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
        role: role,
      );
    } catch (e) {
      throw Exception('فشل إنشاء الحساب: $e');
    }
  }

  // ─── التحقق من OTP ───────────────────────────────────────────

  /// التحقق من رمز OTP
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      return await _remoteDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
    } catch (e) {
      throw Exception('فشل التحقق من الرمز: $e');
    }
  }

  // ─── نسيان كلمة المرور ──────────────────────────────────────

  Future<void> forgotPassword({required String phoneNumber}) async {
    try {
      await _remoteDataSource.forgotPassword(phoneNumber: phoneNumber);
    } catch (e) {
      throw Exception('فشل إرسال رمز استعادة كلمة المرور: $e');
    }
  }

  // ─── تسجيل الخروج ───────────────────────────────────────────

  Future<void> logout() async {
    await _remoteDataSource.logout();
  }
}
