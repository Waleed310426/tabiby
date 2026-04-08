// ============================================================
// ملف: features/patient/presentation/view/pages/patient_home_page.dart
// الوصف: الصفحة الرئيسية لتطبيق المريض
// تعرض: الخدمات الرئيسية، الأطباء المميزين، المقالات الصحية
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/loading_indicator.dart';
import '../../manager/patient_provider.dart';
import '../widgets/doctor_card_widget.dart';
import 'patient_search_page.dart';
import 'patient_appointments_page.dart';
import 'patient_medical_record_page.dart';
import 'patient_profile_page.dart';

/// الصفحة الرئيسية لتطبيق المريض
class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  // ─── الفهرس الحالي لشريط التنقل السفلي ─────────────────────
  int _currentIndex = 0;

  // ─── صفحات شريط التنقل السفلي ────────────────────────────────
  final List<Widget> _pages = [
    const _HomeTab(),
    const PatientSearchPage(),
    const PatientAppointmentsPage(),
    const PatientMedicalRecordPage(),
    const PatientProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // ─── جلب الأطباء عند فتح الصفحة ─────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ─── عرض الصفحة المختارة ──────────────────────────────
      body: _pages[_currentIndex],

      // ─── شريط التنقل السفلي ───────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'البحث',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'مواعيدي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'ملفي',
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

// ─── تاب الصفحة الرئيسية (Home Tab) ──────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── شريط العنوان العلوي ────────────────────────
            SliverToBoxAdapter(child: _buildHeader(context)),

            // ─── قسم الخدمات الرئيسية ─────────────────────
            SliverToBoxAdapter(child: _buildServiceCategories(context)),

            // ─── عنوان قسم الأطباء ───────────────────────
            SliverToBoxAdapter(child: _buildSectionTitle(context, 'أطباء مميزون')),

            // ─── قائمة الأطباء ────────────────────────────
            _buildDoctorsList(),
          ],
        ),
      ),
    );
  }

  // ─── الجزء العلوي (التحية وشريط البحث) ──────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── جملة الترحيب ────────────────────────────────
          const Text(
            'مرحباً 👋',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Text(
            'كيف يمكننا مساعدتك اليوم؟',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // ─── شريط البحث ──────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن طبيب أو تخصص...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── الخدمات الرئيسية ────────────────────────────────────────
  Widget _buildServiceCategories(BuildContext context) {
    final services = [
      {'icon': Icons.calendar_today, 'label': 'حجز موعد', 'color': Colors.blue},
      {'icon': Icons.video_call, 'label': 'استشارة', 'color': Colors.green},
      {'icon': Icons.folder_shared, 'label': 'ملفي الطبي', 'color': Colors.orange},
      {'icon': Icons.article_outlined, 'label': 'مقالات', 'color': Colors.purple},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'الخدمات الرئيسية', showViewAll: false),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: services.map((service) {
              return _ServiceButton(
                icon: service['icon'] as IconData,
                label: service['label'] as String,
                color: service['color'] as Color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── عنوان القسم ─────────────────────────────────────────────
  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    bool showViewAll = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: () {},
              child: const Text('عرض الكل'),
            ),
        ],
      ),
    );
  }

  // ─── قائمة الأطباء ───────────────────────────────────────────
  Widget _buildDoctorsList() {
    return Consumer<PatientProvider>(
      builder: (context, provider, _) {
        // ─── حالة التحميل ─────────────────────────────────────
        if (provider.isDoctorsLoading) {
          return const SliverToBoxAdapter(
            child: LoadingIndicator(
              message: 'جارٍ جلب الأطباء...',
              fullScreen: false,
            ),
          );
        }

        // ─── حالة عدم وجود أطباء ──────────────────────────────
        if (provider.doctors.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('لا يوجد أطباء متاحون حالياً'),
              ),
            ),
          );
        }

        // ─── عرض الأطباء ──────────────────────────────────────
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => DoctorCardWidget(
              doctor: provider.doctors[index],
              onTap: () {
                // TODO: الانتقال لصفحة تفاصيل الطبيب
              },
            ),
            childCount: provider.doctors.length,
          ),
        );
      },
    );
  }
}

// ─── زر الخدمة الرئيسية ──────────────────────────────────────
class _ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ServiceButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
