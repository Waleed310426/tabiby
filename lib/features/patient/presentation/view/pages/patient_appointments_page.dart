// ============================================================
// ملف: features/patient/presentation/view/pages/patient_appointments_page.dart
// الوصف: صفحة مواعيد المريض
// تعرض: المواعيد القادمة، السابقة، الملغاة
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../data/models/appointment_model.dart';
import '../../manager/patient_provider.dart';
import '../widgets/appointment_card_widget.dart';

/// صفحة مواعيد المريض
class PatientAppointmentsPage extends StatefulWidget {
  const PatientAppointmentsPage({super.key});

  @override
  State<PatientAppointmentsPage> createState() =>
      _PatientAppointmentsPageState();
}

class _PatientAppointmentsPageState extends State<PatientAppointmentsPage>
    with SingleTickerProviderStateMixin {
  // ─── متحكم التبويبات ─────────────────────────────────────────
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // ─── جلب المواعيد عند فتح الصفحة ─────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadMyAppointments();
    });
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
        title: const Text('مواعيدي'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        // ─── شريط التبويبات ───────────────────────────────────
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'السابقة'),
            Tab(text: 'الملغاة'),
          ],
        ),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, _) {
          // ─── حالة التحميل ─────────────────────────────────
          if (provider.isAppointmentsLoading) {
            return const LoadingIndicator(message: 'جارٍ جلب المواعيد...');
          }

          // ─── تصنيف المواعيد حسب حالتها ────────────────────
          final upcoming = provider.appointments
              .where((a) => a.status == AppointmentStatus.pending || a.status == AppointmentStatus.confirmed)
              .toList();
          final completed = provider.appointments
              .where((a) => a.status == AppointmentStatus.completed)
              .toList();
          final cancelled = provider.appointments
              .where((a) => a.status == AppointmentStatus.cancelled)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              // ─── تاب المواعيد القادمة ──────────────────────
              _buildAppointmentList(provider, upcoming, 'لا توجد مواعيد قادمة'),
              // ─── تاب المواعيد المكتملة ─────────────────────
              _buildAppointmentList(provider, completed, 'لا توجد زيارات سابقة'),
              // ─── تاب المواعيد الملغاة ──────────────────────
              _buildAppointmentList(provider, cancelled, 'لا توجد مواعيد ملغاة'),
            ],
          );
        },
      ),
    );
  }

  /// بناء قائمة المواعيد
  Widget _buildAppointmentList(
    PatientProvider provider,
    List appointments,
    String emptyMessage,
  ) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 64, color: Colors.grey),
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
        return AppointmentCardWidget(
          appointment: appointment,
          onTap: () {
            // TODO: الانتقال لصفحة تفاصيل الموعد
          },
          onCancel: () => _confirmCancel(provider, appointment.id),
        );
      },
    );
  }

  /// تأكيد إلغاء الموعد بنافذة حوار
  void _confirmCancel(PatientProvider provider, String appointmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الموعد'),
        content: const Text('هل أنت متأكد من رغبتك في إلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لا'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.cancelAppointment(appointmentId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('نعم، إلغاء'),
          ),
        ],
      ),
    );
  }
}
