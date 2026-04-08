// ============================================================
// ملف: features/doctor/presentation/view/pages/doctor_appointments_page.dart
// الوصف: صفحة مواعيد الطبيب
// تعرض: مواعيد اليوم والقادمة مع إمكانية التأكيد والإكمال
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../manager/doctor_provider.dart';

/// صفحة مواعيد الطبيب
class DoctorAppointmentsPage extends StatefulWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  State<DoctorAppointmentsPage> createState() => _DoctorAppointmentsPageState();
}

class _DoctorAppointmentsPageState extends State<DoctorAppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المواعيد'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // ─── زر تحديث القائمة ──────────────────────────
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final doctorId =
                  context.read<AuthProvider>().currentUser?.id ?? '';
              context
                  .read<DoctorProvider>()
                  .loadDoctorAppointments(doctorId);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'اليوم'),
            Tab(text: 'القادمة'),
          ],
        ),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: 'جارٍ جلب المواعيد...');
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // ─── مواعيد اليوم ───────────────────────────
              _buildAppointmentList(
                provider.todayAppointments,
                'لا توجد مواعيد اليوم',
              ),
              // ─── المواعيد القادمة ────────────────────────
              _buildAppointmentList(
                provider.upcomingAppointments,
                'لا توجد مواعيد قادمة',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppointmentList(List appointments, String emptyMessage) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(emptyMessage, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: appointments.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _AppointmentManagementCard(
          appointment: appointment,
          onConfirm: () =>
              context.read<DoctorProvider>().confirmAppointment(appointment.id),
          onComplete: () =>
              context.read<DoctorProvider>().completeAppointment(appointment.id),
        );
      },
    );
  }
}

// ─── بطاقة إدارة الموعد ──────────────────────────────────────
class _AppointmentManagementCard extends StatelessWidget {
  final dynamic appointment;
  final Future<bool> Function() onConfirm;
  final Future<bool> Function() onComplete;

  const _AppointmentManagementCard({
    required this.appointment,
    required this.onConfirm,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── الصف العلوي: رقم المريض والوقت ──────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مريض: ${appointment.patientId.substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                appointment.appointmentTime,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ─── ملاحظات المريض ───────────────────────────────
          if (appointment.patientNotes != null)
            Text(
              'ملاحظات: ${appointment.patientNotes}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          const SizedBox(height: 12),

          // ─── أزرار الإجراءات ──────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onConfirm,
                  child: const Text('تأكيد'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onComplete,
                  child: const Text('إكمال'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
