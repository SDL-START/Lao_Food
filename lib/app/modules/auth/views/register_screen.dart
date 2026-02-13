import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/utils/helpers.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                // ── Title ──
                const Text(
                  'ສ້າງບັນຊີໃໝ່',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ລົງທະບຽນເພື່ອສັ່ງອາຫານ',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 36),

                // ── Name ──
                AppInput(
                  controller: controller.nameController,
                  label: 'ຊື່-ນາມສະກຸນ',
                  hint: 'ໃສ່ຊື່ຂອງທ່ານ',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => Helpers.validateRequired(v, 'ຊື່'),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 20),

                // ── Email ──
                AppInput(
                  controller: controller.emailController,
                  label: 'ອີເມລ',
                  hint: 'example@mail.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Helpers.validateEmail,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 20),

                // ── Phone ──
                AppInput(
                  controller: controller.phoneController,
                  label: 'ເບີໂທ',
                  hint: '020 XXXX XXXX',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Helpers.validatePhone,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 20),

                // ── Password ──
                Obx(() => AppInput(
                      controller: controller.passwordController,
                      label: 'ລະຫັດຜ່ານ',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscurePassword.value,
                      validator: Helpers.validatePassword,
                      textInputAction: TextInputAction.next,
                      suffix: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),

                const SizedBox(height: 20),

                // ── Confirm password ──
                Obx(() => AppInput(
                      controller: controller.confirmPasswordController,
                      label: 'ຢືນຢັນລະຫັດຜ່ານ',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscurePassword.value,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'ກະລຸນາຢືນຢັນລະຫັດ';
                        if (v != controller.passwordController.text) {
                          return 'ລະຫັດບໍ່ຕົງກັນ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    )),

                const SizedBox(height: 32),

                // ── Register button ──
                Obx(() => AppButton(
                      text: 'ລົງທະບຽນ',
                      onPressed: controller.register,
                      isLoading: controller.isLoading.value,
                      icon: Icons.person_add,
                    )),

                const SizedBox(height: 20),

                // ── Login link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ມີບັນຊີແລ້ວ? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        'ເຂົ້າສູ່ລະບົບ',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
