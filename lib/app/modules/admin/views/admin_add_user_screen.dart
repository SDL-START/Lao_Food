import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/admin_controller.dart';

class AdminAddUserScreen extends StatefulWidget {
  const AdminAddUserScreen({super.key});

  @override
  State<AdminAddUserScreen> createState() => _AdminAddUserScreenState();
}

class _AdminAddUserScreenState extends State<AdminAddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _isLoading = false.obs;
  late String role;

  @override
  void initState() {
    super.initState();
    role = Get.arguments as String? ?? AppConstants.roleRider;
  }

  String get roleLabel {
    switch (role) {
      case AppConstants.roleRider:
        return 'Rider';
      case AppConstants.roleShop:
        return 'ເຈົ້າຂອງຮ້ານ';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ເພີ່ມ $roleLabel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      role == AppConstants.roleRider
                          ? Icons.two_wheeler
                          : Icons.storefront,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ເພີ່ມ $roleLabel ໃໝ່',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppInput(
                controller: _nameCtrl,
                label: 'ຊື່-ນາມສະກຸນ',
                hint: 'ໃສ່ຊື່',
                prefixIcon: Icons.person_outline,
                validator: (v) => Helpers.validateRequired(v, 'ຊື່'),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _emailCtrl,
                label: 'ອີເມລ',
                hint: 'email@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Helpers.validateEmail,
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _phoneCtrl,
                label: 'ເບີໂທ',
                hint: '020 XXXX XXXX',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Helpers.validatePhone,
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: _passwordCtrl,
                label: 'ລະຫັດຜ່ານ',
                hint: '••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: Helpers.validatePassword,
              ),
              const SizedBox(height: 32),
              Obx(() => AppButton(
                    text: 'ສ້າງບັນຊີ $roleLabel',
                    isLoading: _isLoading.value,
                    onPressed: _create,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;
    try {
      final adminCtrl = Get.find<AdminController>();
      await adminCtrl.createUser(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        password: _passwordCtrl.text,
        role: role,
      );
      Get.back();
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
