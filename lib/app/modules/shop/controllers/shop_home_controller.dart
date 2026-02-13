import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class ShopHomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  late TabController tabController;
  final RxInt currentNavIndex = 0.obs;
  final Rx<ShopModel?> shop = Rx<ShopModel?>(null);
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> newOrders = <OrderModel>[].obs;
  final RxList<OrderModel> activeOrders = <OrderModel>[].obs;
  final RxList<OrderModel> completedOrders = <OrderModel>[].obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;

  String get shopId => _authService.userModel?.shopId ?? '';

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    _loadShopData();
  }

  void _loadShopData() {
    if (shopId.isEmpty) return;

    // Stream shop data
    _firestoreService.streamShop(shopId).listen((s) {
      shop.value = s;
    });

    // Stream orders
    _firestoreService.getOrdersByShop(shopId).listen((list) {
      orders.value = list;
      newOrders.value = list
          .where((o) => o.status == OrderStatus.placed.value)
          .toList();
      activeOrders.value = list
          .where((o) =>
              o.orderStatus.isActive &&
              o.status != OrderStatus.placed.value)
          .toList();
      completedOrders.value =
          list.where((o) => !o.orderStatus.isActive).toList();
      isLoading.value = false;
    });

    // Stream products
    _firestoreService.getProducts(shopId).listen((list) {
      products.value = list;
    });
  }

  // ── Order Actions ──
  Future<void> acceptOrder(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.shopAccepted.value,
        'acceptedAt': DateTime.now(),
      });
      Helpers.showSuccess('ຮັບອໍເດີແລ້ວ');
      Log.i('Shop accepted order: $orderId');
    } catch (e) {
      Helpers.showError('ຮັບອໍເດີບໍ່ສຳເລັດ');
    }
  }

  Future<void> rejectOrder(String orderId, String reason) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.shopRejected.value,
        'cancelReason': reason,
        'cancelledAt': DateTime.now(),
      });
      Helpers.showSuccess('ປະຕິເສດອໍເດີແລ້ວ');
    } catch (e) {
      Helpers.showError('ປະຕິເສດບໍ່ສຳເລັດ');
    }
  }

  Future<void> startPreparing(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.preparing.value,
        'preparingAt': DateTime.now(),
      });
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  Future<void> markReady(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'status': OrderStatus.readyForPickup.value,
        'readyAt': DateTime.now(),
      });
      Helpers.showSuccess('ອາຫານພ້ອມແລ້ວ');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Shop Toggle ──
  Future<void> toggleShopOpen() async {
    if (shop.value == null) return;
    try {
      await _firestoreService.updateShop(shopId, {
        'isOpen': !shop.value!.isOpen,
      });
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Product Management ──
  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestoreService.createProduct(product);
      Helpers.showSuccess('ເພີ່ມເມນູແລ້ວ');
    } catch (e) {
      Helpers.showError('ເພີ່ມບໍ່ສຳເລັດ');
    }
  }

  Future<void> toggleProductAvailability(ProductModel product) async {
    try {
      await _firestoreService.updateProduct(
        shopId,
        product.id,
        {'isAvailable': !product.isAvailable},
      );
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final confirm = await Helpers.showConfirmDialog(
      title: 'ລົບເມນູ',
      message: 'ແນ່ໃຈບໍ່ຕ້ອງການລົບ?',
    );
    if (confirm) {
      try {
        await _firestoreService.deleteProduct(shopId, productId);
        Helpers.showSuccess('ລົບແລ້ວ');
      } catch (e) {
        Helpers.showError('ລົບບໍ່ສຳເລັດ');
      }
    }
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
  }

  // ── Report stats ──
  double get todayRevenue {
    final today = DateTime.now();
    return completedOrders
        .where((o) =>
            o.deliveredAt != null &&
            o.deliveredAt!.day == today.day &&
            o.deliveredAt!.month == today.month)
        .fold(0.0, (sum, o) => sum + o.total);
  }

  int get todayOrders {
    final today = DateTime.now();
    return orders
        .where((o) =>
            o.createdAt.day == today.day &&
            o.createdAt.month == today.month)
        .length;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
