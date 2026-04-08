// ============================================================
// ملف: features/patient/presentation/view/pages/patient_search_page.dart
// الوصف: صفحة البحث والفلترة للمريض
// تتيح البحث عن الأطباء بالتخصص، الموقع، التقييم، السعر
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/loading_indicator.dart';
import '../../manager/patient_provider.dart';
import '../widgets/doctor_card_widget.dart';

/// صفحة البحث والفلترة للمريض
class PatientSearchPage extends StatefulWidget {
  const PatientSearchPage({super.key});

  @override
  State<PatientSearchPage> createState() => _PatientSearchPageState();
}

class _PatientSearchPageState extends State<PatientSearchPage> {
  // ─── متحكم البحث ────────────────────────────────────────────
  final _searchController = TextEditingController();

  // ─── قيم الفلاتر المختارة ────────────────────────────────────
  String? _selectedSpecialty;
  double _minRating = 0;

  // ─── تخصصات للفلترة ──────────────────────────────────────────
  final List<String> _specialties = [
    'الكل',
    'باطنية',
    'أطفال',
    'جلدية',
    'عظام',
    'قلب',
    'أسنان',
    'نساء وتوليد',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن طبيب'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // ─── شريط البحث ────────────────────────────────────
          _buildSearchBar(),

          // ─── أزرار التخصصات ────────────────────────────────
          _buildSpecialtiesFilter(),

          // ─── نتائج البحث ───────────────────────────────────
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  // ─── شريط البحث ──────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن طبيب أو تخصص...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterBottomSheet,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onChanged: (value) => _onSearch(),
      ),
    );
  }

  // ─── فلتر التخصصات ───────────────────────────────────────────
  Widget _buildSpecialtiesFilter() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _specialties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final specialty = _specialties[index];
          final isSelected = _selectedSpecialty == specialty ||
              (index == 0 && _selectedSpecialty == null);

          return ChoiceChip(
            label: Text(specialty),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedSpecialty = index == 0 ? null : specialty;
              });
              _onSearch();
            },
          );
        },
      ),
    );
  }

  // ─── نتائج البحث ─────────────────────────────────────────────
  Widget _buildResults() {
    return Consumer<PatientProvider>(
      builder: (context, provider, _) {
        if (provider.isDoctorsLoading) {
          return const LoadingIndicator(message: 'جارٍ البحث...');
        }

        if (provider.doctors.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('لا توجد نتائج للبحث'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: provider.doctors.length,
          itemBuilder: (context, index) => DoctorCardWidget(
            doctor: provider.doctors[index],
            onTap: () {
              // TODO: الانتقال لصفحة تفاصيل الطبيب
            },
          ),
        );
      },
    );
  }

  // ─── دوال الأحداث ────────────────────────────────────────────

  /// تنفيذ البحث بالفلاتر المختارة
  void _onSearch() {
    context.read<PatientProvider>().loadDoctors(
          specialty: _selectedSpecialty,
          minRating: _minRating > 0 ? _minRating : null,
        );
  }

  /// فتح نافذة الفلاتر المتقدمة
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'فلاتر البحث',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),

            // ─── فلتر التقييم ─────────────────────────────────
            const Text('الحد الأدنى للتقييم'),
            Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _minRating.toString(),
              onChanged: (value) => setState(() => _minRating = value),
            ),
            const SizedBox(height: 16),

            // ─── زر تطبيق الفلاتر ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _onSearch();
                },
                child: const Text('تطبيق الفلاتر'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
