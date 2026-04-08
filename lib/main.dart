// ============================================================
// ملف: main.dart
// الوصف: نقطة البداية الرئيسية لتطبيق طبيبي
// يقوم هذا الملف بتهيئة Firebase وإعداد موفري الحالة
// ثم تشغيل التطبيق بإعدادات الثيم واللغة العربية
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ─── استيراد Firebase ────────────────────────────────────────
import 'package:firebase_core/firebase_core.dart';

// ─── استيراد إدارة الحالة ──────────────────────────────────
import 'package:provider/provider.dart';

// ─── استيراد google_fonts لدعم خط Cairo العربي ─────────────
import 'package:google_fonts/google_fonts.dart';

// ─── استيراد ملف الثيم المستقل ──────────────────────────────
import 'core/theme/app_theme.dart';

// ─── المهام والمصادقة ─────────────────────────────────────────
import 'core/network/api_client.dart';
import 'features/auth/data/manage/auth_remote_data_source.dart';
import 'features/auth/data/repo/auth_repo_impl.dart';
import 'features/auth/presentation/manager/auth_provider.dart';
import 'features/auth/presentation/view/pages/login_page.dart';

// ─── النقطة الرئيسية لبدء التطبيق ──────────────────────────
void main() async {
  // التأكد من تهيئة Flutter Bindings قبل أي عملية async
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase (يجب أن تكون أول عملية async)
  // await Firebase.initializeApp(); // تم إيقافه مؤقتاً لتخطي خطأ הWeb

  // ─── إيقاف تحميل الخطوط من الإنترنت ───────────────────────
  // ملاحظة: لا نوقف runtime fetching لأن google_fonts يحتاج
  // مسار خاص لملفاته - الخطوط المحلية معرّفة في pubspec.yaml

  // تثبيت اتجاه الشاشة عمودياً فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تشغيل التطبيق
  runApp(const TabibiApp());
}

// ─── الكلاس الجذر للتطبيق ────────────────────────────────────
class TabibiApp extends StatelessWidget {
  const TabibiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ─── إعداد الاعتماديات الأساسية مؤقتاً ─────────────────────
    final apiClient = ApiClient();
    final authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
    final authRepoImpl = AuthRepoImpl(remoteDataSource: authRemoteDataSource);

    // MultiProvider: يجمع جميع موفري الحالة في مكان واحد
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo: authRepoImpl),
        ),
      ],
      child: MaterialApp(
        // ─── إعدادات التطبيق الأساسية ─────────────────────
        title: 'طبيبي — Tabibi',
        debugShowCheckedModeBanner: false, // إخفاء شريط "Debug"

        // ─── إعداد اللغة والاتجاه ──────────────────────────
        locale: const Locale('ar', 'YE'), // اللغة العربية - اليمن
        supportedLocales: const [
          Locale('ar', 'YE'), // العربية اليمنية
          Locale('ar'),       // العربية العامة
          Locale('en'),       // الإنجليزية
        ],

        // ─── إعداد مندوبي الترجمة (مطلوب لـ TextField) ────
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // ─── إعداد الثيم الرئيسي (الوضع النهاري) ──────────
        // يُرجع إعدادات الثيم من ملف app_theme.dart
        theme: AppTheme.light,

        // ─── إعداد الثيم الداكن (الوضع الليلي) ─────────────
        darkTheme: AppTheme.dark,

        // ─── الشاشة الافتراضية عند فتح التطبيق ─────────────
        home: const LoginPage(),
      ),
    );
  }

  // تمت إزالة _buildLightTheme و _buildDarkTheme
  // الثيم الآن مُعرَّف في: lib/core/theme/app_theme.dart
}

// ─── شاشة مؤقتة حتى اكتمال الشاشات الحقيقية ──────────────
// TODO: حذف هذه الشاشة عند إنشاء شاشة Splash الحقيقية
class _TabibiPlaceholderScreen extends StatelessWidget {
  const _TabibiPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة التطبيق المؤقتة
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_hospital,
                size: 70,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 32),

            // اسم التطبيق
            Text(
              'طبيبي',
              style: GoogleFonts.cairo(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // الشعار الفرعي
            Text(
              'رعايتك أولويتنا',
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 60),

            // مؤشر التحميل
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),

            Text(
              'جارٍ التحميل...',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
