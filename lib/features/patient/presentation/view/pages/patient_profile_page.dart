// ============================================================
// ملف: features/patient/presentation/view/pages/patient_profile_page.dart
// الوصف: صفحة الملف الشخصي للمريض
// تعرض: بيانات المريض، الإعدادات، خيار تسجيل الخروج
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';

/// صفحة الملف الشخصي للمريض
class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حسابي'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ─── بيانات المريض ────────────────────────────
                _buildProfileHeader(context, user?.fullName ?? 'المريض'),
                const SizedBox(height: 32),

                // ─── قسم قائمة الإعدادات ──────────────────────
                _buildSettingsSection(context),
                const SizedBox(height: 32),

                // ─── زر تسجيل الخروج ──────────────────────────
                CustomButton(
                  text: 'تسجيل الخروج',
                  onPressed: () => _confirmLogout(context, authProvider),
                  backgroundColor: Colors.red.shade400,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── قسم بيانات المريض ───────────────────────────────────────
  Widget _buildProfileHeader(BuildContext context, String name) {
    return Column(
      children: [
        // ─── صورة المريض ─────────────────────────────────────
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.person,
            size: 56,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),

        // ─── اسم المريض ──────────────────────────────────────
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // ─── زر تعديل الملف الشخصي ───────────────────────────
        TextButton.icon(
          onPressed: () {
            // TODO: فتح صفحة تعديل الملف الشخصي
          },
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: const Text('تعديل الملف الشخصي'),
        ),
      ],
    );
  }

  // ─── قائمة خيارات الإعدادات ──────────────────────────────────
  Widget _buildSettingsSection(BuildContext context) {
    final options = [
      {'icon': Icons.family_restroom, 'title': 'ملفات العائلة', 'subtitle': 'إدارة ملفات أفراد عائلتك'},
      {'icon': Icons.notifications_outlined, 'title': 'الإشعارات', 'subtitle': 'إدارة تفضيلات الإشعارات'},
      {'icon': Icons.security, 'title': 'الخصوصية والأمان', 'subtitle': 'إعدادات كلمة المرور والأمان'},
      {'icon': Icons.language, 'title': 'اللغة', 'subtitle': 'العربية'},
      {'icon': Icons.help_outline, 'title': 'المساعدة والدعم', 'subtitle': 'الأسئلة الشائعة والتواصل معنا'},
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
              color: Theme.of(context).primaryColor,
            ),
            title: Text(option['title'] as String),
            subtitle: Text(
              option['subtitle'] as String,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_left, color: Colors.grey),
            onTap: () {
              // TODO: الانتقال لكل صفحة
            },
          ),
        );
      }).toList(),
    );
  }

  // ─── تأكيد تسجيل الخروج ──────────────────────────────────────
  void _confirmLogout(BuildContext context, AuthProvider authProvider) {
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
              authProvider.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
