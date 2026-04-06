// ============================================================
// ملف: ambulance_model.dart
// الوصف: نموذج بيانات سيارة الإسعاف في تطبيق طبيبي
// يُمثّل سيارة إسعاف مسجلة في نظام الطوارئ
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

// ─── حالة سيارة الإسعاف ─────────────────────────────────────
enum AmbulanceStatus {
  available,  // متاحة وجاهزة للإرسال
  busy,       // مشغولة في بلاغ حالي
  offline,    // خارج الخدمة
  maintenance,// في الصيانة
}

// ─── النموذج الرئيسي لسيارة الإسعاف ─────────────────────────
class AmbulanceModel {
  final String id;              // معرّف سيارة الإسعاف الفريد
  final String vehicleNumber;   // رقم لوحة السيارة
  final String driverName;      // اسم السائق / المسعف
  final String driverPhone;     // رقم هاتف السائق
  final double currentLatitude; // الموقع الحالي - خط العرض
  final double currentLongitude;// الموقع الحالي - خط الطول
  final AmbulanceStatus status; // الحالة الراهنة لسيارة الإسعاف
  final String? currentReportId;// معرّف البلاغ الذي تُعالجه حالياً
  final DateTime lastUpdated;   // آخر تحديث للموقع والحالة

  const AmbulanceModel({
    required this.id,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverPhone,
    required this.currentLatitude,
    required this.currentLongitude,
    this.status = AmbulanceStatus.available,
    this.currentReportId,
    required this.lastUpdated,
  });

  // ─── تحويل إلى Map لحفظه في Firestore ────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicle_number': vehicleNumber,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'status': status.name,
      'current_report_id': currentReportId,
      'last_updated': Timestamp.fromDate(lastUpdated),
    };
  }

  // ─── إنشاء النموذج من Firestore ─────────────────────────
  factory AmbulanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AmbulanceModel(
      id: doc.id,
      vehicleNumber: data['vehicle_number'] ?? '',
      driverName: data['driver_name'] ?? '',
      driverPhone: data['driver_phone'] ?? '',
      currentLatitude: (data['current_latitude'] ?? 0.0).toDouble(),
      currentLongitude: (data['current_longitude'] ?? 0.0).toDouble(),
      status: AmbulanceStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => AmbulanceStatus.offline,
      ),
      currentReportId: data['current_report_id'],
      lastUpdated: (data['last_updated'] as Timestamp).toDate(),
    );
  }

  // ─── تحديث الموقع الجغرافي للسيارة ──────────────────────
  AmbulanceModel updateLocation({
    required double lat,
    required double lng,
  }) {
    return AmbulanceModel(
      id: id,
      vehicleNumber: vehicleNumber,
      driverName: driverName,
      driverPhone: driverPhone,
      currentLatitude: lat,
      currentLongitude: lng,
      status: status,
      currentReportId: currentReportId,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'AmbulanceModel(id: $id, vehicle: $vehicleNumber, status: ${status.name})';
}
