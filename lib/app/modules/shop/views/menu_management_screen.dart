import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/product_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../routes/app_routes.dart';
import '../controllers/shop_home_controller.dart';

class MenuManagementScreen extends GetView<ShopHomeController> {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('ຈັດການເມນູ'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.addProduct),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.products.isEmpty) {
          return EmptyState(
            icon: Icons.restaurant_menu,
            title: 'ຍັງບໍ່ມີເມນູ',
            subtitle: 'ກົດ + ເພື່ອເພີ່ມເມນູ',
            buttonText: 'ເພີ່ມເມນູ',
            onButtonPressed: () => Get.toNamed(AppRoutes.addProduct),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.products.length,
          separatorBuilder: (_, __) =>
              const Divider(indent: 16, endIndent: 16),
          itemBuilder: (_, i) {
            final product = controller.products[i];
            return Dismissible(
              key: Key(product.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: AppColors.error,
                child:
                    const Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              onDismissed: (_) => controller.deleteProduct(product.id),
              child: ProductTile(
                product: product,
                showAddButton: false,
                onTap: () {
                  Get.toNamed(AppRoutes.addProduct, arguments: product);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
