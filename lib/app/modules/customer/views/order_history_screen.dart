import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/order_tile.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Get.find<FirestoreService>();
    final authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('ປະຫວັດອໍເດີ')),
      body: StreamBuilder<List<OrderModel>>(
        stream: firestoreService.getOrdersByCustomer(authService.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'ບໍ່ມີປະຫວັດອໍເດີ',
              subtitle: 'ອໍເດີຂອງທ່ານຈະສະແດງຢູ່ບ່ອນນີ້',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: orders.length,
            itemBuilder: (_, i) => OrderTile(
              order: orders[i],
              onTap: () => Get.toNamed(
                AppRoutes.orderTracking,
                arguments: orders[i].id,
              ),
            ),
          );
        },
      ),
    );
  }
}
