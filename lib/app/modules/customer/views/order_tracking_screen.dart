import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final Rx<OrderModel?> order = Rx<OrderModel?>(null);
  late String orderId;

  @override
  void initState() {
    super.initState();
    orderId = Get.arguments as String;
    _firestoreService.streamOrder(orderId).listen((o) {
      order.value = o;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('ຕິດຕາມອໍເດີ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.offAllNamed(AppRoutes.customerHome),
        ),
      ),
      body: Obx(() {
        final o = order.value;
        if (o == null) return const LoadingWidget(message: 'ກຳລັງໂຫລດ...');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Status hero ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: o.orderStatus.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        o.orderStatus.icon,
                        size: 36,
                        color: o.orderStatus.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      o.orderStatus.label,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: o.orderStatus.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '#${o.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Timeline ──
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ສະຖານະ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTimeline(o),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Rider info ──
              if (o.riderId != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(Icons.two_wheeler, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              o.riderName ?? 'Rider',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              o.riderPhone ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (o.chatId != null)
                        IconButton(
                          onPressed: () => Get.toNamed(
                            AppRoutes.chatRoom,
                            arguments: o.chatId,
                          ),
                          icon: const Icon(Icons.chat_outlined,
                              color: AppColors.primary),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Order summary ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.shopName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(height: 20),
                    ...o.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                '${item.quantity}x',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(item.productName)),
                              Text(Helpers.formatCurrency(item.totalPrice)),
                            ],
                          ),
                        )),
                    const Divider(height: 20),
                    _summaryLine('ລາຄາອາຫານ', o.subtotal),
                    _summaryLine('ຄ່າສົ່ງ', o.deliveryFee),
                    if (o.discount > 0) _summaryLine('ສ່ວນຫຼຸດ', -o.discount),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ລວມ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          Helpers.formatCurrency(o.total),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Cancel button ──
              if (o.orderStatus.canCancel)
                AppButton(
                  text: 'ຍົກເລີກອໍເດີ',
                  isOutlined: true,
                  color: AppColors.error,
                  onPressed: () => _showCancelDialog(o.id),
                ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimeline(OrderModel o) {
    final statuses = [
      OrderStatus.placed,
      OrderStatus.shopAccepted,
      OrderStatus.preparing,
      OrderStatus.readyForPickup,
      OrderStatus.riderAssigned,
      OrderStatus.pickedUp,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];

    final currentIndex =
        statuses.indexWhere((s) => s.value == o.status);

    return Column(
      children: List.generate(statuses.length, (i) {
        final status = statuses[i];
        final isDone = i <= currentIndex;
        final isCurrent = i == currentIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDone
                        ? status.color
                        : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(
                            color: status.color, width: 2)
                        : null,
                  ),
                  child: isDone
                      ? const Icon(Icons.check,
                          size: 14, color: Colors.white)
                      : null,
                ),
                if (i < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 32,
                    color: isDone
                        ? status.color.withValues(alpha: 0.3)
                        : AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.w400,
                    color: isDone
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryLine(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
          Text(Helpers.formatCurrency(amount),
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showCancelDialog(String orderId) async {
    final reason = await Get.dialog<String>(
      AlertDialog(
        title: const Text('ຍົກເລີກອໍເດີ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ກະລຸນາເລືອກເຫດຜົນ:'),
            const SizedBox(height: 12),
            ...['ປ່ຽນໃຈ', 'ລໍຖ້າດົນ', 'ສັ່ງຜິດ', 'ອື່ນໆ'].map(
              (r) => ListTile(
                title: Text(r),
                onTap: () => Get.back(result: r),
              ),
            ),
          ],
        ),
      ),
    );

    if (reason != null) {
      final firestoreService = Get.find<FirestoreService>();
      await firestoreService.updateOrder(orderId, {
        'status': OrderStatus.cancelled.value,
        'cancelReason': reason,
        'cancelledAt': DateTime.now(),
      });
      Helpers.showSuccess('ຍົກເລີກສຳເລັດ');
    }
  }
}
