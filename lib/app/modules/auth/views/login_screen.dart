import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background Gradient Orbs ──
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.2),
                    AppColors.secondary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // ── Main Content ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // ── Logo Section ──
                    Center(
                      child: Column(
                        children: [
                          // ── Animated Logo Container ──
                          Container(
                            width: 120,
                            height: 120,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(32),
                            //   gradient: const LinearGradient(
                            //     colors: AppColors.primaryGradient,
                            //     begin: Alignment.topLeft,
                            //     end: Alignment.bottomRight,
                            //   ),
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: AppColors.primary.withValues(alpha: 0.4),
                            //       blurRadius: 30,
                            //       offset: const Offset(0, 15),
                            //       spreadRadius: -5,
                            //     ),
                            //   ],
                            // ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  'assets/logo/logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.restaurant_rounded,
                                      size: 60,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ── App Name ──
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: AppColors.primaryGradient,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'Lao Food',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ── Tagline ──
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'ສົ່ງອາຫານເຖິງບ່ອນ',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // ── Welcome Text ──
                    const Text(
                      'ຍິນດີຕ້ອນຮັບກັບ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ກະລຸນາເຂົ້າສູ່ລະບົບເພື່ອສືບຕໍ່',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Email Input ──
                    _buildInputLabel('ອີເມລ'),
                    const SizedBox(height: 10),
                    AppInput(
                      controller: controller.emailController,
                      hint: 'example@mail.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Helpers.validateEmail,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 24),

                    // ── Password Input ──
                    _buildInputLabel('ລະຫັດຜ່ານ'),
                    const SizedBox(height: 10),
                    Obx(
                      () => AppInput(
                        controller: controller.passwordController,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: controller.obscurePassword.value,
                        validator: Helpers.validatePassword,
                        textInputAction: TextInputAction.done,
                        suffix: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textHint,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Forgot Password ──
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.resetPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'ລືມລະຫັດຜ່ານ?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Login Button ──
                    Obx(
                      () => AppButton(
                        text: 'ເຂົ້າສູ່ລະບົບ',
                        onPressed: controller.login,
                        isLoading: controller.isLoading.value,
                        isGradient: true,
                        height: 58,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Divider ──
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, AppColors.divider],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'ຫຼືເຂົ້າສູ່ລະບົບດ້ວຍ',
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.divider, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Social Login Buttons ──
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              'Google',
                              const Color(0xFF4285F4),
                              () => controller.loginWithGoogle(),
                              isLoading: controller.isLoading.value,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialButton(
                              'Facebook',
                              const Color(0xFF1877F2),
                              () => controller.loginWithFacebook(),
                              isLoading: controller.isLoading.value,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Register Link ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ຍັງບໍ່ມີບັນຊີ? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.register),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ລົງທະບຽນ',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Register Admin Link ──
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.registerAdmin),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              size: 20,
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ລົງທະບຽນເປັນ Admin',
                              style: TextStyle(
                                color: AppColors.primary.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String label,
    Color color,
    VoidCallback onTap, {
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Social Icon Container ──
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: _buildSocialIcon(label)),
            ),
            const SizedBox(width: 12),
            // ── Label ──
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String provider) {
    if (provider == 'Google') {
      return CustomPaint(
        size: const Size(18, 18),
        painter: GoogleIconPainter(),
      );
    } else if (provider == 'Facebook') {
      return const Icon(Icons.facebook_rounded, color: Colors.white, size: 22);
    }
    return const Icon(Icons.login_rounded, color: Colors.white, size: 18);
  }
}

// ── Custom Google Icon Painter ──
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    // Simple white circle background with G letter
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.4,
      paint,
    );

    // Draw G letter
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
