// ============================================================
// ملف: family_member_model.dart
// الوصف: نموذج بيانات فرد العائلة المُضاف إلى حساب المريض
// يتيح للمريض إدارة الملفات الصحية لأفراد أسرته من حساب واحد
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart'; // لاستخدام Gender و BloodType

// ─── صلة القرابة بين المريض الرئيسي والفرد المُضاف ──────────
enum FamilyRelation {
  spouse,  // زوج / زوجة
  child,   // ابن / ابنة
  parent,  // أب / أم
  sibling, // أخ / أخت
  other,   // أخرى
}

// ─── النموذج الرئيسي لفرد العائلة ───────────────────────────
class FamilyMemberModel {
  final String id;                       // معرّف الفرد الفريد
  final String ownerId;                  // معرّف المريض الرئيسي صاحب الحساب
  final String fullName;                 // الاسم الكامل لفرد العائلة
  final DateTime? dateOfBirth;           // تاريخ الميلاد
  final Gender? gender;                  // الجنس
  final BloodType? bloodType;            // فصيلة الدم
  final FamilyRelation relation;         // صلة القرابة
  final String? profileImageUrl;         // الصورة الشخصية (اختياري)
  final List<String> chronicDiseases;    // الأمراض المزمنة
  final List<String> allergies;          // الحساسيات
  final List<String> currentMedications; // الأدوية الحالية
  final DateTime createdAt;             // تاريخ الإضافة

  const FamilyMemberModel({
    required this.id,
    required this.ownerId,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    required this.relation,
    this.profileImageUrl,
    this.chronicDiseases = const [],
    this.allergies = const [],
    this.currentMedications = const [],
    required this.createdAt,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'full_name': fullName,
      'date_of_birth': dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth!)
          : null,
      'gender': gender?.name,
      'blood_type': bloodType?.name,
      'relation': relation.name,
      'profile_image_url': profileImageUrl,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
      'current_medications': currentMedications,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory FamilyMemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyMemberModel(
      id: doc.id,
      ownerId: data['owner_id'] ?? '',
      fullName: data['full_name'] ?? '',
      dateOfBirth: data['date_of_birth'] != null
          ? (data['date_of_birth'] as Timestamp).toDate()
          : null,
      gender: data['gender'] != null
          ? Gender.values.firstWhere((g) => g.name == data['gender'])
          : null,
      bloodType: data['blood_type'] != null
          ? BloodType.values.firstWhere((b) => b.name == data['blood_type'])
          : null,
      relation: FamilyRelation.values.firstWhere(
        (r) => r.name == data['relation'],
        orElse: () => FamilyRelation.other,
      ),
      profileImageUrl: data['profile_image_url'],
      chronicDiseases: List<String>.from(data['chronic_diseases'] ?? []),
      allergies: List<String>.from(data['allergies'] ?? []),
      currentMedications:
          List<String>.from(data['current_medications'] ?? []),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() =>
      'FamilyMemberModel(id: $id, name: $fullName, relation: ${relation.name})';
}
