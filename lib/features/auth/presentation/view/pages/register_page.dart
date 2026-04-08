// ============================================================
// ملف: features/auth/presentation/view/pages/register_page.dart
// الوصف: صفحة إنشاء حساب جديد — تصميم احترافي RTL
//        أيقونات لكل حقل + عين لكلمة المرور
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../manager/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // ─── متحكمات الحقول ─────────────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _selectedRole = 'Patient';

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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    SizedBox(height: size.height * 0.04),

                    // ─── شعار + عنوان ─────────────────────────
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: _buildHeader(),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // ─── بطاقة النموذج ────────────────────────
                    SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: _buildFormCard(context),
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
      height: size.height * 0.38,
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

  // ─── الرأس: شعار + عنوان ─────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // زر الرجوع
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Builder(builder: (ctx) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(ctx),
              );
            }),
          ),
        ),

        // الشعار
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 25,
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
                    size: 44, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        const Text(
          'أنشئ حسابك الجديد',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'انضم إلى مجتمع طبيبي',
          style: TextStyle(
            fontSize: 13,
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
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
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
            // ─── اختيار الدور ────────────────────────────────
            _buildRoleSelector(),
            const SizedBox(height: 20),

            // ─── الاسم الكامل ─────────────────────────────────
            _buildField(
              controller: _nameController,
              label: 'الاسم الكامل',
              icon: Icons.person_outline_rounded,
              keyboard: TextInputType.name,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'يرجى إدخال الاسم الكامل' : null,
            ),
            const SizedBox(height: 14),

            // ─── الإيميل ──────────────────────────────────────
            _buildField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              icon: Icons.email_outlined,
              keyboard: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                if (!v.contains('@')) return 'بريد إلكتروني غير صحيح';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ─── رقم الهاتف ───────────────────────────────────
            _buildField(
              controller: _phoneController,
              label: 'رقم الهاتف',
              icon: Icons.smartphone_outlined,
              keyboard: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.length < 9) ? 'رقم هاتف غير صالح' : null,
            ),
            const SizedBox(height: 14),

            // ─── كلمة المرور ──────────────────────────────────
            _buildPasswordField(
              controller: _passwordController,
              label: 'كلمة المرور',
              obscure: _obscurePassword,
              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                if (v.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ─── تأكيد كلمة المرور ────────────────────────────
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'تأكيد كلمة المرور',
              obscure: _obscureConfirm,
              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى تأكيد كلمة المرور';
                if (v != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ─── رسالة خطأ ────────────────────────────────────
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.errorMessage != null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            auth.errorMessage!,
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
                return const SizedBox.shrink();
              },
            ),

            // ─── زر إنشاء الحساب ──────────────────────────────
            Consumer<AuthProvider>(
              builder: (context, auth, _) => _buildRegisterButton(auth),
            ),
            const SizedBox(height: 20),

            // ─── فاصل "أو" ────────────────────────────────────
            _buildDivider(),
            const SizedBox(height: 16),

            // ─── أزرار التسجيل الاجتماعي ──────────────────────
            _buildSocialButtons(),
            const SizedBox(height: 20),

            // ─── رابط تسجيل الدخول ────────────────────────────
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لديك حساب بالفعل؟',
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
            ),
          ],
        ),
      ),
    );
  }

  // ─── محدد الدور ──────────────────────────────────────────────
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أنت:',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _roleChip('Patient', 'مريض', Icons.person_rounded),
            const SizedBox(width: 12),
            _roleChip('Doctor', 'طبيب', Icons.medical_services_rounded),
          ],
        ),
      ],
    );
  }

  Widget _roleChip(String value, String label, IconData icon) {
    final isSelected = _selectedRole == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── حقل نص عادي ─────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: _inputDecoration(label: label, icon: icon),
      validator: validator,
    );
  }

  // ─── حقل كلمة مرور ───────────────────────────────────────────
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: _inputDecoration(
        label: label,
        icon: Icons.lock_outlined,
        suffixWidget: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 22,
          ),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }

  // ─── ديكور حقل الإدخال ───────────────────────────────────────
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

  // ─── زر إنشاء الحساب ─────────────────────────────────────────
  Widget _buildRegisterButton(AuthProvider auth) {
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
        onPressed: auth.isLoading ? null : _onRegister,
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
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Text(
                'إنشاء الحساب',
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
            'أو تسجّل بـ',
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
        _socialBtn(Icons.facebook_rounded, const Color(0xFF1877F2), 'Facebook'),
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
          width: 66,
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

  Widget _socialBtn(IconData icon, Color color, String label) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 66,
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

  // ─── تنفيذ التسجيل ───────────────────────────────────────────
  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.register(
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (authProvider.isAuthenticated && mounted) {
      Navigator.pop(context);
    }
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
