// ============================================================
// ملف: features/auth/presentation/manager/auth_provider.dart
// الوصف: مزود حالة المصادقة (State Management)
// يدير حالة: تسجيل الدخول، التسجيل، تسجيل الخروج
// ============================================================

import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';
import '../../data/repo/auth_repo_impl.dart';

/// حالات المصادقة الممكنة في التطبيق
enum AuthStatus {
  /// الحالة الأولية (لم يُحدَّد بعد)
  initial,

  /// جارٍ التحميل
  loading,

  /// تم تسجيل الدخول بنجاح
  authenticated,

  /// لم يتم تسجيل الدخول
  unauthenticated,

  /// حدث خطأ
  error,
}

/// مزود حالة المصادقة - يُدار بـ Provider
/// يُخطر الواجهة بأي تغيير في حالة المصادقة
class AuthProvider extends ChangeNotifier {
  // ─── حقن التبعية ────────────────────────────────────────────
  final AuthRepoImpl _authRepo;

  AuthProvider({required AuthRepoImpl authRepo}) : _authRepo = authRepo;

  // ─── متغيرات الحالة ─────────────────────────────────────────

  /// الحالة الحالية للمصادقة
  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  /// بيانات المستخدم المسجّل حالياً
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  /// رسالة الخطأ (إن وُجدت)
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// هل المستخدم مسجّل دخول؟
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// هل الحالة في وضع التحميل؟
  bool get isLoading => _status == AuthStatus.loading;

  // ─── تسجيل الدخول ───────────────────────────────────────────

  /// تسجيل دخول المستخدم بالهاتف وكلمة المرور
  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    _setLoading();

    try {
      _currentUser = await _authRepo.login(
        phoneNumber: phoneNumber,
        password: password,
      );

      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } catch (e) {
      _setError(e.toString());
    }

    notifyListeners();
  }

  // ─── إنشاء حساب جديد ────────────────────────────────────────

  /// تسجيل مستخدم جديد في التطبيق
  Future<void> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    _setLoading();

    try {
      _currentUser = await _authRepo.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
        role: role,
      );

      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } catch (e) {
      _setError(e.toString());
    }

    notifyListeners();
  }

  // ─── تسجيل الخروج ───────────────────────────────────────────

  /// تسجيل خروج المستخدم ومسح بياناته
  Future<void> logout() async {
    await _authRepo.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ─── دوال مساعدة ─────────────────────────────────────────────

  /// تعيين حالة التحميل
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  /// تعيين حالة الخطأ مع الرسالة
  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
  }

  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
