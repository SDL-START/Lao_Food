import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/addon_model.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';

class CartController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final Rx<CartModel?> cart = Rx<CartModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString customerNote = ''.obs;
  final Rx<PaymentMethod> selectedPaymentMethod = PaymentMethod.cod.obs;
  final RxString promoCode = ''.obs;
  final RxDouble promoDiscount = 0.0.obs;

  bool get hasItems => cart.value != null && !cart.value!.isEmpty;
  double get subtotal => cart.value?.subtotal ?? 0;
  double get deliveryFee => AppConstants.defaultDeliveryFee;
  double get discount => promoDiscount.value;
  double get total => subtotal + deliveryFee - discount;
  int get itemCount => cart.value?.totalItems ?? 0;

  /// ── Add to cart ──
  void addToCart({
    required ProductModel product,
    required String shopId,
    required String shopName,
    List<SelectedAddon> addons = const [],
    String? note,
    int quantity = 1,
  }) {
    // If cart has items from different shop, ask to clear
    if (cart.value != null && cart.value!.shopId != shopId && !cart.value!.isEmpty) {
      _showDifferentShopDialog(product, shopId, shopName, addons, note, quantity);
      return;
    }

    final item = CartItem(
      productId: product.id,
      productName: product.name,
      productImage: product.image,
      basePrice: product.price,
      quantity: quantity,
      addons: addons,
      note: note,
    );

    if (cart.value == null || cart.value!.shopId != shopId) {
      cart.value = CartModel(
        shopId: shopId,
        shopName: shopName,
        items: [item],
      );
    } else {
      // Check if same product exists (merge or add new)
      final existingIndex = cart.value!.items.indexWhere(
        (i) => i.productId == product.id && _sameAddons(i.addons, addons),
      );

      final currentItems = List<CartItem>.from(cart.value!.items);
      if (existingIndex >= 0) {
        final existing = currentItems[existingIndex];
        currentItems[existingIndex] =
            existing.copyWith(quantity: existing.quantity + quantity);
      } else {
        currentItems.add(item);
      }

      cart.value = cart.value!.copyWith(items: currentItems);
    }

    Log.i('Added to cart: ${product.name} x$quantity');
    Helpers.showSuccess('ເພີ່ມໃສ່ກະຕ່າແລ້ວ');
  }

  /// ── Update quantity ──
  void updateQuantity(int index, int newQuantity) {
    if (cart.value == null) return;
    final items = List<CartItem>.from(cart.value!.items);

    if (newQuantity <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: newQuantity);
    }

    if (items.isEmpty) {
      cart.value = null;
    } else {
      cart.value = cart.value!.copyWith(items: items);
    }
  }

  /// ── Remove item ──
  void removeItem(int index) {
    updateQuantity(index, 0);
  }

  /// ── Clear cart ──
  void clearCart() {
    cart.value = null;
    promoCode.value = '';
    promoDiscount.value = 0;
    customerNote.value = '';
  }

  /// ── Checkout ──
  Future<void> checkout() async {
    if (!hasItems) return;

    final user = _authService.userModel;
    if (user == null) return;

    final address = user.defaultAddress;
    if (address == null) {
      Helpers.showWarning('ກະລຸນາເລືອກທີ່ຢູ່ສົ່ງ');
      return;
    }

    isLoading.value = true;
    try {
      final order = OrderModel(
        id: '',
        customerId: user.uid,
        customerName: user.name,
        customerPhone: user.phone,
        shopId: cart.value!.shopId,
        shopName: cart.value!.shopName,
        items: cart.value!.items,
        deliveryAddress: address.address,
        deliveryLat: address.latitude,
        deliveryLng: address.longitude,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
        status: OrderStatus.placed.value,
        paymentMethod: selectedPaymentMethod.value.value,
        paymentStatus: selectedPaymentMethod.value == PaymentMethod.cod
            ? PaymentStatus.unpaid.value
            : PaymentStatus.paid.value,
        promoCode: promoCode.value.isEmpty ? null : promoCode.value,
        promoDiscount: promoDiscount.value,
        customerNote:
            customerNote.value.isEmpty ? null : customerNote.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final orderId = await _firestoreService.createOrder(order);
      clearCart();
      Helpers.showSuccess('ສັ່ງອາຫານສຳເລັດ!');
      Get.offNamed(AppRoutes.orderTracking, arguments: orderId);
    } catch (e) {
      Log.e('Checkout error', e);
      Helpers.showError('ສັ່ງບໍ່ສຳເລັດ: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _sameAddons(List<SelectedAddon> a, List<SelectedAddon> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].itemId != b[i].itemId) return false;
    }
    return true;
  }

  void _showDifferentShopDialog(
    ProductModel product,
    String shopId,
    String shopName,
    List<SelectedAddon> addons,
    String? note,
    int quantity,
  ) async {
    final result = await Helpers.showConfirmDialog(
      title: 'ປ່ຽນຮ້ານ?',
      message:
          'ກະຕ່າມີອາຫານຈາກ ${cart.value!.shopName}. ຕ້ອງການລ້າງແລ້ວເພີ່ມຈາກ $shopName ບໍ?',
      confirmText: 'ລ້າງ & ເພີ່ມ',
    );
    if (result) {
      clearCart();
      addToCart(
        product: product,
        shopId: shopId,
        shopName: shopName,
        addons: addons,
        note: note,
        quantity: quantity,
      );
    }
  }
}
