// ============================================================
// ملف: features/doctor/presentation/manager/doctor_provider.dart
// الوصف: مزود حالة خاصية الطبيب
// يدير: المواعيد، المرضى، لوحة التحكم
// ============================================================

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/appointment_model.dart';

/// مزود حالة الطبيب - يُدار بـ Provider
class DoctorProvider extends ChangeNotifier {
  // ─── مرجع Firestore ──────────────────────────────────────────
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── متغيرات الحالة ─────────────────────────────────────────

  /// مواعيد الطبيب اليوم
  List<AppointmentModel> _todayAppointments = [];
  List<AppointmentModel> get todayAppointments => _todayAppointments;

  /// مواعيد الطبيب القادمة
  List<AppointmentModel> _upcomingAppointments = [];
  List<AppointmentModel> get upcomingAppointments => _upcomingAppointments;

  /// هل يجري تحميل المواعيد؟
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// رسالة الخطأ الأخيرة
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// إجمالي المرضى الذين خدمهم الطبيب
  final int _totalPatients = 0;
  int get totalPatients => _totalPatients;

  /// إجمالي الإيرادات هذا الشهر
  final double _monthlyRevenue = 0.0;
  double get monthlyRevenue => _monthlyRevenue;

  // ─── جلب مواعيد الطبيب من Firestore ─────────────────────────

  /// جلب مواعيد اليوم والمواعيد القادمة للطبيب
  Future<void> loadDoctorAppointments(String doctorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      // ─── جلب مواعيد اليوم ───────────────────────────────────
      final todaySnapshot = await _firestore
          .collection('appointments')
          .where('doctor_id', isEqualTo: doctorId)
          .where('appointment_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .where('appointment_date',
              isLessThan: Timestamp.fromDate(todayEnd))
          .orderBy('appointment_date')
          .get();

      _todayAppointments = todaySnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();

      // ─── جلب المواعيد القادمة ───────────────────────────────
      final upcomingSnapshot = await _firestore
          .collection('appointments')
          .where('doctor_id', isEqualTo: doctorId)
          .where('appointment_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(todayEnd))
          .where('status', whereIn: ['pending', 'confirmed'])
          .orderBy('appointment_date')
          .limit(20)
          .get();

      _upcomingAppointments = upcomingSnapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'فشل جلب المواعيد: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── تأكيد موعد ──────────────────────────────────────────────

  /// تأكيد موعد المريض
  Future<bool> confirmAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': AppointmentStatus.confirmed.name,
        'updated_at': Timestamp.now(),
      });

      // ─── تحديث القائمة محلياً ──────────────────────────────
      _updateLocalStatus(appointmentId, AppointmentStatus.confirmed);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل تأكيد الموعد: $e';
      notifyListeners();
      return false;
    }
  }

  // ─── إكمال موعد ──────────────────────────────────────────────

  /// تحديث حالة الموعد إلى "مكتمل"
  Future<bool> completeAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': AppointmentStatus.completed.name,
        'updated_at': Timestamp.now(),
      });

      _updateLocalStatus(appointmentId, AppointmentStatus.completed);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'فشل إكمال الموعد: $e';
      notifyListeners();
      return false;
    }
  }

  // ─── دالة مساعدة: تحديث الحالة محلياً ───────────────────────
  void _updateLocalStatus(String appointmentId, AppointmentStatus newStatus) {
    final todayIndex =
        _todayAppointments.indexWhere((a) => a.id == appointmentId);
    if (todayIndex != -1) {
      _todayAppointments[todayIndex] =
          _todayAppointments[todayIndex].copyWith(status: newStatus);
    }

    final upcomingIndex =
        _upcomingAppointments.indexWhere((a) => a.id == appointmentId);
    if (upcomingIndex != -1) {
      _upcomingAppointments[upcomingIndex] =
          _upcomingAppointments[upcomingIndex].copyWith(status: newStatus);
    }
  }

  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
