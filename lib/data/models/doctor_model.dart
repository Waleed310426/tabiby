// ============================================================
// ملف: doctor_model.dart
// الوصف: نموذج بيانات الطبيب في تطبيق طبيبي
// يحتوي على كافة المعلومات المهنية للطبيب وعيادته
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── حالة الطبيب في النظام ───────────────────────────────────
enum DoctorStatus {
  active,   // نشط ومتاح
  onLeave,  // في إجازة
  inactive, // غير نشط
}

// ─── أيام الأسبوع ───────────────────────────────────────────
enum WeekDay {
  sunday,    // الأحد
  monday,    // الاثنين
  tuesday,   // الثلاثاء
  wednesday, // الأربعاء
  thursday,  // الخميس
  friday,    // الجمعة
  saturday,  // السبت
}

// ─── نموذج ساعات العمل ليوم واحد ────────────────────────────
class WorkingHours {
  final WeekDay day;       // اليوم
  final String startTime; // وقت بداية الدوام (مثال: "09:00")
  final String endTime;   // وقت نهاية الدوام (مثال: "17:00")

  const WorkingHours({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  // تحويل إلى Map لحفظه في Firebase
  Map<String, dynamic> toMap() {
    return {
      'day': day.name,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  // إنشاء من Map مسترجع من Firebase
  factory WorkingHours.fromMap(Map<String, dynamic> map) {
    return WorkingHours(
      day: WeekDay.values.firstWhere(
        (d) => d.name == map['day'],
        orElse: () => WeekDay.sunday,
      ),
      startTime: map['start_time'] ?? '09:00',
      endTime: map['end_time'] ?? '17:00',
    );
  }
}

// ─── النموذج الرئيسي للطبيب ─────────────────────────────────
class DoctorModel {
  final String id;                          // معرّف الطبيب الفريد
  final String userId;                      // معرّف المستخدم المرتبط به
  final String fullName;                    // اسم الطبيب الكامل
  final String? profileImageUrl;            // صورة الطبيب الشخصية
  final String specialty;                   // التخصص الرئيسي
  final List<String> subSpecialties;        // التخصصات الفرعية
  final String medicalLicenseNumber;        // رقم الترخيص الطبي
  final int yearsOfExperience;              // سنوات الخبرة
  final String? clinicName;                 // اسم العيادة
  final String? clinicAddress;              // عنوان العيادة
  final double? clinicLatitude;             // خط العرض (الإحداثي الجغرافي)
  final double? clinicLongitude;            // خط الطول (الإحداثي الجغرافي)
  final double consultationFee;             // رسوم الكشف في العيادة
  final double teleconsultationFee;         // رسوم الاستشارة عن بعد
  final List<WorkingHours> workingHours;    // جدول ساعات العمل
  final List<String> education;             // المؤهلات العلمية
  final List<String> certifications;        // الشهادات والتراخيص
  final String? aboutMe;                    // نبذة عن الطبيب
  final double averageRating;               // متوسط تقييم المرضى
  final int totalReviews;                   // إجمالي عدد التقييمات
  final bool isAvailableForTeleconsultation; // هل يقدم استشارات عن بعد؟
  final bool isApprovedByAdmin;             // هل وافق عليه الأدمن؟
  final DoctorStatus status;                // حالة الطبيب

  const DoctorModel({
    required this.id,
    required this.userId,
    this.fullName = '',
    this.profileImageUrl,
    required this.specialty,
    this.subSpecialties = const [],
    required this.medicalLicenseNumber,
    required this.yearsOfExperience,
    this.clinicName,
    this.clinicAddress,
    this.clinicLatitude,
    this.clinicLongitude,
    required this.consultationFee,
    required this.teleconsultationFee,
    this.workingHours = const [],
    this.education = const [],
    this.certifications = const [],
    this.aboutMe,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.isAvailableForTeleconsultation = false,
    this.isApprovedByAdmin = false,
    this.status = DoctorStatus.active,
  });

  // ─── تحويل النموذج إلى Map لحفظه في Firestore ───────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'specialty': specialty,
      'sub_specialties': subSpecialties,
      'medical_license_number': medicalLicenseNumber,
      'years_of_experience': yearsOfExperience,
      'clinic_name': clinicName,
      'clinic_address': clinicAddress,
      'clinic_latitude': clinicLatitude,
      'clinic_longitude': clinicLongitude,
      'consultation_fee': consultationFee,
      'teleconsultation_fee': teleconsultationFee,
      'working_hours': workingHours.map((w) => w.toMap()).toList(),
      'education': education,
      'certifications': certifications,
      'about_me': aboutMe,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'is_available_for_teleconsultation': isAvailableForTeleconsultation,
      'is_approved_by_admin': isApprovedByAdmin,
      'status': status.name,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      fullName: data['full_name'] ?? '',
      profileImageUrl: data['profile_image_url'],
      specialty: data['specialty'] ?? '',
      subSpecialties: List<String>.from(data['sub_specialties'] ?? []),
      medicalLicenseNumber: data['medical_license_number'] ?? '',
      yearsOfExperience: data['years_of_experience'] ?? 0,
      clinicName: data['clinic_name'],
      clinicAddress: data['clinic_address'],
      clinicLatitude: data['clinic_latitude']?.toDouble(),
      clinicLongitude: data['clinic_longitude']?.toDouble(),
      consultationFee: (data['consultation_fee'] ?? 0).toDouble(),
      teleconsultationFee: (data['teleconsultation_fee'] ?? 0).toDouble(),
      workingHours: (data['working_hours'] as List<dynamic>? ?? [])
          .map((w) => WorkingHours.fromMap(w))
          .toList(),
      education: List<String>.from(data['education'] ?? []),
      certifications: List<String>.from(data['certifications'] ?? []),
      aboutMe: data['about_me'],
      averageRating: (data['average_rating'] ?? 0.0).toDouble(),
      totalReviews: data['total_reviews'] ?? 0,
      isAvailableForTeleconsultation:
          data['is_available_for_teleconsultation'] ?? false,
      isApprovedByAdmin: data['is_approved_by_admin'] ?? false,
      status: DoctorStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => DoctorStatus.active,
      ),
    );
  }

  // ─── إنشاء النموذج من JSON ────────────────────────────────
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImageUrl: json['profile_image_url'],
      specialty: json['specialty'] ?? '',
      subSpecialties: List<String>.from(json['sub_specialties'] ?? []),
      medicalLicenseNumber: json['medical_license_number'] ?? '',
      yearsOfExperience: json['years_of_experience'] ?? 0,
      clinicName: json['clinic_name'],
      clinicAddress: json['clinic_address'],
      clinicLatitude: json['clinic_latitude']?.toDouble(),
      clinicLongitude: json['clinic_longitude']?.toDouble(),
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
      teleconsultationFee: (json['teleconsultation_fee'] ?? 0).toDouble(),
      workingHours: (json['working_hours'] as List<dynamic>? ?? [])
          .map((w) => WorkingHours.fromMap(w))
          .toList(),
      education: List<String>.from(json['education'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      aboutMe: json['about_me'],
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      isAvailableForTeleconsultation:
          json['is_available_for_teleconsultation'] ?? false,
      isApprovedByAdmin: json['is_approved_by_admin'] ?? false,
      status: DoctorStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => DoctorStatus.active,
      ),
    );
  }

