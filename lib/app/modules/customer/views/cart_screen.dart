import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/order_status.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('ກະຕ່າ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.hasItems
              ? TextButton(
                  onPressed: () async {
                    final confirm = await Helpers.showConfirmDialog(
                      title: 'ລ້າງກະຕ່າ',
                      message: 'ຕ້ອງການລ້າງທຸກລາຍການ?',
                    );
                    if (confirm) controller.clearCart();
                  },
                  child: const Text('ລ້າງ',
                      style: TextStyle(color: Colors.white70)),
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (!controller.hasItems) {
          return const EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'ກະຕ່າຫວ່າງ',
            subtitle: 'ເພີ່ມອາຫານຈາກຮ້ານເພື່ອເລີ່ມສັ່ງ',
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Shop name ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront,
                            color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          controller.cart.value!.shopName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Items ──
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: List.generate(
                        controller.cart.value!.items.length,
                        (i) {
                          final item = controller.cart.value!.items[i];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (item.addons.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              item.addons
                                                  .map((a) => a.itemName)
                                                  .join(', '),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color:
                                                    AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                          if (item.note != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              'ໝາຍເຫດ: ${item.note}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color:
                                                    AppColors.textHint,
                                                fontStyle:
                                                    FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 6),
                                          Text(
                                            Helpers.formatCurrency(
                                                item.totalPrice),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ── Quantity control ──
                                    Row(
                                      children: [
                                        _quantityButton(
                                          Icons.remove,
                                          () => controller.updateQuantity(
                                              i, item.quantity - 1),
                                        ),
                                        Container(
                                          width: 36,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        _quantityButton(
                                          Icons.add,
                                          () => controller.updateQuantity(
                                              i, item.quantity + 1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (i <
                                  controller.cart.value!.items.length - 1)
                                const Divider(height: 1),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Payment Method ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ວິທີຈ່າຍເງິນ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...PaymentMethod.values.map((method) {
                          return Obx(() => RadioListTile<PaymentMethod>(
                                value: method,
                                groupValue:
                                    controller.selectedPaymentMethod.value,
                                onChanged: (v) {
                                  if (v != null) {
                                    controller.selectedPaymentMethod.value = v;
                                  }
                                },
                                title: Text(method.label),
                                secondary: Icon(method.icon),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ));
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Note ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (v) => controller.customerNote.value = v,
                      decoration: const InputDecoration(
                        hintText: 'ເພີ່ມໝາຍເຫດ (ທາງເລືອກ)...',
                        prefixIcon: Icon(Icons.note_outlined),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      maxLines: 2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Price summary ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _priceLine('ລາຄາອາຫານ', controller.subtotal),
                        const SizedBox(height: 6),
                        _priceLine('ຄ່າສົ່ງ', controller.deliveryFee),
                        if (controller.discount > 0) ...[
                          const SizedBox(height: 6),
                          _priceLine('ສ່ວນຫຼຸດ', -controller.discount,
                              isDiscount: true),
                        ],
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ລວມທັງໝົດ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              Helpers.formatCurrency(controller.total),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // ── Checkout button ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: AppButton(
                  text: 'ສັ່ງອາຫານ • ${Helpers.formatCurrency(controller.total)}',
                  onPressed: controller.checkout,
                  isLoading: controller.isLoading.value,
                  icon: Icons.check,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _priceLine(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary)),
        Text(
          '${isDiscount ? '-' : ''}${Helpers.formatCurrency(amount.abs())}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
