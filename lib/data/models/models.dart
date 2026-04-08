// ============================================================
// ملف: models.dart
// الوصف: ملف التجميع الرئيسي لجميع نماذج البيانات في تطبيق طبيبي
// يكفي استيراد هذا الملف الواحد للحصول على جميع النماذج
//
// أصحاب المصلحة الذين يغطيهم هذا المجلد:
//   1. المريض              ← UserModel, FamilyMemberModel, MedicalRecordModel, إلخ
//   2. الطبيب              ← DoctorModel, SpecialtyModel, AppointmentModel, إلخ
//   3. الأدمن (الإدارة)    ← ArticleModel, ComplaintModel, PaymentModel, إلخ
// ============================================================

// ─── 1. نموذج المستخدم الأساسي ──────────────────────────────
// يُستخدم لجميع أصحاب المصلحة (مريض، طبيب، أدمن)
export 'user_model.dart';

// ─── 2. نماذج المريض ─────────────────────────────────────────
// تمثّل بيانات المريض وأفراد عائلته وسجلاته الطبية
export 'family_member_model.dart';
export 'medical_record_model.dart';

// ─── 3. نماذج الطبيب ─────────────────────────────────────────
// تمثّل بيانات الطبيب المهنية وتخصصه
export 'doctor_model.dart';
export 'specialty_model.dart';

// ─── 4. نماذج الحجز والاستشارة ───────────────────────────────
// تُغطي دورة الحجز والتواصل بين المريض والطبيب، والوصفات الطبية
export 'appointment_model.dart';
export 'consultation_model.dart';
export 'chat_message_model.dart';
export 'prescription_model.dart';

// ─── 5. نماذج مشتركة وللإدارة (الأدمن + جميع المستخدمين) ──────
// تُستخدم من قِبل المريض أو الطبيب، وتُدار من الإدارة
export 'notification_model.dart';
export 'review_model.dart';
export 'payment_model.dart';
export 'article_model.dart';     // المقالات الطبية — يُدار من الأدمن
export 'complaint_model.dart';   // الشكاوى والدعم الفني — يُدار من الأدمن
