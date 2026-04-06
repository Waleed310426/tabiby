// ============================================================
// ملف: models.dart
// الوصف: ملف التجميع الرئيسي لجميع نماذج البيانات في تطبيق طبيبي
// يكفي استيراد هذا الملف الواحد للحصول على جميع النماذج
//
// الاستخدام:
//   import 'package:tabiby/data/models/models.dart';
//
// أصحاب المصلحة الذين يغطيهم هذا المجلد:
//   1. المريض              ← UserModel, FamilyMemberModel, MedicalRecordModel
//   2. الطبيب              ← DoctorModel, AppointmentModel, ConsultationModel
//   3. الأدمن (الإدارة)    ← ComplaintModel + جميع النماذج
//   4. الصيدلية            ← PharmacyModel, PrescriptionModel, MedicineModel
//   5. خدمات الطوارئ       ← EmergencyModel, AmbulanceModel
//   6. المختبرات/الأشعة    ← LabModel, LabTestRequestModel
// ============================================================

// ─── 1. نموذج المستخدم الأساسي ──────────────────────────────
// يُستخدم لجميع أصحاب المصلحة (مريض، طبيب، صيدلاني، إلخ)
export 'user_model.dart';

// ─── 2. نماذج المريض ─────────────────────────────────────────
// تمثّل بيانات المريض وأفراد عائلته وسجلاته الطبية
export 'family_member_model.dart';
export 'medical_record_model.dart';

// ─── 3. نماذج الطبيب ─────────────────────────────────────────
// تمثّل بيانات الطبيب المهنية وجدوله والمرافق الصحية
export 'doctor_model.dart';
export 'specialty_model.dart';
export 'facility_model.dart';

// ─── 4. نماذج الحجز والاستشارة ───────────────────────────────
// تُغطي دورة الحجز والتواصل بين المريض والطبيب
export 'appointment_model.dart';
export 'consultation_model.dart';
export 'chat_message_model.dart';

// ─── 5. نماذج الصيدلية ───────────────────────────────────────
// تمثّل بيانات الصيدلية والوصفات الطبية والأدوية والمخزون
export 'pharmacy_model.dart';
export 'prescription_model.dart';
export 'medicine_model.dart'; // قاعدة بيانات الأدوية + مخزون الصيدلية

// ─── 6. نماذج المختبرات ومراكز الأشعة ───────────────────────
// تُغطي طلبات الفحص ونتائجها بين المريض والمختبر
export 'lab_model.dart';
export 'lab_test_request_model.dart';

// ─── 7. نماذج خدمات الطوارئ والإسعاف ────────────────────────
// تمثّل بلاغات الطوارئ وسيارات الإسعاف
export 'emergency_model.dart';
export 'ambulance_model.dart';

// ─── 8. نماذج مشتركة (الأدمن + جميع المستخدمين) ─────────────
// تُستخدم من قِبل جميع أصحاب المصلحة
export 'notification_model.dart';
export 'review_model.dart';
export 'payment_model.dart';
export 'article_model.dart';
export 'complaint_model.dart'; // الشكاوى والدعم الفني — يُدار من الأدمن
