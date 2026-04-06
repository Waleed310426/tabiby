// ============================================================
// ملف: user_model.dart
// الوصف: نموذج بيانات المستخدم الأساسي في تطبيق طبيبي
// يُستخدم هذا النموذج لجميع أنواع المستخدمين (مريض، طبيب، إداري، إلخ)
// ============================================================

// استيراد مكتبة cloud_firestore للتعامل مع قاعدة البيانات
import 'package:cloud_firestore/cloud_firestore.dart';

// ─── تعريف الأدوار المتاحة في النظام ───────────────────────
enum UserRole {
  patient,    // مريض
  doctor,     // طبيب
  pharmacy,   // صيدلية
  lab,        // مختبر / مركز أشعة
  emergency,  // خدمات الطوارئ والإسعاف
  admin,      // الأدمن (الإدارة العليا)
}

// ─── تعريف الجنس ────────────────────────────────────────────
enum Gender {
  male,   // ذكر
  female, // أنثى
  other,  // غير محدد
}

// ─── تعريف فصيلة الدم ───────────────────────────────────────
enum BloodType {
  aPositive,  // A+
  aNegative,  // A-
  bPositive,  // B+
  bNegative,  // B-
  abPositive, // AB+
  abNegative, // AB-
  oPositive,  // O+
  oNegative,  // O-
}

// ─── تعريف حالة الحساب ──────────────────────────────────────
enum AccountStatus {
  active,    // نشط
  inactive,  // غير نشط
  suspended, // موقوف
}

// ─── نموذج جهة اتصال الطوارئ ────────────────────────────────
class EmergencyContact {
  final String name;        // اسم جهة الاتصال
  final String phoneNumber; // رقم هاتف جهة الاتصال

  const EmergencyContact({
    required this.name,
    required this.phoneNumber,
  });

  // تحويل النموذج إلى Map لحفظه في Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
    };
  }

  // إنشاء النموذج من Map مسترجع من Firebase
  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
    );
  }
}

// ─── النموذج الرئيسي للمستخدم ───────────────────────────────
class UserModel {
  final String id;                          // معرّف المستخدم الفريد
  final String fullName;                    // الاسم الكامل
  final String phoneNumber;                 // رقم الهاتف (E.164)
  final String? email;                      // البريد الإلكتروني (اختياري)
  final UserRole role;                      // دور المستخدم في النظام
  final String? profileImageUrl;            // رابط الصورة الشخصية
  final DateTime? dateOfBirth;              // تاريخ الميلاد
  final Gender? gender;                     // الجنس
  final BloodType? bloodType;               // فصيلة الدم
  final List<String> chronicDiseases;       // الأمراض المزمنة
  final List<String> allergies;             // الحساسيات
  final List<String> currentMedications;    // الأدوية الحالية
  final List<EmergencyContact> emergencyContacts; // جهات اتصال الطوارئ
  final DateTime createdAt;                 // تاريخ إنشاء الحساب
  final DateTime updatedAt;                 // تاريخ آخر تحديث
  final bool isVerified;                    // هل تم التحقق من الهاتف/البريد؟
  final AccountStatus status;               // حالة الحساب

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.role,
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.chronicDiseases = const [],
    this.allergies = const [],
    this.currentMedications = const [],
    this.emergencyContacts = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.status = AccountStatus.active,
  });

  // ─── تحويل النموذج إلى Map لحفظه في Firestore ───────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'role': role.name,
      'profile_image_url': profileImageUrl,
      'date_of_birth': dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth!)
          : null,
      'gender': gender?.name,
      'blood_type': bloodType?.name,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
      'current_medications': currentMedications,
      'emergency_contacts':
          emergencyContacts.map((e) => e.toMap()).toList(),
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'is_verified': isVerified,
      'status': status.name,
    };
  }

  // ─── إنشاء النموذج من DocumentSnapshot مسترجع من Firestore ─
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fullName: data['full_name'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      email: data['email'],
      role: UserRole.values.firstWhere(
        (r) => r.name == data['role'],
        orElse: () => UserRole.patient, // القيمة الافتراضية: مريض
      ),
      profileImageUrl: data['profile_image_url'],
      dateOfBirth: data['date_of_birth'] != null
          ? (data['date_of_birth'] as Timestamp).toDate()
          : null,
      gender: data['gender'] != null
          ? Gender.values.firstWhere((g) => g.name == data['gender'])
          : null,
      bloodType: data['blood_type'] != null
          ? BloodType.values.firstWhere((b) => b.name == data['blood_type'])
          : null,
      chronicDiseases: List<String>.from(data['chronic_diseases'] ?? []),
      allergies: List<String>.from(data['allergies'] ?? []),
      currentMedications:
          List<String>.from(data['current_medications'] ?? []),
      emergencyContacts: (data['emergency_contacts'] as List<dynamic>? ?? [])
          .map((e) => EmergencyContact.fromMap(e))
          .toList(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      isVerified: data['is_verified'] ?? false,
      status: AccountStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => AccountStatus.active,
      ),
    );
  }

  // ─── نسخ النموذج مع تعديل بعض الحقول (immutable update) ───
  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    UserRole? role,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    Gender? gender,
    BloodType? bloodType,
    List<String>? chronicDiseases,
    List<String>? allergies,
    List<String>? currentMedications,
    List<EmergencyContact>? emergencyContacts,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    AccountStatus? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $fullName, role: ${role.name})';
}
