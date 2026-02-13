import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/widgets/order_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/helpers.dart';
import '../controllers/shop_home_controller.dart';

class ShopOrdersScreen extends GetView<ShopHomeController> {
  const ShopOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('ອໍເດີ'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: controller.tabController,
          tabs: [
            Obx(() => Tab(text: 'ໃໝ່ (${controller.newOrders.length})')),
            Obx(() =>
                Tab(text: 'ກຳລັງດຳເນີນ (${controller.activeOrders.length})')),
            const Tab(text: 'ສຳເລັດ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildOrderList(controller.newOrders, isNew: true),
          _buildOrderList(controller.activeOrders, isActive: true),
          _buildOrderList(controller.completedOrders),
        ],
      ),
    );
  }

  Widget _buildOrderList(RxList orders,
      {bool isNew = false, bool isActive = false}) {
    return Obx(() {
      if (orders.isEmpty) {
        return const EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'ບໍ່ມີອໍເດີ',
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: orders.length,
        itemBuilder: (_, i) {
          final order = orders[i];
          return OrderTile(
            order: order,
            showCustomerName: true,
            showShopName: false,
            onTap: () => _showOrderDetail(order, isNew: isNew, isActive: isActive),
          );
        },
      );
    });
  }

  void _showOrderDetail(dynamic order,
      {bool isNew = false, bool isActive = false}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ອໍເດີ #${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.customerName} • ${order.customerPhone}',
                style:
                    const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const Divider(height: 24),

              // Items
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text('${item.quantity}x ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        Expanded(child: Text(item.productName)),
                        Text(Helpers.formatCurrency(item.totalPrice)),
                      ],
                    ),
                  )),

              if (order.customerNote != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(order.customerNote!,
                            style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ລວມ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(
                    Helpers.formatCurrency(order.total),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Actions
              if (isNew)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          controller.rejectOrder(order.id, 'ປະຕິເສດ');
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
                        child: const Text('ຮັບ'),
                      ),
                    ),
                  ],
                ),
              if (isActive) ...[
                if (order.status == OrderStatus.shopAccepted.value)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        controller.startPreparing(order.id);
                      },
                      icon: const Icon(Icons.restaurant),
                      label: const Text('ເລີ່ມກະກຽມ'),
                    ),
                  ),
                if (order.status == OrderStatus.preparing.value)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        controller.markReady(order.id);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('ພ້ອມແລ້ວ'),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
