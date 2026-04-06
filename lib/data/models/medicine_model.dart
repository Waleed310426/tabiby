// ============================================================
// ملف: medicine_model.dart
// الوصف: نموذج بيانات الدواء في تطبيق طبيبي
//
// له استخدامان رئيسيان:
//   1. قاعدة بيانات الأدوية — لاقتراحات البحث التلقائي عند
//      كتابة الوصفة الطبية (شاشة الطبيب)
//   2. مخزون الصيدلية — لمتابعة الكميات وتنبيهات النفاذ
//      (لوحة تحكم الصيدلية)
//
// أصحاب المصلحة المرتبطون:
//   🩺 الطبيب    ← البحث عن الأدوية عند كتابة الوصفة
//   💊 الصيدلية  ← إدارة المخزون والسعر والكميات
//   🛡️ الأدمن   ← إدارة قاعدة بيانات الأدوية
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── تصنيف الدواء حسب الوصفة ────────────────────────────────
enum MedicinePrescriptionType {
  prescription, // يستلزم وصفة طبية
  otc,          // متاح بدون وصفة (Over The Counter)
}

// ─── شكل الدواء ─────────────────────────────────────────────
enum MedicineDosageForm {
  tablet,    // أقراص
  capsule,   // كبسولات
  syrup,     // شراب
  injection, // حقن
  cream,     // كريم موضعي
  drops,     // قطرات
  inhaler,   // بخاخ
  patch,     // لصقة
  powder,    // مسحوق
  other,     // أخرى
}

// ─── النموذج الرئيسي للدواء ──────────────────────────────────
class MedicineModel {
  final String id;                          // معرّف الدواء الفريد
  final String nameAr;                      // الاسم التجاري بالعربية
  final String nameEn;                      // الاسم التجاري بالإنجليزية
  final String genericName;                 // الاسم العلمي (Generic Name)
  final String manufacturer;                // الشركة المصنّعة
  final MedicineDosageForm dosageForm;      // شكل الدواء (قرص، شراب...)
  final String strength;                    // التركيز (مثال: \"500mg\"، \"250mg/5ml\")
  final String? description;               // وصف الدواء ودواعي الاستعمال
  final List<String> activeIngredients;    // المواد الفعّالة
  final List<String> sideEffects;          // الآثار الجانبية الشائعة
  final List<String> contraindications;    // موانع الاستعمال
  final MedicinePrescriptionType prescriptionType; // هل يحتاج وصفة؟
  final bool isActive;                     // هل هو متاح في النظام؟
  final String? imageUrl;                  // صورة الدواء (اختياري)

  const MedicineModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.genericName,
    required this.manufacturer,
    required this.dosageForm,
    required this.strength,
    this.description,
    this.activeIngredients = const [],
    this.sideEffects = const [],
    this.contraindications = const [],
    this.prescriptionType = MedicinePrescriptionType.prescription,
    this.isActive = true,
    this.imageUrl,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'generic_name': genericName,
      'manufacturer': manufacturer,
      'dosage_form': dosageForm.name,
      'strength': strength,
      'description': description,
      'active_ingredients': activeIngredients,
      'side_effects': sideEffects,
      'contraindications': contraindications,
      'prescription_type': prescriptionType.name,
      'is_active': isActive,
      'image_url': imageUrl,
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory MedicineModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicineModel(
      id: doc.id,
      nameAr: data['name_ar'] ?? '',
      nameEn: data['name_en'] ?? '',
      genericName: data['generic_name'] ?? '',
      manufacturer: data['manufacturer'] ?? '',
      dosageForm: MedicineDosageForm.values.firstWhere(
        (f) => f.name == data['dosage_form'],
        orElse: () => MedicineDosageForm.tablet,
      ),
      strength: data['strength'] ?? '',
      description: data['description'],
      activeIngredients:
          List<String>.from(data['active_ingredients'] ?? []),
      sideEffects: List<String>.from(data['side_effects'] ?? []),
      contraindications:
          List<String>.from(data['contraindications'] ?? []),
      prescriptionType: MedicinePrescriptionType.values.firstWhere(
        (p) => p.name == data['prescription_type'],
        orElse: () => MedicinePrescriptionType.prescription,
      ),
      isActive: data['is_active'] ?? true,
      imageUrl: data['image_url'],
    );
  }

  // ─── إرجاع الاسم حسب لغة التطبيق ──────────────────────
  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  @override
  String toString() =>
      'MedicineModel(id: $id, nameAr: $nameAr, form: ${dosageForm.name})';
}

// ============================================================
// نموذج مخزون الدواء في صيدلية معينة
// يُمثّل الكمية المتوفرة من دواء معين في صيدلية محددة
// ============================================================
class PharmacyInventoryModel {
  final String id;              // معرّف سجل المخزون الفريد
  final String pharmacyId;     // معرّف الصيدلية
  final String medicineId;     // معرّف الدواء (مرتبط بـ MedicineModel)
  final String medicineName;   // اسم الدواء (لسرعة القراءة)
  final int quantityInStock;   // الكمية المتوفرة حالياً
  final int lowStockThreshold; // حد التنبيه عند قرب النفاذ
  final double sellingPrice;   // سعر البيع في هذه الصيدلية
  final DateTime? expiryDate;  // تاريخ انتهاء الصلاحية
  final DateTime lastUpdated;  // تاريخ آخر تحديث للمخزون

  const PharmacyInventoryModel({
    required this.id,
    required this.pharmacyId,
    required this.medicineId,
    required this.medicineName,
    required this.quantityInStock,
    this.lowStockThreshold = 10, // تنبيه عند وصول المخزون لـ 10 قطع
    required this.sellingPrice,
    this.expiryDate,
    required this.lastUpdated,
  });

  // هل المخزون منخفض ويحتاج تجديداً؟
  bool get isLowStock => quantityInStock <= lowStockThreshold;

  // هل الدواء نافذ من المخزون؟
  bool get isOutOfStock => quantityInStock <= 0;

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pharmacy_id': pharmacyId,
      'medicine_id': medicineId,
      'medicine_name': medicineName,
      'quantity_in_stock': quantityInStock,
      'low_stock_threshold': lowStockThreshold,
      'selling_price': sellingPrice,
      'expiry_date':
          expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'last_updated': Timestamp.fromDate(lastUpdated),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory PharmacyInventoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PharmacyInventoryModel(
      id: doc.id,
      pharmacyId: data['pharmacy_id'] ?? '',
      medicineId: data['medicine_id'] ?? '',
      medicineName: data['medicine_name'] ?? '',
      quantityInStock: data['quantity_in_stock'] ?? 0,
      lowStockThreshold: data['low_stock_threshold'] ?? 10,
      sellingPrice: (data['selling_price'] ?? 0.0).toDouble(),
      expiryDate: data['expiry_date'] != null
          ? (data['expiry_date'] as Timestamp).toDate()
          : null,
      lastUpdated: (data['last_updated'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() =>
      'PharmacyInventoryModel(medicine: $medicineName, qty: $quantityInStock, lowStock: $isLowStock)';
}
