import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/order_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../controllers/admin_controller.dart';

class AdminOrdersScreen extends GetView<AdminController> {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ອໍເດີທັງໝົດ'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.allOrders.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'ບໍ່ມີອໍເດີ',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.allOrders.length,
          itemBuilder: (_, i) {
            final order = controller.allOrders[i];
            return OrderTile(
              order: order,
              showCustomerName: true,
              onTap: () => _showOrderDetail(order),
            );
          },
        );
      }),
    );
  }

  void _showOrderDetail(dynamic order) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _info('ລູກຄ້າ', '${order.customerName} (${order.customerPhone})'),
              _info('ຮ້ານ', order.shopName),
              _info('Rider', order.riderName ?? 'ຍັງບໍ່ມີ'),
              _info('ສະຖານະ', order.orderStatus.label),
              _info('ການຈ່າຍ', '${order.orderPaymentMethod.label} - ${order.orderPaymentStatus.label}'),
              _info('ລາຄາ', Helpers.formatCurrency(order.total)),
              _info('ວັນທີ', Helpers.formatDateTime(order.createdAt)),
              const Divider(height: 24),

              // Admin actions
              if (order.orderStatus.isActive)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await Helpers.showConfirmDialog(
                        title: 'ຄືນເງິນ',
                        message: 'ແນ່ໃຈບໍ?',
                      );
                      if (confirm) {
                        controller.refundOrder(order.id);
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.money_off),
                    label: const Text('ຄືນເງິນ (Refund)'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
