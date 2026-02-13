import 'package:get/get.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class CustomerOrderController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> activeOrders = <OrderModel>[].obs;
  final RxList<OrderModel> pastOrders = <OrderModel>[].obs;
  final Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrders();
  }

  void _loadOrders() {
    final uid = _authService.uid;
    _firestoreService.getOrdersByCustomer(uid).listen((list) {
      orders.value = list;
      activeOrders.value = list.where((o) => o.orderStatus.isActive).toList();
      pastOrders.value = list.where((o) => !o.orderStatus.isActive).toList();
      isLoading.value = false;
    });
  }

  void streamOrder(String orderId) {
    _firestoreService.streamOrder(orderId).listen((order) {
      currentOrder.value = order;
    });
  }

  /// ── Cancel order (only if allowed) ──
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      final order = orders.firstWhereOrNull((o) => o.id == orderId);
      if (order == null) return;

      if (!order.orderStatus.canCancel) {
        Helpers.showWarning('ບໍ່ສາມາດຍົກເລີກອໍເດີນີ້ໄດ້');
        return;
      }

      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.cancelled.value,
        'cancelReason': reason,
        'cancelledAt': DateTime.now(),
      });

      Helpers.showSuccess('ຍົກເລີກສຳເລັດ');
      Log.i('Order cancelled: $orderId');
    } catch (e) {
      Log.e('Cancel order error', e);
      Helpers.showError('ຍົກເລີກບໍ່ສຳເລັດ');
    }
  }
}
