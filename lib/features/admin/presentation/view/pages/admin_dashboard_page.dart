// ============================================================
// ملف: features/admin/presentation/view/pages/admin_dashboard_page.dart
// الوصف: لوحة تحكم الأدمن (الإدارة العليا)
// تعرض: الإحصائيات الكاملة، الأطباء المنتظرون، تقارير النظام
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../data/models/doctor_model.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../manager/admin_provider.dart';

/// لوحة تحكم الأدمن - نقطة الدخول لصفحات الإدارة
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _AdminHomeTab(),
    const _PendingDoctorsTab(),
    const _AdminSettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppColors.adminColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'الأطباء',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

// ─── تاب الرئيسية ─────────────────────────────────────────────
class _AdminHomeTab extends StatelessWidget {
  const _AdminHomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AdminProvider>(
          builder: (context, admin, _) {
            return CustomScrollView(
              slivers: [
                // ─── هيدر الأدمن ────────────────────────────
                SliverToBoxAdapter(
                  child: _buildHeader(context),
                ),

                // ─── بطاقات الإحصائيات ───────────────────────
                SliverToBoxAdapter(
                  child: admin.isLoading
                      ? const LoadingIndicator(fullScreen: false)
                      : _buildStatsGrid(context, admin),
                ),

                // ─── عنوان القسم ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'أطباء بانتظار الموافقة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (admin.pendingDoctors.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${admin.pendingDoctors.length} طلب',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ─── قائمة الأطباء المنتظرون ─────────────────
                _buildPendingDoctors(context, admin),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.adminColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لوحة الإدارة العليا',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      'مرحباً، مدير النظام 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // ─── أيقونة الإشعارات ──────────────────────
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ─── شريط البحث ──────────────────────────────────
          TextField(
            decoration: InputDecoration(
              hintText: 'بحث عن مستخدم أو طبيب...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, AdminProvider admin) {
    final stats = [
      {
        'label': 'إجمالي المستخدمين',
        'value': admin.stats['totalUsers'].toString(),
        'icon': Icons.people,
        'color': AppColors.adminColor,
      },
      {
        'label': 'طلبات معلقة',
        'value': admin.pendingDoctors.length.toString(),
        'icon': Icons.pending_actions,
        'color': Colors.orange,
      },
      {
        'label': 'المواعيد اليوم',
        'value': '---',
        'icon': Icons.calendar_today,
        'color': Colors.blue,
      },
      {
        'label': 'إيرادات الشهر',
        'value': '---',
        'icon': Icons.attach_money,
        'color': Colors.green,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return _AdminStatCard(
            label: stat['label'] as String,
            value: stat['value'] as String,
            icon: stat['icon'] as IconData,
            color: stat['color'] as Color,
          );
        },
      ),
    );
  }

  Widget _buildPendingDoctors(BuildContext context, AdminProvider admin) {
    if (admin.pendingDoctors.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 64, color: Colors.green),
                SizedBox(height: 12),
                Text('لا توجد طلبات معلقة حالياً 🎉'),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final doctor = admin.pendingDoctors[index];
          return _PendingDoctorCard(
            doctor: doctor,
            onApprove: () => admin.approveDoctor(doctor.id),
            onReject: () => admin.rejectDoctor(doctor.id),
          );
        },
        childCount: admin.pendingDoctors.length,
      ),
    );
  }
}

// ─── تاب الأطباء المعلقون ─────────────────────────────────────
class _PendingDoctorsTab extends StatelessWidget {
  const _PendingDoctorsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الأطباء'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, admin, _) {
          if (admin.isLoading) {
            return const LoadingIndicator(message: 'جارٍ التحميل...');
          }
          if (admin.pendingDoctors.isEmpty) {
            return const Center(
              child: Text('لا توجد طلبات أطباء معلقة'),
            );
          }
          return ListView.builder(
            itemCount: admin.pendingDoctors.length,
            itemBuilder: (context, index) {
              final doctor = admin.pendingDoctors[index];
              return _PendingDoctorCard(
                doctor: doctor,
                onApprove: () => admin.approveDoctor(doctor.id),
                onReject: () => admin.rejectDoctor(doctor.id),
              );
            },
          );
        },
      ),
    );
  }
}

// ─── تاب الإعدادات ────────────────────────────────────────────
class _AdminSettingsTab extends StatelessWidget {
  const _AdminSettingsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsTile(
            icon: Icons.people_outline,
            title: 'إدارة المستخدمين',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.bar_chart,
            title: 'التقارير والإحصائيات',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'الإشعارات الجماعية',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.policy_outlined,
            title: 'السياسات والشروط',
            onTap: () {},
          ),
          const Divider(height: 32),
          // ─── زر تسجيل الخروج ──────────────────────────────
          ElevatedButton.icon(
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text('تسجيل الخروج'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── بطاقة طبيب معلق ─────────────────────────────────────────
class _PendingDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final Future<bool> Function() onApprove;
  final Future<bool> Function() onReject;

  const _PendingDoctorCard({
    required this.doctor,
    required this.onApprove,
    required this.onReject,
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
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.doctorColor.withValues(alpha: 0.1),
                child: const Icon(Icons.person, color: AppColors.doctorColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. ${doctor.fullName.isNotEmpty ? doctor.fullName : 'طبيب جديد'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // ─── شارة "انتظار" ─────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'انتظار موافقة',
                  style: TextStyle(color: Colors.orange, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ─── معلومات إضافية ────────────────────────────
          Text(
            'رقم الترخيص: ${doctor.medicalLicenseNumber}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            'سنوات الخبرة: ${doctor.yearsOfExperience}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // ─── أزرار الموافقة والرفض ────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('رفض'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.doctorColor,
                  ),
                  child: const Text('موافقة'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// بطاقة إحصائية للأدمن
class _AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// عنصر في قائمة إعدادات الأدمن
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.adminColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_left, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
