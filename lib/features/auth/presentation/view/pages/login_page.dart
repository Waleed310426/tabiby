// ============================================================
// ملف: features/auth/presentation/view/pages/login_page.dart
// الوصف: صفحة تسجيل الدخول — تصميم احترافي RTL
//        أيقونة الإيميل + أيقونة العين لكلمة المرور
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/models/user_model.dart';
import '../../manager/auth_provider.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // ─── متحكمات الحقول ─────────────────────────────────────────
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            // ─── خلفية التدرج العلوي ──────────────────────────
            _buildGradientHeader(size),

            // ─── المحتوى الرئيسي ─────────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.06),

                    // ─── الشعار والعنوان ──────────────────────
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: _buildLogoSection(),
                    ),

                    SizedBox(height: size.height * 0.04),

                    // ─── بطاقة النموذج ────────────────────────
                    SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: _buildFormCard(context),
                      ),
                    ),

                    const SizedBox(height: 24),
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

  // ─── قسم الشعار والترحيب ─────────────────────────────────────
  Widget _buildLogoSection() {
    return Column(
      children: [
        // الشعار في دائرة مضيئة
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/app_logo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.primary,
                child: const Icon(
                  Icons.local_hospital_rounded,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // نص الترحيب
        const Text(
          'مرحباً بك في طبيبي',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'سجّل دخولك للمتابعة',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  // ─── بطاقة النموذج ───────────────────────────────────────────
  Widget _buildFormCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 0,
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
            // ─── حقل الإيميل ─────────────────────────────────
            _buildEmailField(),
            const SizedBox(height: 16),

            // ─── حقل كلمة المرور ──────────────────────────────
            _buildPasswordField(),
            const SizedBox(height: 12),

            // ─── تذكرني + نسيت كلمة المرور ─────────────────────
            _buildRememberAndForgot(context),
            const SizedBox(height: 24),

            // ─── رسالة الخطأ ──────────────────────────────────
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.errorMessage != null) {
                  return _buildErrorBox(auth.errorMessage!);
                }
                return const SizedBox.shrink();
              },
            ),

            // ─── زر تسجيل الدخول ──────────────────────────────
            Consumer<AuthProvider>(
              builder: (context, auth, _) => _buildLoginButton(auth),
            ),
            const SizedBox(height: 24),

            // ─── فاصل "أو" ────────────────────────────────────
            _buildDivider(),
            const SizedBox(height: 20),

            // ─── أزرار التسجيل الاجتماعي ──────────────────────
            _buildSocialButtons(),
            const SizedBox(height: 24),

            // ─── رابط إنشاء حساب ──────────────────────────────
            _buildRegisterLink(context),
          ],
        ),
      ),
    );
  }

  // ─── حقل الإيميل ─────────────────────────────────────────────
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: _inputDecoration(
        label: 'الإيميل أو رقم الهاتف',
        icon: Icons.email_outlined,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'يرجى إدخال الإيميل أو رقم الهاتف';
        return null;
      },
    );
  }

  // ─── حقل كلمة المرور ─────────────────────────────────────────
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: _inputDecoration(
        label: 'كلمة المرور',
        icon: Icons.lock_outlined,
        suffixWidget: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 22,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
        if (v.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        return null;
      },
    );
  }

  // ─── ديكور حقول الإدخال ──────────────────────────────────────
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixWidget,
  }) {
    return InputDecoration(
      labelText: label,
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
      // أيقونة في جهة اليمين (RTL = prefix يظهر على اليمين)
      prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
      suffixIcon: suffixWidget,
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      errorStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
    );
  }

  // ─── صف تذكرني + نسيت كلمة المرور ───────────────────────────
  Widget _buildRememberAndForgot(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // تذكرني (يمين في RTL)
        Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'تذكرني',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),

        // نسيت كلمة المرور (يسار في RTL)
        TextButton(
          onPressed: _onForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ─── صندوق خطأ ───────────────────────────────────────────────
  Widget _buildErrorBox(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── زر تسجيل الدخول ─────────────────────────────────────────
  Widget _buildLoginButton(AuthProvider auth) {
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
        onPressed: auth.isLoading ? null : _onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  // ─── فاصل "أو" ───────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'أو',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  // ─── أزرار التسجيل الاجتماعي ─────────────────────────────────
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _googleBtn(),
        const SizedBox(width: 16),
        _socialBtn(
          icon: Icons.apple,
          color: Colors.black,
          label: 'Apple',
        ),
        const SizedBox(width: 16),
        _socialBtn(
          icon: Icons.facebook_rounded,
          color: const Color(0xFF1877F2),
          label: 'Facebook',
        ),
      ],
    );
  }

  // ─── زر Google الحقيقي ───────────────────────────────────────
  Widget _googleBtn() {
    return Tooltip(
      message: 'Google',
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 62,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: _GoogleLogo(size: 26)),
        ),
      ),
    );
  }

  Widget _socialBtn({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 62,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
      ),
    );
  }

  // ─── رابط إنشاء حساب ─────────────────────────────────────────
  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        TextButton(
          onPressed: _onGoToRegister,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text(
            ' إنشاء حساب جديد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ─── دوال الأحداث ────────────────────────────────────────────

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(
      phoneNumber: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (authProvider.isAuthenticated && mounted) {
      _navigateBasedOnRole(authProvider);
    }
  }

  void _navigateBasedOnRole(AuthProvider authProvider) {
    final role = authProvider.currentUser?.role;
    switch (role) {
      case UserRole.patient:
        break;
      case UserRole.doctor:
        break;
      case UserRole.admin:
        break;
      case null:
        break;
    }
  }

  void _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
    );
  }

  void _onGoToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }
}

// ─── شعار Google الحقيقي الملوّن ─────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google_logo.svg',
      width: size,
      height: size,
    );
  }
}
