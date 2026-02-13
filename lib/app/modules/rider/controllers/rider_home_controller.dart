import 'package:get/get.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/chat_service.dart';

class RiderHomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final LocationService _locationService = Get.find<LocationService>();
  final ChatService _chatService = Get.find<ChatService>();

  final RxBool isOnline = false.obs;
  final RxInt currentNavIndex = 0.obs;
  final RxList<OrderModel> availableOrders = <OrderModel>[].obs;
  final RxList<OrderModel> myOrders = <OrderModel>[].obs;
  final RxList<OrderModel> activeOrders = <OrderModel>[].obs;
  final RxList<OrderModel> historyOrders = <OrderModel>[].obs;
  final Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);
  final RxBool isLoading = true.obs;

  String get riderId => _authService.uid;
  String get riderName => _authService.userModel?.name ?? 'Rider';

  @override
  void onInit() {
    super.onInit();
    isOnline.value = _authService.userModel?.isOnline ?? false;
    _loadOrders();
    _initLocation();
  }

  void _loadOrders() {
    // Available orders (ready for pickup, no rider)
    _firestoreService.getAvailableOrdersForRider().listen((list) {
      availableOrders.value = list;
      isLoading.value = false;
    });

    // My orders
    _firestoreService.getOrdersByRider(riderId).listen((list) {
      myOrders.value = list;
      activeOrders.value =
          list.where((o) => o.orderStatus.isActive).toList();
      historyOrders.value =
          list.where((o) => !o.orderStatus.isActive).toList();

      // Set current active order
      final active = activeOrders.firstWhereOrNull(
        (o) =>
            o.status == OrderStatus.riderAssigned.value ||
            o.status == OrderStatus.pickedUp.value ||
            o.status == OrderStatus.onTheWay.value,
      );
      currentOrder.value = active;
    });
  }

  void _initLocation() async {
    await _locationService.getCurrentPosition();
  }

  // ── Online/Offline toggle ──
  Future<void> toggleOnline() async {
    try {
      isOnline.value = !isOnline.value;
      await _authService.updateProfile({'isOnline': isOnline.value});

      if (isOnline.value) {
        _locationService.startTracking(riderId);
        Helpers.showSuccess('ທ່ານອອນໄລແລ້ວ');
      } else {
        _locationService.stopTracking();
        Helpers.showInfo('ທ່ານອອບໄລແລ້ວ');
      }
      Log.i('Rider online: ${isOnline.value}');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Accept order ──
  Future<void> acceptOrder(OrderModel order) async {
    try {
      await _firestoreService.updateOrder(order.id, {
        'status': OrderStatus.riderAssigned.value,
        'riderId': riderId,
        'riderName': riderName,
        'riderPhone': _authService.userModel?.phone,
      });

      // Create chat room
      await _chatService.createChatRoom(
        orderId: order.id,
        customerId: order.customerId,
        customerName: order.customerName,
        riderId: riderId,
        riderName: riderName,
        shopId: order.shopId,
        shopName: order.shopName,
      );

      Helpers.showSuccess('ຮັບອໍເດີແລ້ວ');
      Log.i('Rider accepted order: ${order.id}');
    } catch (e) {
      Helpers.showError('ຮັບອໍເດີບໍ່ສຳເລັດ');
    }
  }

  // ── Pick up order ──
  Future<void> pickUpOrder(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.pickedUp.value,
        'pickedUpAt': DateTime.now(),
      });
      Helpers.showSuccess('ຮັບອາຫານແລ້ວ');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Start delivery ──
  Future<void> startDelivery(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.onTheWay.value,
      });
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Complete delivery ──
  Future<void> completeDelivery(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.delivered.value,
        'deliveredAt': DateTime.now(),
      });
      Helpers.showSuccess('ສົ່ງສຳເລັດ!');
      Log.i('Order delivered: $orderId');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── COD confirm ──
  Future<void> confirmCodCollected(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'codCollected': true,
        'codCollectedAt': DateTime.now(),
        'paymentStatus': PaymentStatus.paid.value,
      });
      Helpers.showSuccess('ເກັບເງິນແລ້ວ');
      Log.i('COD collected for: $orderId');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Report failed ──
  Future<void> reportFailed(String orderId, String reason) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.failed.value,
        'failReason': reason,
      });
      Helpers.showWarning('ລາຍງານບັນຫາສຳເລັດ');
    } catch (e) {
      Helpers.showError('ລາຍງານບໍ່ສຳເລັດ');
    }
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
  }

  // ── Stats ──
  double get todayEarnings {
    final today = DateTime.now();
    return historyOrders
        .where((o) =>
            o.status == OrderStatus.delivered.value &&
            o.deliveredAt != null &&
            o.deliveredAt!.day == today.day)
        .fold(0.0, (sum, o) => sum + o.deliveryFee);
  }

  int get todayDeliveries {
    final today = DateTime.now();
    return historyOrders
        .where((o) =>
            o.status == OrderStatus.delivered.value &&
            o.deliveredAt != null &&
            o.deliveredAt!.day == today.day)
        .length;
  }

  @override
  void onClose() {
    _locationService.stopTracking();
    super.onClose();
  }
}
