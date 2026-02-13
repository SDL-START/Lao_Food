import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/order_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/rider_home_controller.dart';
import 'rider_order_detail_screen.dart';

class RiderHomeScreen extends GetView<RiderHomeController> {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Obx(() {
        final navIndex = controller.currentNavIndex.value;
        return IndexedStack(
          index: navIndex,
          children: [
            _buildHomeTab(),
            _buildAvailableTab(),
            _buildHistoryTab(),
            _buildProfileTab(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.onNavTap,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'ໜ້າຫຼັກ',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: Text('${controller.availableOrders.length}'),
                  isLabelVisible: controller.availableOrders.isNotEmpty,
                  child: const Icon(Icons.list_alt_outlined),
                ),
                activeIcon: const Icon(Icons.list_alt),
                label: 'ອໍເດີ',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'ປະຫວັດ',
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

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header with online toggle ──
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ສະບາຍດີ, ${controller.riderName}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: controller.isOnline.value
                                      ? AppColors.online
                                      : AppColors.offline,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                controller.isOnline.value
                                    ? 'ອອນລາຍ'
                                    : 'ອອບລາຍ',
                                style: TextStyle(
                                  color: controller.isOnline.value
                                      ? AppColors.online
                                      : AppColors.offline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.toggleOnline,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: controller.isOnline.value
                              ? AppColors.online
                              : AppColors.offline,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (controller.isOnline.value
                                      ? AppColors.online
                                      : AppColors.offline)
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          controller.isOnline.value
                              ? Icons.power_settings_new
                              : Icons.power_off,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 24),

            // ── Today stats ──
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'ລາຍຮັບມື້ນີ້',
                    Obx(() => Text(
                          Helpers.formatCurrency(controller.todayEarnings),
                          style: const TextStyle(
                            fontSize: 20,
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
                    'ສົ່ງແລ້ວ',
                    Obx(() => Text(
                          '${controller.todayDeliveries}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        )),
                    Icons.delivery_dining,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Current active order ──
            Obx(() {
              final order = controller.currentOrder.value;
              if (order == null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.delivery_dining,
                          size: 48,
                          color: AppColors.textHint.withValues(alpha: 0.4)),
                      const SizedBox(height: 12),
                      const Text(
                        'ບໍ່ມີອໍເດີ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RiderOrderDetailCard(
                order: order,
                controller: controller,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ອໍເດີທີ່ພ້ອມ'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.availableOrders.isEmpty) {
          return const EmptyState(
            icon: Icons.inbox_outlined,
            title: 'ບໍ່ມີອໍເດີ',
            subtitle: 'ລໍຖ້າອໍເດີໃໝ່...',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.availableOrders.length,
          itemBuilder: (_, i) {
            final order = controller.availableOrders[i];
            return OrderTile(
              order: order,
              onTap: () => _showAcceptDialog(order),
            );
          },
        );
      }),
    );
  }

  Widget _buildHistoryTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ປະຫວັດການສົ່ງ'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.historyOrders.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: 'ບໍ່ມີປະຫວັດ',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.historyOrders.length,
          itemBuilder: (_, i) => OrderTile(order: controller.historyOrders[i]),
        );
      }),
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
            child: Icon(Icons.two_wheeler, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            controller.riderName,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
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

  void _showAcceptDialog(dynamic order) {
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
              order.shopName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(order.deliveryAddress,
                style: const TextStyle(color: AppColors.textSecondary)),
            const Divider(height: 24),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${item.quantity}x ${item.productName}'),
                )),
            const SizedBox(height: 12),
            Text(
              Helpers.formatCurrency(order.total),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.acceptOrder(order);
                },
                child: const Text('ຮັບອໍເດີ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
