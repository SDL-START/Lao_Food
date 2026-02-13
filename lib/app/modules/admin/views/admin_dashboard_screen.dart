import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/admin_controller.dart';
import 'manage_users_screen.dart';
import 'manage_shops_screen.dart';
import 'admin_orders_screen.dart';

class AdminDashboardScreen extends GetView<AdminController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Obx(() {
        final navIndex = controller.currentNavIndex.value;
        return IndexedStack(
          index: navIndex,
          children: [
            _buildDashboard(),
            const ManageUsersScreen(),
            const ManageShopsScreen(),
            const AdminOrdersScreen(),
            _buildSettingsTab(),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          onTap: controller.onNavTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'ຜູ້ໃຊ້',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'ຮ້ານ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'ອໍເດີ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'ຕັ້ງຄ່າ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'ພາບລວມລະບົບ',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // ── Stats grid ──
            Obx(
              () => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _dashCard(
                    'ຜູ້ໃຊ້ທັງໝົດ',
                    '${controller.totalUsers}',
                    Icons.people,
                    AppColors.info,
                  ),
                  _dashCard(
                    'ຮ້ານ',
                    '${controller.totalShops}',
                    Icons.store,
                    AppColors.success,
                  ),
                  _dashCard(
                    'Riders',
                    '${controller.totalRiders}',
                    Icons.two_wheeler,
                    AppColors.primary,
                  ),
                  _dashCard(
                    'ອໍເດີທັງໝົດ',
                    '${controller.totalOrders}',
                    Icons.receipt,
                    AppColors.warning,
                  ),
                  _dashCard(
                    'ອໍເດີ Active',
                    '${controller.activeOrders}',
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _dashCard(
                    'ລາຍຮັບລວມ',
                    Helpers.formatCurrency(controller.totalRevenue),
                    Icons.attach_money,
                    AppColors.success,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Commission info ──
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Commission ລວມ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Helpers.formatCurrency(controller.totalCommission),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Quick actions ──
            const Text(
              'ຈັດການດ່ວນ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _actionTile(Icons.person_add, 'ເພີ່ມ Rider', () {
              Get.toNamed(AppRoutes.adminAddUser, arguments: 'rider');
            }),
            _actionTile(Icons.store, 'ເພີ່ມຮ້ານ', () {
              Get.toNamed(AppRoutes.adminAddUser, arguments: 'shop');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Obx(() {
      final user = controller.adminUser;
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Gradient Profile Header ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                      const Text(
                        'ໂປຣໄຟລ໌ & ຕັ້ງຄ່າ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              backgroundImage:
                                  user?.profileImage != null &&
                                      user!.profileImage!.isNotEmpty
                                  ? NetworkImage(user.profileImage!)
                                  : null,
                              child:
                                  user?.profileImage == null ||
                                      user!.profileImage!.isEmpty
                                  ? const Icon(
                                      Icons.admin_panel_settings,
                                      size: 48,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.verified,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        user?.name ?? 'Admin',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Email
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Administrator',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Profile Information Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ຂໍ້ມູນສ່ວນຕົວ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _settingsCard(
                      children: [
                        _editableProfileTile(
                          icon: Icons.person_outline,
                          iconColor: AppColors.info,
                          label: 'ຊື່',
                          value: user?.name ?? '-',
                          onTap: () => _showEditDialog(
                            title: 'ແກ້ໄຂຊື່',
                            field: 'name',
                            currentValue: user?.name ?? '',
                            icon: Icons.person,
                          ),
                        ),
                        _divider(),
                        _editableProfileTile(
                          icon: Icons.email_outlined,
                          iconColor: AppColors.primary,
                          label: 'ອີເມລ',
                          value: user?.email ?? '-',
                          onTap: () => _showEditDialog(
                            title: 'ແກ້ໄຂອີເມລ',
                            field: 'email',
                            currentValue: user?.email ?? '',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        _divider(),
                        _editableProfileTile(
                          icon: Icons.phone_outlined,
                          iconColor: AppColors.success,
                          label: 'ເບີໂທ',
                          value: user?.phone.isNotEmpty == true
                              ? Helpers.formatPhone(user!.phone)
                              : '-',
                          onTap: () => _showEditDialog(
                            title: 'ແກ້ໄຂເບີໂທ',
                            field: 'phone',
                            currentValue: user?.phone ?? '',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Account Info Section ──
                    const Text(
                      'ຂໍ້ມູນບັນຊີ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _settingsCard(
                      children: [
                        _infoTile(
                          icon: Icons.fingerprint,
                          iconColor: AppColors.tertiary,
                          label: 'ID ບັນຊີ',
                          value: user?.uid.substring(0, 12) ?? '-',
                        ),
                        _divider(),
                        _infoTile(
                          icon: Icons.calendar_today_outlined,
                          iconColor: AppColors.warning,
                          label: 'ວັນທີສ້າງບັນຊີ',
                          value: user != null
                              ? Helpers.formatDate(user.createdAt)
                              : '-',
                        ),
                        _divider(),
                        _infoTile(
                          icon: Icons.update,
                          iconColor: AppColors.secondary,
                          label: 'ອັບເດດລ່າສຸດ',
                          value: user != null
                              ? Helpers.formatDateTime(user.updatedAt)
                              : '-',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Security Section ──
                    const Text(
                      'ຄວາມປອດໄພ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _settingsCard(
                      children: [
                        _editableProfileTile(
                          icon: Icons.lock_outline,
                          iconColor: AppColors.warning,
                          label: 'ປ່ຽນລະຫັດຜ່ານ',
                          value: '••••••••',
                          onTap: () => _showChangePasswordDialog(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── App Info Section ──
                    const Text(
                      'ກ່ຽວກັບແອັບ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _settingsCard(
                      children: [
                        _infoTile(
                          icon: Icons.info_outline,
                          iconColor: AppColors.info,
                          label: 'ເວີຊັນ',
                          value: AppConstants.appVersion,
                        ),
                        _divider(),
                        _infoTile(
                          icon: Icons.restaurant_menu,
                          iconColor: AppColors.primary,
                          label: 'ຊື່ແອັບ',
                          value: AppConstants.appName,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Logout Button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await Helpers.showConfirmDialog(
                            title: 'ອອກຈາກລະບົບ',
                            message: 'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການອອກຈາກລະບົບ?',
                          );
                          if (confirm) {
                            Get.find<AuthService>().logout();
                            Get.offAllNamed(AppRoutes.login);
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'ອອກຈາກລະບົບ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 60, color: AppColors.divider);
  }

  Widget _editableProfileTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog({
    required String title,
    required String field,
    required String currentValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final textController = TextEditingController(text: currentValue);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                keyboardType: keyboardType,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'ໃສ່$title...',
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: AppColors.divider),
                      ),
                      child: const Text(
                        'ຍົກເລີກ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isUpdating.value
                            ? null
                            : () {
                                final newValue = textController.text.trim();
                                if (newValue.isEmpty) {
                                  Helpers.showError('ກະລຸນາໃສ່ຂໍ້ມູນ');
                                  return;
                                }
                                if (newValue == currentValue) {
                                  Get.back();
                                  return;
                                }
                                controller
                                    .updateAdminField(field, newValue)
                                    .then((_) => Get.back());
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isUpdating.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'ບັນທຶກ',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    final showCurrentPass = false.obs;
    final showNewPass = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.lock, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ປ່ຽນລະຫັດຜ່ານ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                // Current password
                Obx(
                  () => TextField(
                    controller: currentPassCtrl,
                    obscureText: !showCurrentPass.value,
                    decoration: InputDecoration(
                      hintText: 'ລະຫັດຜ່ານປັດຈຸບັນ',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showCurrentPass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => showCurrentPass.toggle(),
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // New password
                Obx(
                  () => TextField(
                    controller: newPassCtrl,
                    obscureText: !showNewPass.value,
                    decoration: InputDecoration(
                      hintText: 'ລະຫັດຜ່ານໃໝ່',
                      prefixIcon: const Icon(Icons.lock_reset, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNewPass.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => showNewPass.toggle(),
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Confirm password
                TextField(
                  controller: confirmPassCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'ຢືນຢັນລະຫັດຜ່ານໃໝ່',
                    prefixIcon: const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: AppColors.divider),
                        ),
                        child: const Text(
                          'ຍົກເລີກ',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isUpdating.value
                              ? null
                              : () {
                                  if (currentPassCtrl.text.isEmpty ||
                                      newPassCtrl.text.isEmpty ||
                                      confirmPassCtrl.text.isEmpty) {
                                    Helpers.showError('ກະລຸນາໃສ່ຂໍ້ມູນໃຫ້ຄົບ');
                                    return;
                                  }
                                  if (newPassCtrl.text.length < 6) {
                                    Helpers.showError(
                                      'ລະຫັດຜ່ານຕ້ອງມີຢ່າງໜ້ອຍ 6 ຕົວ',
                                    );
                                    return;
                                  }
                                  if (newPassCtrl.text !=
                                      confirmPassCtrl.text) {
                                    Helpers.showError('ລະຫັດຜ່ານໃໝ່ບໍ່ກົງກັນ');
                                    return;
                                  }
                                  controller
                                      .changePassword(
                                        currentPassword: currentPassCtrl.text,
                                        newPassword: newPassCtrl.text,
                                      )
                                      .then((_) {
                                        Get.back();
                                      });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isUpdating.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'ບັນທຶກ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