  // ─── نسخ النموذج مع تعديل ────────────────────────────────
  DoctorModel copyWith({
    String? fullName,
    String? profileImageUrl,
    String? specialty,
    List<String>? subSpecialties,
    String? clinicName,
    String? clinicAddress,
    double? clinicLatitude,
    double? clinicLongitude,
    double? consultationFee,
    double? teleconsultationFee,
    List<WorkingHours>? workingHours,
    List<String>? education,
    List<String>? certifications,
    String? aboutMe,
    double? averageRating,
    int? totalReviews,
    bool? isAvailableForTeleconsultation,
    bool? isApprovedByAdmin,
    DoctorStatus? status,
  }) {
    return DoctorModel(
      id: id,
      userId: userId,
      fullName: fullName ?? this.fullName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specialty: specialty ?? this.specialty,
      subSpecialties: subSpecialties ?? this.subSpecialties,
      medicalLicenseNumber: medicalLicenseNumber,
      yearsOfExperience: yearsOfExperience,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicLatitude: clinicLatitude ?? this.clinicLatitude,
      clinicLongitude: clinicLongitude ?? this.clinicLongitude,
      consultationFee: consultationFee ?? this.consultationFee,
      teleconsultationFee: teleconsultationFee ?? this.teleconsultationFee,
      workingHours: workingHours ?? this.workingHours,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      aboutMe: aboutMe ?? this.aboutMe,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      isAvailableForTeleconsultation:
          isAvailableForTeleconsultation ?? this.isAvailableForTeleconsultation,
      isApprovedByAdmin: isApprovedByAdmin ?? this.isApprovedByAdmin,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'DoctorModel(id: $id, specialty: $specialty, rating: $averageRating)';
}
