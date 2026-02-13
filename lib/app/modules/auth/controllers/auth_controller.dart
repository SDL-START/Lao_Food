import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // ── Form controllers ──
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  // ── Login ──
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        Log.i('Login success, role: ${user.role}');
        _navigateByRole(user.role);
      }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register (Customer only) ──
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      Helpers.showError('ລະຫັດຜ່ານບໍ່ຕົງກັນ');
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.registerCustomer(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        Helpers.showSuccess('ລົງທະບຽນສຳເລັດ!');
        _navigateByRole(user.role);
      }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Reset Password ──
  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Helpers.showError('ກະລຸນາໃສ່ອີເມລທີ່ຖືກຕ້ອງ');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.resetPassword(email);
      Helpers.showSuccess('ສົ່ງລິ້ງຕັ້ງລະຫັດໃໝ່ແລ້ວ');
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Navigate by role ──
  void _navigateByRole(String role) {
    _clearForm();
    switch (role) {
      case AppConstants.roleAdmin:
        Get.offAllNamed(AppRoutes.adminHome);
        break;
      case AppConstants.roleShop:
        Get.offAllNamed(AppRoutes.shopHome);
        break;
      case AppConstants.roleRider:
        Get.offAllNamed(AppRoutes.riderHome);
        break;
      case AppConstants.roleCustomer:
      default:
        Get.offAllNamed(AppRoutes.customerHome);
        break;
    }
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    phoneController.clear();
    confirmPasswordController.clear();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // ── Google Login ──
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authService.loginWithGoogle();
      if (user != null) {
        Log.i('Google login success, role: ${user.role}');
        Helpers.showSuccess('ເຂົ້າສູ່ລະບົບດ້ວຍ Google ສຳເລັດ!');
        _navigateByRole(user.role);
      }
    } catch (e) {
      Helpers.showError('ເຂົ້າສູ່ລະບົບດ້ວຍ Google ບໍ່ສຳເລັດ: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Facebook Login ──
  Future<void> loginWithFacebook() async {
    isLoading.value = true;
    try {
      final user = await _authService.loginWithFacebook();
      if (user != null) {
        Log.i('Facebook login success, role: ${user.role}');
        Helpers.showSuccess('ເຂົ້າສູ່ລະບົບດ້ວຍ Facebook ສຳເລັດ!');
        _navigateByRole(user.role);
      }
    } catch (e) {
      Helpers.showError('ເຂົ້າສູ່ລະບົບດ້ວຍ Facebook ບໍ່ສຳເລັດ: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
