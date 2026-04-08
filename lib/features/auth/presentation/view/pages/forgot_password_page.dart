// ============================================================
// ملف: features/auth/presentation/view/pages/forgot_password_page.dart
// الوصف: صفحة استعادة كلمة المرور — تصميم احترافي RTL
//        أيقونة الإيميل في حقل الإدخال
// ============================================================

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _codeSent = false; // نجاح إرسال الرمز

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ─── خلفية التدرج ─────────────────────────────────
            _buildGradientHeader(size),

            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.05),

                    // ─── الرأس ────────────────────────────────
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: _buildHeader(context),
                    ),

                    SizedBox(height: size.height * 0.04),

                    // ─── بطاقة النموذج ────────────────────────
                    SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: _codeSent
                            ? _buildSuccessCard()
                            : _buildFormCard(),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── خلفية التدرج ────────────────────────────────────────────
  Widget _buildGradientHeader(Size size) {
    return Container(
      height: size.height * 0.42,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
            Color(0xFF1E88E5),
            Color(0xFF42A5F5),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
    );
  }

  // ─── الرأس: زر رجوع + أيقونة + عنوان ────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // زر الرجوع
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        // أيقونة القفل الكبيرة
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/app_logo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.primary,
                child: const Icon(Icons.local_hospital_rounded,
                    size: 50, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'استعادة كلمة المرور',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'أدخل بريدك الإلكتروني أو رقم هاتفك\nوسنرسل لك رمز التحقق',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontFamily: 'Cairo',
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // ─── بطاقة النموذج ───────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── عنوان البطاقة ────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'أدخل معلوماتك للتحقق',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── حقل الإيميل / الهاتف ─────────────────────────
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني أو رقم الهاتف',
                labelStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                floatingLabelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                // أيقونة الإيميل في اليمين (RTL)
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F9FC),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.error, width: 2),
                ),
                errorStyle:
                    const TextStyle(fontFamily: 'Cairo', fontSize: 12),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // ─── زر إرسال الرمز ───────────────────────────────
            _buildSendButton(),
            const SizedBox(height: 20),

            // ─── رابط الرجوع لتسجيل الدخول ────────────────────
            _buildBackToLoginRow(),
          ],
        ),
      ),
    );
  }

  // ─── زر إرسال رمز التحقق ─────────────────────────────────────
  Widget _buildSendButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onSendCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'إرسال رمز التحقق',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ─── رابط العودة لتسجيل الدخول ───────────────────────────────
  Widget _buildBackToLoginRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'تذكرت كلمة المرور؟',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text(
              ' تسجيل الدخول',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── بطاقة نجاح الإرسال ──────────────────────────────────────
  Widget _buildSuccessCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // أيقونة التأكيد
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 45,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'تم الإرسال بنجاح!',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'تم إرسال رمز التحقق إلى\n${_emailController.text}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          // زر العودة لتسجيل الدخول
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'العودة لتسجيل الدخول',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // إعادة الإرسال
          TextButton(
            onPressed: () => setState(() {
              _codeSent = false;
              _emailController.clear();
            }),
            child: const Text(
              'إعادة الإرسال',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── تنفيذ إرسال رمز التحقق ──────────────────────────────────
  Future<void> _onSendCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: استدعاء API لإرسال رمز التحقق
    await Future.delayed(const Duration(seconds: 2)); // محاكاة

    if (mounted) {
      setState(() {
        _isLoading = false;
        _codeSent = true;
      });
    }
  }
}
