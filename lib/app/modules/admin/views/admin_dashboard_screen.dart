import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      bottomNavigationBar: Obx(() => BottomNavigationBar(
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
          )),
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
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // ── Stats grid ──
            Obx(() => GridView.count(
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
                )),

            const SizedBox(height: 24),

            // ── Commission info ──
            Obx(() => Container(
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
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14),
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
                )),

            const SizedBox(height: 24),

            // ── Quick actions ──
            const Text(
              'ຈັດການດ່ວນ',
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.admin_panel_settings,
                size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.primary),
            title: const Text('ອອກຈາກລະບົບ'),
            onTap: () async {
              final confirm = await Helpers.showConfirmDialog(
                title: 'ອອກຈາກລະບົບ',
                message: 'ແນ່ໃຈບໍ?',
              );
              if (confirm) {
                Get.find<AuthService>().logout();
                Get.offAllNamed(AppRoutes.login);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _dashCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
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
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
