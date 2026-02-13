import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/order_status.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/shop_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class AdminController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final RxInt currentNavIndex = 0.obs;
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> customers = <UserModel>[].obs;
  final RxList<UserModel> riders = <UserModel>[].obs;
  final RxList<UserModel> shopOwners = <UserModel>[].obs;
  final RxList<ShopModel> allShops = <ShopModel>[].obs;
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    _firestoreService.getAllUsers().listen((list) {
      allUsers.value = list;
      customers.value = list
          .where((u) => u.role == AppConstants.roleCustomer)
          .toList();
      riders.value = list
          .where((u) => u.role == AppConstants.roleRider)
          .toList();
      shopOwners.value = list
          .where((u) => u.role == AppConstants.roleShop)
          .toList();
      isLoading.value = false;
    });

    _firestoreService.getShops(onlyActive: false).listen((list) {
      allShops.value = list;
    });

    _firestoreService.getAllOrders().listen((list) {
      allOrders.value = list;
    });
  }

  // ── Stats ──
  int get totalUsers => allUsers.length;
  int get totalShops => allShops.length;
  int get totalRiders => riders.length;
  int get totalOrders => allOrders.length;
  int get activeOrders => allOrders.where((o) => o.orderStatus.isActive).length;
  double get totalRevenue => allOrders
      .where((o) => o.status == OrderStatus.delivered.value)
      .fold(0.0, (sum, o) => sum + o.total);
  double get totalCommission =>
      totalRevenue * AppConstants.defaultCommissionRate;

  // ── User Management ──
  Future<void> toggleUserActive(UserModel user) async {
    try {
      await _firestoreService.updateUser(user.uid, {
        'isActive': !user.isActive,
      });
      Helpers.showSuccess(user.isActive ? 'ລະງັບແລ້ວ' : 'ເປີດໃຊ້ງານແລ້ວ');
      Log.i('User ${user.uid} active: ${!user.isActive}');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  Future<void> verifyUser(UserModel user) async {
    try {
      await _firestoreService.updateUser(user.uid, {'isVerified': true});
      Helpers.showSuccess('ຢືນຢັນແລ້ວ');
    } catch (e) {
      Helpers.showError('ຢືນຢັນບໍ່ສຳເລັດ');
    }
  }

  // ── Shop Management ──
  Future<void> toggleShopActive(ShopModel shop) async {
    try {
      await _firestoreService.updateShop(shop.id, {'isActive': !shop.isActive});
      Helpers.showSuccess(shop.isActive ? 'ປິດຮ້ານແລ້ວ' : 'ເປີດຮ້ານແລ້ວ');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  Future<void> verifyShop(ShopModel shop) async {
    try {
      await _firestoreService.updateShop(shop.id, {'isVerified': true});
      Helpers.showSuccess('ຢືນຢັນຮ້ານແລ້ວ');
    } catch (e) {
      Helpers.showError('ຢືນຢັນບໍ່ສຳເລັດ');
    }
  }

  Future<void> updateCommission(String shopId, double rate) async {
    try {
      await _firestoreService.updateShop(shopId, {'commissionRate': rate});
      Helpers.showSuccess('ອັບເດດ Commission ແລ້ວ');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
    }
  }

  // ── Create Shop/Rider user ──
  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? shopId,
  }) async {
    try {
      await _authService.createUserByAdmin(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
        shopId: shopId,
      );
      Helpers.showSuccess('ສ້າງບັນຊີແລ້ວ');
    } catch (e) {
      Helpers.showError(e.toString());
    }
  }

  // ── Order disputes ──
  Future<void> refundOrder(String orderId) async {
    try {
      await _firestoreService.updateOrder(orderId, {
        'paymentStatus': PaymentStatus.refunded.value,
      });
      Helpers.showSuccess('ຄືນເງິນແລ້ວ');
    } catch (e) {
      Helpers.showError('ຄືນເງິນບໍ່ສຳເລັດ');
    }
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
  }

  // ── Admin profile ──
  UserModel? get adminUser => _authService.currentUser.value;

  Future<void> updateAdminField(String field, String value) async {
    if (adminUser == null) return;
    try {
      isUpdating.value = true;
      await _firestoreService.updateUser(adminUser!.uid, {field: value.trim()});
      await _authService.refreshUser();
      Helpers.showSuccess('ອັບເດດສຳເລັດ');
      Log.i('Admin profile $field updated');
    } catch (e) {
      Helpers.showError('ອັບເດດບໍ່ສຳເລັດ');
      Log.e('Error updating admin $field', e);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isUpdating.value = true;
      final user = _authService.user;
      if (user == null || user.email == null) return;

      // Re-authenticate
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        ),
      );

      // Update password
      await user.updatePassword(newPassword);
      Helpers.showSuccess('ປ່ຽນລະຫັດຜ່ານສຳເລັດ');
      Log.i('Admin password changed');
    } catch (e) {
      Helpers.showError('ລະຫັດຜ່ານເກົ່າບໍ່ຖືກຕ້ອງ');
      Log.e('Error changing password', e);
    } finally {
      isUpdating.value = false;
    }
  }
}
