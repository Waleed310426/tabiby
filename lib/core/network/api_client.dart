// ============================================================
// ملف: core/network/api_client.dart
// الوصف: عميل HTTP المركزي لجميع طلبات الشبكة في التطبيق
// يستخدم هذا الكلاس من قِبَل جميع طبقات data للتواصل مع الـ API
// ============================================================

import 'package:http/http.dart' as http;
import 'dart:convert';

/// عميل HTTP مركزي يُستخدم في جميع أنحاء التطبيق
/// يوفر دوال موحدة لـ GET و POST و PUT و DELETE
class ApiClient {
  // ─── الرابط الأساسي للـ API ─────────────────────────────────
  static const String _baseUrl = 'https://api.tabibi.com/api/v1';

  // ─── مهلة الانتظار للطلبات ──────────────────────────────────
  static const Duration _timeout = Duration(seconds: 30);

  // ─── رأس الطلب الافتراضي ────────────────────────────────────
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// تحديث رمز المصادقة بعد تسجيل الدخول
  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  /// حذف رمز المصادقة عند تسجيل الخروج
  void clearAuthToken() {
    _defaultHeaders.remove('Authorization');
  }

  // ─── طلب GET: جلب البيانات ──────────────────────────────────

  /// جلب بيانات من الـ API
  /// [endpoint] نقطة النهاية (مثل: /doctors)
  /// يُرجع [Map] يحتوي على البيانات أو يرمي [Exception]
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _defaultHeaders,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('فشل طلب GET: $e');
    }
  }

  // ─── طلب POST: إرسال بيانات جديدة ──────────────────────────

  /// إرسال بيانات جديدة إلى الـ API
  /// [endpoint] نقطة النهاية
  /// [body] البيانات المُرسَلة كـ Map
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _defaultHeaders,
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('فشل طلب POST: $e');
    }
  }

  // ─── طلب PUT: تحديث بيانات موجودة ──────────────────────────

  /// تحديث بيانات موجودة في الـ API
  /// [endpoint] نقطة النهاية (تتضمن معرف العنصر)
  /// [body] البيانات المُحدَّثة كـ Map
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _defaultHeaders,
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('فشل طلب PUT: $e');
    }
  }

  // ─── طلب DELETE: حذف بيانات ─────────────────────────────────

  /// حذف بيانات من الـ API
  /// [endpoint] نقطة النهاية (تتضمن معرف العنصر المراد حذفه)
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _defaultHeaders,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('فشل طلب DELETE: $e');
    }
  }

  // ─── معالجة الاستجابة ───────────────────────────────────────

  /// معالجة استجابة الـ API والتحقق من رمز الحالة
  /// يُرجع البيانات إذا كانت الاستجابة ناجحة (200-299)
  /// يرمي [Exception] إذا كان هناك خطأ
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

    // ─── الاستجابات الناجحة ──────────────────────────────────
    if (statusCode >= 200 && statusCode < 300) {
      return decodedBody as Map<String, dynamic>;
    }

    // ─── معالجة أخطاء الاستجابة ─────────────────────────────
    switch (statusCode) {
      case 400:
        throw Exception('طلب غير صالح: ${decodedBody['message']}');
      case 401:
        throw Exception('غير مصرح: يرجى تسجيل الدخول مجدداً');
      case 403:
        throw Exception('محظور: ليس لديك صلاحية للوصول');
      case 404:
        throw Exception('غير موجود: البيانات المطلوبة غير متاحة');
      case 500:
        throw Exception('خطأ في الخادم: يرجى المحاولة لاحقاً');
      default:
        throw Exception('خطأ غير متوقع: رمز الحالة $statusCode');
    }
  }
}
