import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_input.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/customer_home_controller.dart';
import '../controllers/cart_controller.dart';
import 'widgets/shop_card.dart';

class CustomerHomeScreen extends GetView<CustomerHomeController> {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(() {
          final navIndex = controller.currentNavIndex.value;
          return IndexedStack(
            index: navIndex,
            children: [
              _buildHomeTab(),
              _buildOrdersTab(),
              _buildProfileTab(),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.onNavTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'ໜ້າຫຼັກ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'ອໍເດີ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'ບັນຊີ',
              ),
            ],
          )),
      floatingActionButton: Obx(() {
        final cartCtrl = Get.find<CartController>();
        if (!cartCtrl.hasItems) return const SizedBox();
        return FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.cart),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            '${cartCtrl.itemCount} ລາຍການ',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        );
      }),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        // ── Header ──
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Address ──
                GestureDetector(
                  onTap: () {/* Navigate to address picker */},
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Obx(() => Text(
                              controller.userAddress,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      'ສະບາຍດີ, ${controller.userName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                const SizedBox(height: 6),
                const Text(
                  'ມື້ນີ້ຢາກກິນຫຍັງ?',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),

                // ── Search bar ──
                AppSearchInput(
                  controller: controller.searchController,
                  hint: 'ຄົ້ນຫາຮ້ານ ຫຼື ອາຫານ...',
                  onChanged: controller.searchShops,
                ),
              ],
            ),
          ),
        ),

        // ── Categories ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 52,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: controller.categories.length,
                  itemBuilder: (_, i) {
                    final cat = controller.categories[i];
                    final selected = controller.selectedCategory.value == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (_) => controller.selectCategory(cat),
                        selectedColor: AppColors.primary.withValues(alpha: 0.15),
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                )),
          ),
        ),

        // ── Section title ──
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              'ຮ້ານໃກ້ທ່ານ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        // ── Shop list ──
        Obx(() {
          if (controller.isLoading.value) {
            return const SliverFillRemaining(child: LoadingWidget());
          }
          if (controller.filteredShops.isEmpty) {
            return const SliverFillRemaining(
              child: EmptyState(
                icon: Icons.store_outlined,
                title: 'ບໍ່ພົບຮ້ານ',
                subtitle: 'ລອງຄົ້ນຫາໃໝ່ ຫຼື ປ່ຽນໝວດໝູ່',
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => ShopCard(
                  shop: controller.filteredShops[i],
                  onTap: () => Get.toNamed(
                    AppRoutes.shopDetail,
                    arguments: controller.filteredShops[i],
                  ),
                ),
                childCount: controller.filteredShops.length,
              ),
            ),
          );
        }),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildOrdersTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ອໍເດີຂອງຂ້ອຍ'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.orderHistory),
              icon: const Icon(Icons.history),
              label: const Text('ເບິ່ງປະຫວັດອໍເດີ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.userName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              )),
          const SizedBox(height: 32),
          _profileTile(Icons.location_on_outlined, 'ທີ່ຢູ່ຂອງຂ້ອຍ', () {}),
          _profileTile(
              Icons.history, 'ປະຫວັດອໍເດີ', () => Get.toNamed(AppRoutes.orderHistory)),
          _profileTile(
              Icons.chat_outlined, 'ແຊັດ', () => Get.toNamed(AppRoutes.chatList)),
          const Divider(height: 32),
          _profileTile(Icons.logout, 'ອອກຈາກລະບົບ', () async {
            final confirm = await Helpers.showConfirmDialog(
              title: 'ອອກຈາກລະບົບ',
              message: 'ທ່ານແນ່ໃຈບໍ?',
            );
            if (confirm) {
              Get.find<AuthService>().logout();
              Get.offAllNamed(AppRoutes.login);
            }
          }),
        ],
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
