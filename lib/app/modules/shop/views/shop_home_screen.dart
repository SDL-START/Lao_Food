import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/order_tile.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/shop_home_controller.dart';
import 'shop_orders_screen.dart';
import 'menu_management_screen.dart';

class ShopHomeScreen extends GetView<ShopHomeController> {
  const ShopHomeScreen({super.key});

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
            const ShopOrdersScreen(),
            const MenuManagementScreen(),
            _buildProfileTab(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.onNavTap,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'ໜ້າຫຼັກ',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: Text('${controller.newOrders.length}'),
                  isLabelVisible: controller.newOrders.isNotEmpty,
                  child: const Icon(Icons.receipt_long_outlined),
                ),
                activeIcon: const Icon(Icons.receipt_long),
                label: 'ອໍເດີ',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined),
                activeIcon: Icon(Icons.restaurant_menu),
                label: 'ເມນູ',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'ບັນຊີ',
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
            // ── Header ──
            Obx(() {
              final shop = controller.shop.value;
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop?.name ?? 'ຮ້ານຂອງຂ້ອຍ',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: shop?.isOpen == true
                                    ? AppColors.online
                                    : AppColors.offline,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              shop?.isOpen == true ? 'ເປີດ' : 'ປິດ',
                              style: TextStyle(
                                color: shop?.isOpen == true
                                    ? AppColors.online
                                    : AppColors.offline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: shop?.isOpen ?? false,
                    onChanged: (_) => controller.toggleShopOpen(),
                    activeColor: AppColors.primary,
                  ),
                ],
              );
            }),

            const SizedBox(height: 24),

            // ── Stats ──
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'ລາຍຮັບມື້ນີ້',
                    Obx(() => Text(
                          Helpers.formatCurrency(controller.todayRevenue),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        )),
                    Icons.attach_money,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    'ອໍເດີມື້ນີ້',
                    Obx(() => Text(
                          '${controller.todayOrders}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        )),
                    Icons.receipt,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── New orders ──
            Obx(() {
              if (controller.newOrders.isEmpty) return const SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'ອໍເດີໃໝ່',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${controller.newOrders.length}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...controller.newOrders.map((o) => OrderTile(
                        order: o,
                        showCustomerName: true,
                        showShopName: false,
                        onTap: () => _showOrderActions(o),
                      )),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, Widget value, IconData icon) {
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
        children: [
          Icon(icon, color: AppColors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          value,
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.storefront, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.shop.value?.name ?? '',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700),
              )),
          const SizedBox(height: 32),
          ListTile(
            leading:
                const Icon(Icons.bar_chart, color: AppColors.primary),
            title: const Text('ລາຍງານ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.shopReport),
          ),
          ListTile(
            leading:
                const Icon(Icons.chat_outlined, color: AppColors.primary),
            title: const Text('ແຊັດ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.chatList),
          ),
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

  void _showOrderActions(OrderModel order) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#${order.id.substring(0, 8).toUpperCase()}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(order.customerName,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text('${item.quantity}x ',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(child: Text(item.productName)),
                      Text(Helpers.formatCurrency(item.totalPrice)),
                    ],
                  ),
                )),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      _showRejectDialog(order.id);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('ປະຕິເສດ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.acceptOrder(order.id);
                    },
                    child: const Text('ຮັບອໍເດີ'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(String orderId) async {
    final reason = await Get.dialog<String>(
      AlertDialog(
        title: const Text('ເຫດຜົນປະຕິເສດ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...['ວັດຖຸດິບໝົດ', 'ຮ້ານປິດແລ້ວ', 'ບໍ່ສາມາດກະກຽມໄດ້', 'ອື່ນໆ']
                .map((r) => ListTile(
                      title: Text(r),
                      onTap: () => Get.back(result: r),
                    )),
          ],
        ),
      ),
    );
    if (reason != null) {
      controller.rejectOrder(orderId, reason);
    }
  }
}
