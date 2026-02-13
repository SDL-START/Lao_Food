import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/utils/helpers.dart';
import '../controllers/shop_home_controller.dart';

class ShopReportScreen extends GetView<ShopHomeController> {
  const ShopReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ລາຍງານ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final completed = controller.completedOrders
              .where((o) => o.status == OrderStatus.delivered.value)
              .toList();
          final totalRevenue =
              completed.fold(0.0, (sum, o) => sum + o.total);
          final totalOrders = controller.orders.length;
          final cancelledOrders = controller.orders
              .where((o) =>
                  o.status == OrderStatus.cancelled.value ||
                  o.status == OrderStatus.shopRejected.value)
              .length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ສະຖິຕິລວມ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),

              // Stats grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _reportCard(
                    'ລາຍຮັບລວມ',
                    Helpers.formatCurrency(totalRevenue),
                    Icons.attach_money,
                    AppColors.success,
                  ),
                  _reportCard(
                    'ອໍເດີທັງໝົດ',
                    '$totalOrders',
                    Icons.receipt,
                    AppColors.primary,
                  ),
                  _reportCard(
                    'ອໍເດີສຳເລັດ',
                    '${completed.length}',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                  _reportCard(
                    'ຍົກເລີກ',
                    '$cancelledOrders',
                    Icons.cancel,
                    AppColors.error,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'ເມນູຍອດນິຍົມ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Popular products
              ...controller.products
                  .where((p) => p.isPopular)
                  .map((p) => ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: Icon(Icons.restaurant,
                              color: Colors.white, size: 20),
                        ),
                        title: Text(p.name),
                        subtitle: Text(Helpers.formatCurrency(p.price)),
                        trailing: Text(
                          p.isAvailable ? 'ພ້ອມ' : 'ໝົດ',
                          style: TextStyle(
                            color: p.isAvailable
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),

              if (controller.products.where((p) => p.isPopular).isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'ບໍ່ມີເມນູຍອດນິຍົມ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _reportCard(
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
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
          ),
        ],
      ),
    );
  }
}
