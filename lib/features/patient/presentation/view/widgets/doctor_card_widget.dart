// ============================================================
// ملف: features/patient/presentation/view/widgets/doctor_card_widget.dart
// الوصف: بطاقة عرض معلومات الطبيب في قائمة الأطباء
// تعرض: الصورة، الاسم، التخصص، التقييم، رسوم الاستشارة
// ============================================================

import 'package:flutter/material.dart';
import '../../../../../data/models/doctor_model.dart';

/// بطاقة عرض معلومات الطبيب المختصرة
/// تستخدم في شاشة البحث والصفحة الرئيسية
class DoctorCardWidget extends StatelessWidget {
  // ─── خصائص البطاقة ───────────────────────────────────────────
  final DoctorModel doctor;
  final VoidCallback? onTap;

  const DoctorCardWidget({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ─── صورة الطبيب ──────────────────────────────────
            _buildDoctorAvatar(),
            const SizedBox(width: 16),

            // ─── معلومات الطبيب ───────────────────────────────
            Expanded(child: _buildDoctorInfo(context)),

            // ─── سعر الاستشارة ────────────────────────────────
            _buildConsultationFee(context),
          ],
        ),
      ),
    );
  }

  // ─── صورة الطبيب ─────────────────────────────────────────────
  Widget _buildDoctorAvatar() {
    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.blue.shade50,
      backgroundImage: doctor.profileImageUrl != null
          ? NetworkImage(doctor.profileImageUrl!)
          : null,
      child: doctor.profileImageUrl == null
          ? const Icon(Icons.person, size: 32, color: Colors.blue)
          : null,
    );
  }

  // ─── معلومات الطبيب ──────────────────────────────────────────
  Widget _buildDoctorInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── اسم الطبيب ──────────────────────────────────────
        Text(
          'د. ${doctor.fullName}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // ─── التخصص ──────────────────────────────────────────
        Text(
          doctor.specialty,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),

        // ─── التقييم ─────────────────────────────────────────
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              doctor.averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${doctor.totalReviews} تقييم)',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  // ─── سعر الاستشارة ───────────────────────────────────────────
  Widget _buildConsultationFee(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${doctor.consultationFee.toInt()} ر.ي',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        // ─── مؤشر الاستشارة عن بعد ──────────────────────────
        if (doctor.isAvailableForTeleconsultation)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'عن بعد',
              style: TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
