// ============================================================
// ملف: features/patient/presentation/view/widgets/appointment_card_widget.dart
// الوصف: بطاقة عرض معلومات الموعد في قائمة مواعيد المريض
// تعرض: اسم الطبيب، التاريخ، الوقت، حالة الموعد
// ============================================================

import 'package:flutter/material.dart';
import '../../../../../data/models/appointment_model.dart';

/// بطاقة عرض معلومات الموعد
/// تستخدم في شاشة "مواعيدي"
class AppointmentCardWidget extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── الصف العلوي: اسم الطبيب والحالة ─────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'د. ${appointment.doctorId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),

            // ─── التاريخ والوقت ───────────────────────────────
            Row(
              children: [
                _buildInfoChip(
                  Icons.calendar_today_outlined,
                  _formatDate(appointment.appointmentDate),
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  Icons.access_time_rounded,
                  appointment.appointmentTime,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  _getTypeIcon(),
                  appointment.type == AppointmentType.clinicVisit ? 'عيادة' : 'عن بعد',
                ),
              ],
            ),

            // ─── زر الإلغاء (للمواعيد المعلقة والمؤكدة) ──────
            if (_canCancel()) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text('إلغاء الموعد'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── شارة حالة الموعد ────────────────────────────────────────
  Widget _buildStatusBadge() {
    final statusInfo = _getStatusInfo();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo['color'] as Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusInfo['label'] as String,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// شريحة معلومات صغيرة (أيقونة + نص)
  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
        ),
      ],
    );
  }

  // ─── دوال مساعدة ─────────────────────────────────────────────

  /// الحصول على معلومات حالة الموعد (اللون والنص)
  Map<String, dynamic> _getStatusInfo() {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return {'label': 'معلق', 'color': Colors.orange};
      case AppointmentStatus.confirmed:
        return {'label': 'مؤكد', 'color': Colors.blue};
      case AppointmentStatus.completed:
        return {'label': 'مكتمل', 'color': Colors.green};
      case AppointmentStatus.cancelled:
        return {'label': 'ملغى', 'color': Colors.red};
      case AppointmentStatus.rescheduled:
        return {'label': 'مُعاد جدولته', 'color': Colors.purple};
      case AppointmentStatus.noShow:
        return {'label': 'لم يحضر', 'color': Colors.grey};
    }
  }

  /// هل يمكن إلغاء الموعد؟
  bool _canCancel() =>
      appointment.status == AppointmentStatus.pending ||
      appointment.status == AppointmentStatus.confirmed;

  /// أيقونة نوع الموعد
  IconData _getTypeIcon() =>
      appointment.type == AppointmentType.clinicVisit
          ? Icons.local_hospital
          : Icons.videocam;

  /// تنسيق التاريخ
  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
