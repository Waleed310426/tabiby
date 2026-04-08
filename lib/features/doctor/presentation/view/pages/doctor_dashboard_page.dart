// ============================================================
// ملف: features/doctor/presentation/view/pages/doctor_dashboard_page.dart
// الوصف: لوحة تحكم الطبيب الرئيسية
// تعرض: مواعيد اليوم، الإحصائيات، المواعيد القادمة
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../data/models/appointment_model.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../manager/doctor_provider.dart';
import 'doctor_appointments_page.dart';
import 'doctor_profile_page.dart';

/// لوحة تحكم الطبيب الرئيسية
class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  // ─── الفهرس الحالي لشريط التنقل السفلي ─────────────────────
  int _currentIndex = 0;

  // ─── صفحات شريط التنقل السفلي ────────────────────────────────
  final List<Widget> _pages = [
    const _DashboardTab(),
    const DoctorAppointmentsPage(),
    const DoctorProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // ─── جلب البيانات عند فتح لوحة التحكم ───────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctorId =
          context.read<AuthProvider>().currentUser?.id ?? '';
      if (doctorId.isNotEmpty) {
        context.read<DoctorProvider>().loadDoctorAppointments(doctorId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.doctorColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'لوحة التحكم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'المواعيد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}

// ─── تاب لوحة التحكم ──────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer2<AuthProvider, DoctorProvider>(
          builder: (context, auth, doctor, _) {
            return CustomScrollView(
              slivers: [
                // ─── الهيدر ─────────────────────────────────
                SliverToBoxAdapter(child: _buildHeader(context, auth)),

                // ─── إحصائيات اليوم ─────────────────────────
                SliverToBoxAdapter(child: _buildTodayStats(doctor)),

                // ─── عنوان قائمة مواعيد اليوم ───────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'مواعيد اليوم',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                // ─── قائمة مواعيد اليوم ─────────────────────
                _buildTodayAppointments(doctor),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── الهيدر مع التحية ────────────────────────────────────────
  Widget _buildHeader(BuildContext context, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً، دكتور 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    auth.currentUser?.fullName ?? 'الطبيب',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // ─── أيقونة الإشعارات ──────────────────────
              CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ─── التاريخ الحالي ──────────────────────────────
          Text(
            'اليوم ${_formatDate(DateTime.now())}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ─── إحصائيات اليوم ──────────────────────────────────────────
  Widget _buildTodayStats(DoctorProvider doctor) {
    final today = doctor.todayAppointments;
    final confirmed = today.where((a) => a.status == AppointmentStatus.confirmed).length;
    final pending = today.where((a) => a.status == AppointmentStatus.pending).length;
    final completed = today.where((a) => a.status == AppointmentStatus.completed).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _StatCard(
            label: 'اليوم',
            value: today.length.toString(),
            icon: Icons.calendar_today,
            color: AppColors.doctorColor,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'مؤكدة',
            value: confirmed.toString(),
            icon: Icons.check_circle,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'منتظرة',
            value: pending.toString(),
            icon: Icons.access_time,
            color: Colors.orange,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'مكتملة',
            value: completed.toString(),
            icon: Icons.done_all,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  // ─── قائمة مواعيد اليوم ──────────────────────────────────────
  Widget _buildTodayAppointments(DoctorProvider doctor) {
    if (doctor.isLoading) {
      return const SliverToBoxAdapter(
        child: LoadingIndicator(message: 'جارٍ جلب المواعيد...', fullScreen: false),
      );
    }

    if (doctor.todayAppointments.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.event_available, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('لا توجد مواعيد اليوم', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final appointment = doctor.todayAppointments[index];
          return _DoctorAppointmentTile(appointment: appointment);
        },
        childCount: doctor.todayAppointments.length,
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}

// ─── بطاقة إحصائية صغيرة ─────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── بطاقة موعد الطبيب ───────────────────────────────────────
class _DoctorAppointmentTile extends StatelessWidget {
  final AppointmentModel appointment;

  const _DoctorAppointmentTile({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // ─── دائرة وقت الموعد ─────────────────────────────
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.doctorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appointment.appointmentTime.split(':')[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.doctorColor,
                  ),
                ),
                Text(
                  ':${appointment.appointmentTime.split(':')[1]}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // ─── معلومات المريض ───────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مريض #${appointment.patientId.substring(0, 6)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  appointment.type == AppointmentType.teleconsultation
                      ? 'استشارة عن بُعد'
                      : 'زيارة حضورية',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // ─── شارة الحالة ──────────────────────────────────
          _StatusBadge(status: appointment.status),
        ],
      ),
    );
  }
}

// ─── شارة حالة الموعد للطبيب ─────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    String label = '';

    switch (status) {
      case AppointmentStatus.pending:
        color = Colors.orange;
        label = 'معلق';
        break;
      case AppointmentStatus.confirmed:
        color = Colors.blue;
        label = 'مؤكد';
        break;
      case AppointmentStatus.completed:
        color = Colors.green;
        label = 'مكتمل';
        break;
      case AppointmentStatus.cancelled:
        color = Colors.red;
        label = 'ملغى';
        break;
      case AppointmentStatus.rescheduled:
        color = Colors.purple;
        label = 'مُجدَّد';
        break;
      case AppointmentStatus.noShow:
        color = Colors.grey;
        label = 'غياب';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
