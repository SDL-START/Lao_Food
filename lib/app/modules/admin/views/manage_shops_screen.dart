import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/shop_model.dart';
import '../controllers/admin_controller.dart';

class ManageShopsScreen extends GetView<AdminController> {
  const ManageShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ຈັດການຮ້ານ'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.allShops.isEmpty) {
          return const EmptyState(
            icon: Icons.store_outlined,
            title: 'ບໍ່ມີຮ້ານ',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.allShops.length,
          itemBuilder: (_, i) => _buildShopTile(controller.allShops[i]),
        );
      }),
    );
  }

  Widget _buildShopTile(ShopModel shop) {
    return AppCard(
      onTap: () => _showShopActions(shop),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (shop.isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          color: AppColors.info, size: 16),
                    ],
                  ],
                ),
                Text(
                  '${shop.category} • ${shop.address}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      'Rating: ${shop.rating.toStringAsFixed(1)}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ອໍເດີ: ${shop.totalOrders}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Commission: ${(shop.commissionRate * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusBadge(
            text: shop.isActive ? (shop.isOpen ? 'ເປີດ' : 'ປິດ') : 'ລະງັບ',
            color: shop.isActive
                ? (shop.isOpen ? AppColors.success : AppColors.offline)
                : AppColors.error,
          ),
        ],
      ),
    );
  }

  void _showShopActions(ShopModel shop) {
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
              shop.name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Divider(height: 24),
            ListTile(
              leading: Icon(
                shop.isActive ? Icons.block : Icons.check_circle,
                color: shop.isActive ? AppColors.error : AppColors.success,
              ),
              title:
                  Text(shop.isActive ? 'ລະງັບຮ້ານ' : 'ເປີດຮ້ານ'),
              onTap: () {
                Get.back();
                controller.toggleShopActive(shop);
              },
            ),
            if (!shop.isVerified)
              ListTile(
                leading:
                    const Icon(Icons.verified, color: AppColors.info),
                title: const Text('ຢືນຢັນຮ້ານ (Verify)'),
                onTap: () {
                  Get.back();
                  controller.verifyShop(shop);
                },
              ),
            ListTile(
              leading: const Icon(Icons.percent,
                  color: AppColors.primary),
              title: const Text('ແກ້ Commission'),
              onTap: () {
                Get.back();
                _showCommissionDialog(shop);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCommissionDialog(ShopModel shop) {
    final ctrl =
        TextEditingController(text: (shop.commissionRate * 100).toStringAsFixed(0));
    Get.dialog(
      AlertDialog(
        title: Text('Commission - ${shop.name}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'ອັດຕາ (%)',
            suffixText: '%',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              final rate = double.tryParse(ctrl.text);
              if (rate != null && rate >= 0 && rate <= 100) {
                controller.updateCommission(shop.id, rate / 100);
                Get.back();
              } else {
                Helpers.showError('ກະລຸນາໃສ່ 0-100');
              }
            },
            child: const Text('ບັນທຶກ'),
          ),
        ],
      ),
    );
  }
}
