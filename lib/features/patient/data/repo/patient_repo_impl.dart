// ============================================================
// ملف: features/patient/data/repo/patient_repo_impl.dart
// الوصف: تنفيذ مستودع بيانات المريض
// وسيط بين طبقة العرض ومصدر البيانات البعيد
// ============================================================

import '../../../../data/models/appointment_model.dart';
import '../../../../data/models/doctor_model.dart';
import '../../../../data/models/medical_record_model.dart';
import '../manage/patient_remote_data_source.dart';

/// مستودع بيانات المريض - يُوحّد الوصول للبيانات
class PatientRepoImpl {
  final PatientRemoteDataSource _remoteDataSource;

  PatientRepoImpl({required PatientRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  // ─── الأطباء ─────────────────────────────────────────────────

  /// جلب قائمة الأطباء مع الفلاتر
  Future<List<DoctorModel>> getDoctors({
    String? specialty,
    String? city,
    double? minRating,
  }) async {
    try {
      return await _remoteDataSource.getDoctors(
        specialty: specialty,
        city: city,
        minRating: minRating,
      );
    } catch (e) {
      throw Exception('فشل جلب قائمة الأطباء: $e');
    }
  }

  /// جلب تفاصيل طبيب بمعرّفه
  Future<DoctorModel> getDoctorById(String doctorId) async {
    try {
      return await _remoteDataSource.getDoctorById(doctorId);
    } catch (e) {
      throw Exception('فشل جلب بيانات الطبيب: $e');
    }
  }

  // ─── المواعيد ─────────────────────────────────────────────────

  /// حجز موعد جديد
  Future<AppointmentModel> bookAppointment({
    required String doctorId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required String type,
    String? patientNotes,
  }) async {
    try {
      return await _remoteDataSource.bookAppointment(
        doctorId: doctorId,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        type: type,
        patientNotes: patientNotes,
      );
    } catch (e) {
      throw Exception('فشل حجز الموعد: $e');
    }
  }

  /// جلب مواعيد المريض
  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      return await _remoteDataSource.getMyAppointments();
    } catch (e) {
      throw Exception('فشل جلب المواعيد: $e');
    }
  }

  /// إلغاء موعد
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _remoteDataSource.cancelAppointment(appointmentId);
    } catch (e) {
      throw Exception('فشل إلغاء الموعد: $e');
    }
  }

  // ─── السجل الطبي ──────────────────────────────────────────────

  /// جلب السجلات الطبية للمريض
  Future<List<MedicalRecordModel>> getMyMedicalRecords() async {
    try {
      return await _remoteDataSource.getMyMedicalRecords();
    } catch (e) {
      throw Exception('فشل جلب السجلات الطبية: $e');
    }
  }
}
