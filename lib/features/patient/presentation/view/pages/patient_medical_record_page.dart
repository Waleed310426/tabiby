// ============================================================
// ملف: features/patient/presentation/view/pages/patient_medical_record_page.dart
// الوصف: صفحة السجل الطبي للمريض
// تعرض: الوصفات، نتائج التحاليل، التقارير الطبية، التطعيمات
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../../data/models/medical_record_model.dart';
import '../../manager/patient_provider.dart';

/// صفحة السجل الطبي الرقمي للمريض
class PatientMedicalRecordPage extends StatefulWidget {
  const PatientMedicalRecordPage({super.key});

  @override
  State<PatientMedicalRecordPage> createState() =>
      _PatientMedicalRecordPageState();
}

class _PatientMedicalRecordPageState extends State<PatientMedicalRecordPage> {
  @override
  void initState() {
    super.initState();
    // ─── جلب السجلات عند فتح الصفحة ──────────────────────────
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadMedicalRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملفي الطبي'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // ─── زر إضافة سجل يدوي ──────────────────────────
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة سجل',
            onPressed: () {
              // TODO: فتح نافذة إضافة سجل يدوي
            },
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, _) {
          // ─── حالة التحميل ─────────────────────────────────
          if (provider.isRecordsLoading) {
            return const LoadingIndicator(message: 'جارٍ جلب السجلات الطبية...');
          }

          // ─── حالة عدم وجود سجلات ──────────────────────────
          if (provider.medicalRecords.isEmpty) {
            return _buildEmptyState();
          }

          // ─── عرض السجلات ──────────────────────────────────
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.medicalRecords.length,
            itemBuilder: (context, index) {
              return _MedicalRecordCard(
                record: provider.medicalRecords[index],
              );
            },
          );
        },
      ),
    );
  }

  /// بناء حالة عدم وجود سجلات
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'لا توجد سجلات طبية بعد',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ستظهر هنا سجلاتك الطبية بعد زياراتك للأطباء',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: فتح نافذة إضافة سجل يدوي
            },
            icon: const Icon(Icons.add),
            label: const Text('إضافة سجل يدوي'),
          ),
        ],
      ),
    );
  }
}

// ─── بطاقة عرض السجل الطبي ───────────────────────────────────
class _MedicalRecordCard extends StatelessWidget {
  final MedicalRecordModel record;

  const _MedicalRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ─── أيقونة نوع السجل ──────────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getTypeColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getTypeIcon(), color: _getTypeColor()),
          ),
          const SizedBox(width: 16),

          // ─── معلومات السجل ────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTypeLabel(),
                  style: TextStyle(
                    color: _getTypeColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDate(record.recordDate),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),

          // ─── زر عرض التفاصيل ──────────────────────────────
          const Icon(Icons.chevron_left, color: Colors.grey),
        ],
      ),
    );
  }

  // ─── دوال مساعدة لنوع السجل ──────────────────────────────────

  IconData _getTypeIcon() {
    switch (record.recordType) {
      case RecordType.prescription:
        return Icons.medication_outlined;
      case RecordType.labResult:
        return Icons.science_outlined;
      case RecordType.radiologyReport:
        return Icons.image_search_outlined;
      case RecordType.vaccination:
        return Icons.vaccines_outlined;
      case RecordType.medicalReport:
        return Icons.description_outlined;
      case RecordType.manualEntry:
        return Icons.edit_note_outlined;
    }
  }

  Color _getTypeColor() {
    switch (record.recordType) {
      case RecordType.prescription:
        return Colors.blue;
      case RecordType.labResult:
        return Colors.green;
      case RecordType.radiologyReport:
        return Colors.orange;
      case RecordType.vaccination:
        return Colors.purple;
      case RecordType.medicalReport:
        return Colors.teal;
      case RecordType.manualEntry:
        return Colors.grey;
    }
  }

  String _getTypeLabel() {
    switch (record.recordType) {
      case RecordType.prescription:
        return 'وصفة طبية';
      case RecordType.labResult:
        return 'نتيجة تحليل';
      case RecordType.radiologyReport:
        return 'تقرير أشعة';
      case RecordType.vaccination:
        return 'تطعيم';
      case RecordType.medicalReport:
        return 'تقرير طبي';
      case RecordType.manualEntry:
        return 'إدخال يدوي';
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
