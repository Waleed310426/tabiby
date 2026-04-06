// ============================================================
// ملف: widget_test.dart
// الوصف: ملف اختبار الواجهات الأساسي لتطبيق طبيبي
// يحتوي على اختبارات بسيطة للتحقق من أن التطبيق يعمل بشكل صحيح
//
// ملاحظة: هذا المجلد (test/) خُصّص لاختبارات Flutter
//   - unit tests: اختبار الدوال والكلاسات بشكل منفرد
//   - widget tests: اختبار واجهات المستخدم
//   - integration tests: اختبار التكامل بين الأجزاء
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tabiby/main.dart';

void main() {
  // ─── اختبار تشغيل التطبيق بنجاح ─────────────────────────
  testWidgets('التأكد من أن تطبيق طبيبي يبدأ بدون أخطاء',
      (WidgetTester tester) async {
    // بناء شجرة الواجهات وتحميل التطبيق
    await tester.pumpWidget(const TabibyApp());

    // التحقق من أن التطبيق يعرض واجهة ما بدون انهيار
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
