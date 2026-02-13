import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/rider_home_controller.dart';

class RiderOrderDetailCard extends StatelessWidget {
  final OrderModel order;
  final RiderHomeController controller;

  const RiderOrderDetailCard({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: order.orderStatus.color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status ──
          Row(
            children: [
              Icon(order.orderStatus.icon,
                  color: order.orderStatus.color, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.orderStatus.label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: order.orderStatus.color,
                  ),
                ),
              ),
              Text(
                '#${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          // ── Shop info ──
          _infoRow(Icons.storefront, 'ຮ້ານ', order.shopName),
          const SizedBox(height: 8),

          // ── Customer info ──
          _infoRow(Icons.person, 'ລູກຄ້າ',
              '${order.customerName} (${order.customerPhone})'),
          const SizedBox(height: 8),

          // ── Address ──
          _infoRow(Icons.location_on, 'ສົ່ງຫາ', order.deliveryAddress),

          const SizedBox(height: 12),

          // ── Items ──
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text('${item.quantity}x ',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                    Expanded(child: Text(item.productName, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              )),

          const Divider(height: 20),

          // ── Total + Payment ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderPaymentMethod.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (order.paymentMethod == 'COD' && !order.codCollected)
                    const Text(
                      'ຕ້ອງເກັບເງິນ',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              Text(
                Helpers.formatCurrency(order.total),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Action buttons ──
          _buildActions(),

          // ── Chat button ──
          if (order.chatId != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Get.toNamed(AppRoutes.chatRoom, arguments: order.chatId),
                icon: const Icon(Icons.chat),
                label: const Text('ແຊັດກັບລູກຄ້າ'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    switch (order.orderStatus) {
      case OrderStatus.riderAssigned:
        return SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'ຮັບອາຫານແລ້ວ',
            icon: Icons.takeout_dining,
            onPressed: () => controller.pickUpOrder(order.id),
          ),
        );

      case OrderStatus.pickedUp:
        return SizedBox(
          width: double.infinity,
          child: AppButton(
            text: 'ກຳລັງສົ່ງ',
            icon: Icons.delivery_dining,
            onPressed: () => controller.startDelivery(order.id),
          ),
        );

      case OrderStatus.onTheWay:
        return Column(
          children: [
            // COD collection
            if (order.paymentMethod == 'COD' && !order.codCollected)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'ເກັບເງິນແລ້ວ (${Helpers.formatCurrency(order.total)})',
                    icon: Icons.money,
                    color: AppColors.success,
                    onPressed: () async {
                      final confirm = await Helpers.showConfirmDialog(
                        title: 'ຢືນຢັນເກັບເງິນ',
                        message:
                            'ເກັບເງິນ ${Helpers.formatCurrency(order.total)} ແລ້ວ?',
                      );
                      if (confirm) {
                        controller.confirmCodCollected(order.id);
                      }
                    },
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'ສົ່ງສຳເລັດ',
                icon: Icons.check_circle,
                onPressed: () async {
                  // Check COD first
                  if (order.paymentMethod == 'COD' && !order.codCollected) {
                    Helpers.showWarning('ກະລຸນາເກັບເງິນກ່ອນ');
                    return;
                  }
                  controller.completeDelivery(order.id);
                },
              ),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textHint)),
            Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
