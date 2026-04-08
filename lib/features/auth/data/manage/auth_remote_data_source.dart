// ============================================================
// ملف: features/auth/data/manage/auth_remote_data_source.dart
// الوصف: مصدر البيانات البعيد لعمليات المصادقة
// يتواصل مباشرة مع الـ API لتسجيل الدخول والتسجيل
// ============================================================

import '../../../../core/network/api_client.dart';
import '../../../../data/models/user_model.dart';

/// مصدر البيانات البعيد الخاص بعمليات المصادقة
/// يستخدم [ApiClient] للتواصل مع خادم الـ API
class AuthRemoteDataSource {
  // ─── حقن التبعية (Dependency Injection) ─────────────────────
  final ApiClient _apiClient;

  AuthRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  // ─── تسجيل الدخول ───────────────────────────────────────────

  /// تسجيل دخول المستخدم بالهاتف وكلمة المرور
  /// يُرجع [UserModel] عند النجاح أو يرمي [Exception]
  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      {
        'phone_number': phoneNumber,
        'password': password,
      },
    );

    // ─── تخزين رمز المصادقة في الـ ApiClient ───────────────
    if (response['token'] != null) {
      _apiClient.setAuthToken(response['token'] as String);
    }

    // ─── تحويل الاستجابة إلى نموذج المستخدم ────────────────
    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }

  // ─── إنشاء حساب جديد ────────────────────────────────────────

  /// تسجيل مستخدم جديد في التطبيق
  /// يُرجع [UserModel] للمستخدم المُنشأ حديثاً
  Future<UserModel> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role, // Patient أو Doctor أو Admin
  }) async {
    final response = await _apiClient.post(
      '/auth/signup',
      {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
        'role': role,
      },
    );

    // ─── تخزين رمز المصادقة في الـ ApiClient ───────────────
    if (response['token'] != null) {
      _apiClient.setAuthToken(response['token'] as String);
    }

    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }

  // ─── التحقق من رمز OTP ──────────────────────────────────────

  /// التحقق من رمز التحقق المُرسَل عبر الرسائل القصيرة
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      '/auth/verify-otp',
      {
        'phone_number': phoneNumber,
        'otp': otp,
      },
    );

    return response['verified'] as bool? ?? false;
  }

  // ─── نسيان كلمة المرور ──────────────────────────────────────

  /// إرسال رمز إعادة تعيين كلمة المرور
  Future<void> forgotPassword({required String phoneNumber}) async {
    await _apiClient.post(
      '/auth/forgot-password',
      {'phone_number': phoneNumber},
    );
  }

  // ─── تسجيل الخروج ───────────────────────────────────────────

  /// تسجيل خروج المستخدم ومسح رمز المصادقة
  Future<void> logout() async {
    _apiClient.clearAuthToken();
  }
}
