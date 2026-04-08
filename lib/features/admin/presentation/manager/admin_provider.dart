// ============================================================
// ملف: features/admin/presentation/manager/admin_provider.dart
// الوصف: مزود حالة خاصية الأدمن (الإدارة العليا)
// يدير: الأطباء المعلقين، الإحصائيات العامة، التقارير
// ============================================================

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/doctor_model.dart';
import '../../../../data/models/user_model.dart';

/// مزود حالة الأدمن - يُدار بـ Provider
class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── متغيرات الحالة ─────────────────────────────────────────

  /// الأطباء المنتظرون موافقة الأدمن
  List<DoctorModel> _pendingDoctors = [];
  List<DoctorModel> get pendingDoctors => _pendingDoctors;

  /// المستخدمون الموقوفون
  final List<UserModel> _suspendedUsers = [];
  List<UserModel> get suspendedUsers => _suspendedUsers;

  /// إحصائيات عامة
  Map<String, int> _stats = {
    'totalUsers': 0,
    'totalDoctors': 0,
    'totalPatients': 0,
    'totalAppointments': 0,
  };
  Map<String, int> get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── جلب الإحصائيات العامة ────────────────────────────────────

  /// جلب إحصائيات المنصة الكاملة
  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ─── جلب عدد المستخدمين ─────────────────────────────────
      final usersCount = await _firestore.collection('users').count().get();

      // ─── جلب الأطباء المعلقين ────────────────────────────────
      final pendingSnapshot = await _firestore
          .collection('doctors')
          .where('is_approved_by_admin', isEqualTo: false)
          .where('status', isEqualTo: DoctorStatus.active.name)
          .get();

      _pendingDoctors = pendingSnapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();

      // ─── تحديث الإحصائيات ────────────────────────────────────
      _stats = {
        'totalUsers': usersCount.count ?? 0,
        'totalDoctors': 0,
        'totalPatients': 0,
        'pendingDoctors': _pendingDoctors.length,
      };
    } catch (e) {
      _errorMessage = 'فشل جلب الإحصائيات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── الموافقة على طبيب ────────────────────────────────────────

  /// الموافقة على تسجيل طبيب جديد في المنصة
  Future<bool> approveDoctor(String doctorId) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'is_approved_by_admin': true,
        'updated_at': Timestamp.now(),
      });

      // ─── إزالة الطبيب من قائمة الانتظار محلياً ──────────────
      _pendingDoctors.removeWhere((d) => d.id == doctorId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل الموافقة على الطبيب: $e';
      notifyListeners();
      return false;
    }
  }

  // ─── رفض طبيب ─────────────────────────────────────────────────

  /// رفض تسجيل طبيب (حذفه من قائمة الانتظار)
  Future<bool> rejectDoctor(String doctorId) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).update({
        'status': DoctorStatus.inactive.name,
        'updated_at': Timestamp.now(),
      });

      _pendingDoctors.removeWhere((d) => d.id == doctorId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل رفض الطبيب: $e';
      notifyListeners();
      return false;
    }
  }

  // ─── إيقاف مستخدم ─────────────────────────────────────────────

  /// إيقاف حساب مستخدم مخالف
  Future<bool> suspendUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'status': AccountStatus.suspended.name,
        'updated_at': Timestamp.now(),
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل إيقاف المستخدم: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
