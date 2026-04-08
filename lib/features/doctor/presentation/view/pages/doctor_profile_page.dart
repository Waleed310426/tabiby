// ============================================================
// ملف: features/doctor/presentation/view/pages/doctor_profile_page.dart
// الوصف: صفحة ملف الطبيب الشخصي
// تعرض: البيانات المهنية، ساعات العمل، إعدادات الحساب
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';

/// صفحة ملف الطبيب الشخصي
class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملفي المهني'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // ─── زر تعديل الملف ──────────────────────────────
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: فتح صفحة تعديل الملف المهني
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ─── رأس الملف الشخصي ────────────────────────
                _buildProfileHeader(context, user?.fullName ?? 'د. الطبيب'),
                const SizedBox(height: 24),

                // ─── بطاقة المعلومات المهنية ──────────────────
                _buildInfoCard(context),
                const SizedBox(height: 16),

                // ─── قائمة الإعدادات ──────────────────────────
                _buildSettingsSection(context),
                const SizedBox(height: 24),

                // ─── زر تسجيل الخروج ──────────────────────────
                CustomButton(
                  text: 'تسجيل الخروج',
                  onPressed: () => _confirmLogout(context, auth),
                  backgroundColor: Colors.red.shade400,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.doctorColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 58,
                color: AppColors.doctorColor,
              ),
            ),
            // ─── زر تغيير الصورة ──────────────────────────
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.doctorColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'طبيب متخصص',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.doctorColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.doctorColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoStat(label: 'سنوات الخبرة', value: '5+'),
          const VerticalDivider(width: 1),
          _InfoStat(label: 'المرضى', value: '1.2K'),
          const VerticalDivider(width: 1),
          _InfoStat(label: 'التقييم', value: '4.8 ⭐'),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final options = [
      {'icon': Icons.schedule, 'title': 'ساعات العمل', 'subtitle': 'إدارة أوقات الاستقبال'},
      {'icon': Icons.videocam_outlined, 'title': 'الاستشارة عن بعد', 'subtitle': 'تفعيل / إيقاف'},
      {'icon': Icons.attach_money, 'title': 'رسوم الكشف', 'subtitle': 'تحديث الأسعار'},
      {'icon': Icons.notifications_outlined, 'title': 'الإشعارات', 'subtitle': 'إعدادات التنبيهات'},
      {'icon': Icons.help_outline, 'title': 'الدعم الفني', 'subtitle': 'تواصل معنا'},
    ];

    return Column(
      children: options.map((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              option['icon'] as IconData,
              color: AppColors.doctorColor,
            ),
            title: Text(option['title'] as String),
            subtitle: Text(
              option['subtitle'] as String,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              auth.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  final String label;
  final String value;

  const _InfoStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.doctorColor,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
