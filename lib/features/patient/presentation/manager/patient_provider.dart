// ============================================================
// ملف: features/patient/presentation/manager/patient_provider.dart
// الوصف: مزود حالة خاصية المريض
// يدير: الأطباء، المواعيد، السجلات الطبية
// ============================================================

import 'package:flutter/material.dart';
import '../../../../data/models/appointment_model.dart';
import '../../../../data/models/doctor_model.dart';
import '../../../../data/models/medical_record_model.dart';
import '../../data/repo/patient_repo_impl.dart';

/// مزود حالة المريض - يُدار بـ Provider
class PatientProvider extends ChangeNotifier {
  final PatientRepoImpl _repo;

  PatientProvider({required PatientRepoImpl repo}) : _repo = repo;

  // ─── متغيرات الحالة ─────────────────────────────────────────

  /// قائمة الأطباء المجلوبة من الـ API
  List<DoctorModel> _doctors = [];
  List<DoctorModel> get doctors => _doctors;

  /// مواعيد المريض
  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  /// السجلات الطبية للمريض
  List<MedicalRecordModel> _medicalRecords = [];
  List<MedicalRecordModel> get medicalRecords => _medicalRecords;

  /// هل يجري تحميل بيانات الأطباء؟
  bool _isDoctorsLoading = false;
  bool get isDoctorsLoading => _isDoctorsLoading;

  /// هل يجري تحميل المواعيد؟
  bool _isAppointmentsLoading = false;
  bool get isAppointmentsLoading => _isAppointmentsLoading;

  /// هل يجري تحميل السجلات الطبية؟
  bool _isRecordsLoading = false;
  bool get isRecordsLoading => _isRecordsLoading;

  /// رسالة الخطأ الأخيرة
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── جلب الأطباء ─────────────────────────────────────────────

  /// جلب قائمة الأطباء مع إمكانية الفلترة
  Future<void> loadDoctors({
    String? specialty,
    String? city,
    double? minRating,
  }) async {
    _isDoctorsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _doctors = await _repo.getDoctors(
        specialty: specialty,
        city: city,
        minRating: minRating,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDoctorsLoading = false;
      notifyListeners();
    }
  }

  // ─── جلب المواعيد ─────────────────────────────────────────────

  /// جلب مواعيد المريض
  Future<void> loadMyAppointments() async {
    _isAppointmentsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _appointments = await _repo.getMyAppointments();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isAppointmentsLoading = false;
      notifyListeners();
    }
  }

  // ─── حجز موعد ────────────────────────────────────────────────

  /// حجز موعد جديد
  Future<bool> bookAppointment({
    required String doctorId,
    required DateTime date,
    required String time,
    required String type,
    String? notes,
  }) async {
    try {
      final newAppointment = await _repo.bookAppointment(
        doctorId: doctorId,
        appointmentDate: date,
        appointmentTime: time,
        type: type,
        patientNotes: notes,
      );

      // ─── إضافة الموعد الجديد للقائمة محلياً ────────────────
      _appointments.insert(0, newAppointment);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ─── إلغاء موعد ──────────────────────────────────────────────

  /// إلغاء موعد وتحديث القائمة
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      await _repo.cancelAppointment(appointmentId);

      // ─── حذف الموعد من القائمة محلياً ───────────────────────
      _appointments.removeWhere((a) => a.id == appointmentId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ─── جلب السجلات الطبية ──────────────────────────────────────

  /// جلب السجلات الطبية للمريض
  Future<void> loadMedicalRecords() async {
    _isRecordsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _medicalRecords = await _repo.getMyMedicalRecords();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isRecordsLoading = false;
      notifyListeners();
    }
  }

  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
