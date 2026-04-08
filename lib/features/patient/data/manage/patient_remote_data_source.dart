// ============================================================
// ملف: features/patient/data/manage/patient_remote_data_source.dart
// الوصف: مصدر البيانات البعيد الخاص بالمريض
// يجلب بيانات الأطباء، المواعيد، السجلات الطبية من الـ API
// ============================================================

import '../../../../core/network/api_client.dart';
import '../../../../data/models/appointment_model.dart';
import '../../../../data/models/doctor_model.dart';
import '../../../../data/models/medical_record_model.dart';

/// مصدر البيانات البعيد الخاص بميزات المريض
class PatientRemoteDataSource {
  // ─── حقن التبعية ────────────────────────────────────────────
  final ApiClient _apiClient;

  PatientRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  // ─── جلب قائمة الأطباء ──────────────────────────────────────

  /// جلب قائمة الأطباء مع إمكانية الفلترة حسب التخصص والموقع
  /// [specialty] التخصص المطلوب (اختياري)
  /// [city] المدينة (اختياري)
  Future<List<DoctorModel>> getDoctors({
    String? specialty,
    String? city,
    double? minRating,
  }) async {
    // ─── بناء معاملات البحث ──────────────────────────────────
    final queryParams = <String, String>{};
    if (specialty != null) queryParams['specialty'] = specialty;
    if (city != null) queryParams['city'] = city;
    if (minRating != null) queryParams['min_rating'] = minRating.toString();

    final endpoint =
        '/doctors?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';

    final response = await _apiClient.get(endpoint);

    // ─── تحويل البيانات إلى قائمة نماذج ─────────────────────
    final List<dynamic> doctorsJson = response['doctors'] as List<dynamic>;
    return doctorsJson
        .map((json) => DoctorModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ─── جلب تفاصيل طبيب ────────────────────────────────────────

  /// جلب تفاصيل طبيب محدد بمعرّفه
  Future<DoctorModel> getDoctorById(String doctorId) async {
    final response = await _apiClient.get('/doctors/$doctorId');
    return DoctorModel.fromJson(response['doctor'] as Map<String, dynamic>);
  }

  // ─── حجز موعد ───────────────────────────────────────────────

  /// حجز موعد جديد مع طبيب
  Future<AppointmentModel> bookAppointment({
    required String doctorId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required String type, // 'clinic_visit' أو 'teleconsultation'
    String? patientNotes,
  }) async {
    final response = await _apiClient.post(
      '/appointments',
      {
        'doctor_id': doctorId,
        'appointment_date': appointmentDate.toIso8601String(),
        'appointment_time': appointmentTime,
        'type': type,
        if (patientNotes != null) 'patient_notes': patientNotes,
      },
    );

    return AppointmentModel.fromJson(
        response['appointment'] as Map<String, dynamic>);
  }

  // ─── جلب مواعيد المريض ──────────────────────────────────────

  /// جلب جميع مواعيد المريض (القادمة والسابقة)
  Future<List<AppointmentModel>> getMyAppointments() async {
    final response = await _apiClient.get('/appointments/my');

    final List<dynamic> appointmentsJson =
        response['appointments'] as List<dynamic>;
    return appointmentsJson
        .map((json) =>
            AppointmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ─── إلغاء موعد ─────────────────────────────────────────────

  /// إلغاء موعد محدد
  Future<void> cancelAppointment(String appointmentId) async {
    await _apiClient.delete('/appointments/$appointmentId');
  }

  // ─── جلب السجل الطبي ────────────────────────────────────────

  /// جلب السجلات الطبية للمريض المسجّل
  Future<List<MedicalRecordModel>> getMyMedicalRecords() async {
    final response = await _apiClient.get('/medical-records/my');

    final List<dynamic> recordsJson =
        response['records'] as List<dynamic>;
    return recordsJson
        .map((json) =>
            MedicalRecordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
