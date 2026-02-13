import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
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
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildCartFab(),
    );
  }

  Widget _buildBottomNav() {
    return Obx(() => Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BottomNavigationBar(
              currentIndex: controller.currentNavIndex.value,
              onTap: controller.onNavTap,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                _buildNavItem(
                  Icons.home_rounded,
                  'ໜ້າຫຼັກ',
                  controller.currentNavIndex.value == 0,
                ),
                _buildNavItem(
                  Icons.receipt_long_rounded,
                  'ອໍເດີ',
                  controller.currentNavIndex.value == 1,
                ),
                _buildNavItem(
                  Icons.person_rounded,
                  'ບັນຊີ',
                  controller.currentNavIndex.value == 2,
                ),
              ],
            ),
          ),
        ));
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  Widget _buildCartFab() {
    return Obx(() {
      final cartCtrl = Get.find<CartController>();
      if (!cartCtrl.hasItems) return const SizedBox();
      return Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: AppFloatingButton(
          onPressed: () => Get.toNamed(AppRoutes.cart),
          icon: Icons.shopping_cart_rounded,
          label: '${cartCtrl.itemCount} ລາຍການ',
          isExtended: true,
        ),
      );
    });
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        // ── Modern Header with Gradient ──
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row with Location ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ສົ່ງໄປທີ່',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Obx(() => Text(
                                controller.userAddress,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // ── Welcome Text ──
                Obx(() => Text(
                      'ສະບາຍດີ, ${controller.userName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    )),
                const SizedBox(height: 6),
                Text(
                  'ມື້ນີ້ຢາກກິນຫຍັງ?',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // ── Modern Search Bar ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.searchShops,
                    decoration: InputDecoration(
                      hintText: 'ຄົ້ນຫາຮ້ານ ຫຼື ອາຫານ...',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 56,
                        minHeight: 56,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Categories Section ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ໝວດໝູ່',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('ເບິ່ງທັງໝົດ'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Category Chips ──
        SliverToBoxAdapter(
          child: SizedBox(
            height: 58,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.categories.length,
                  itemBuilder: (_, i) {
                    final cat = controller.categories[i];
                    final selected = controller.selectedCategory.value == cat;
                    final categoryColors = [
                      AppColors.categoryFood,
                      AppColors.categoryDrink,
                      AppColors.categoryDessert,
                      AppColors.categorySnack,
                      AppColors.categoryHealthy,
                      AppColors.categoryFastFood,
                    ];
                    final color = categoryColors[i % categoryColors.length];
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CategoryChip(
                        label: cat,
                        isSelected: selected,
                        onTap: () => controller.selectCategory(cat),
                        color: color,
                      ),
                    );
                  },
                )),
          ),
        ),

        // ── Section Title ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ຮ້ານໃກ້ທ່ານ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ກອງ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Shop List ──
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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

        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildOrdersTab() {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('ອໍເດີຂອງຂ້ອຍ'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ຍັງບໍ່ມີອໍເດີ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ເລີ່ມສັ່ງອາຫານໄດ້ເລີຍ!',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: AppButton(
                text: 'ເບິ່ງປະຫວັດອໍເດີ',
                onPressed: () => Get.toNamed(AppRoutes.orderHistory),
                icon: Icons.history_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ──
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // ── Avatar ──
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: const CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Text(
                        controller.userName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'ສະມາຊິກ Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Quick Actions ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ເມນູຫຼັກ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    Icons.location_on_outlined,
                    'ທີ່ຢູ່ຂອງຂ້ອຍ',
                    'ຈັດການທີ່ຢູ່ຈັດສົ່ງ',
                    AppColors.info,
                    () {},
                  ),
                  _buildMenuCard(
                    Icons.history_rounded,
                    'ປະຫວັດອໍເດີ',
                    'ເບິ່ງອໍເດີທີ່ຜ່ານມາ',
                    AppColors.success,
                    () => Get.toNamed(AppRoutes.orderHistory),
                  ),
                  _buildMenuCard(
                    Icons.chat_outlined,
                    'ການສົນທະນາ',
                    'ຂໍ້ຄວາມແລະການສົນທະນາ',
                    AppColors.warning,
                    () => Get.toNamed(AppRoutes.chatList),
                  ),
                  _buildMenuCard(
                    Icons.favorite_outline,
                    'ຮ້ານທີ່ມັກ',
                    'ຮ້ານທີ່ບັນທຶກໄວ້',
                    AppColors.error,
                    () {},
                  ),
                  _buildMenuCard(
                    Icons.settings_outlined,
                    'ການຕັ້ງຄ່າ',
                    'ຕັ້ງຄ່າແອັບ',
                    AppColors.secondary,
                    () {},
                  ),
                ],
              ),
            ),
          ),

          // ── Logout Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppButton(
                text: 'ອອກຈາກລະບົບ',
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
                isOutlined: true,
                color: AppColors.error,
                icon: Icons.logout_rounded,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
