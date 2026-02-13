import 'package:get/get.dart';
import 'app_routes.dart';

// ── Auth ──
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/auth/views/register_screen.dart';
import '../modules/auth/views/register_admin_screen.dart';

// ── Customer ──
import '../modules/customer/bindings/customer_binding.dart';
import '../modules/customer/views/customer_home_screen.dart';
import '../modules/customer/views/shop_detail_screen.dart';
import '../modules/customer/views/cart_screen.dart';
import '../modules/customer/views/order_tracking_screen.dart';
import '../modules/customer/views/order_history_screen.dart';
import '../modules/customer/views/review_screen.dart';

// ── Shop ──
import '../modules/shop/bindings/shop_binding.dart';
import '../modules/shop/views/shop_home_screen.dart';
import '../modules/shop/views/add_product_screen.dart';
import '../modules/shop/views/shop_report_screen.dart';

// ── Rider ──
import '../modules/rider/bindings/rider_binding.dart';
import '../modules/rider/views/rider_home_screen.dart';

// ── Admin ──
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_dashboard_screen.dart';
import '../modules/admin/views/admin_add_user_screen.dart';

// ── Chat ──
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_list_screen.dart';
import '../modules/chat/views/chat_room_screen.dart';

class AppPages {
  static final pages = [
    // ═══════════════════════════════
    //  AUTH
    // ═══════════════════════════════
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.registerAdmin,
      page: () => const RegisterAdminScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // ═══════════════════════════════
    //  CUSTOMER
    // ═══════════════════════════════
    GetPage(
      name: AppRoutes.customerHome,
      page: () => const CustomerHomeScreen(),
      binding: CustomerBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.shopDetail,
      page: () => const ShopDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.orderTracking,
      page: () => const OrderTrackingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.review,
      page: () => const ReviewScreen(),
      transition: Transition.rightToLeft,
    ),

    // ═══════════════════════════════
    //  SHOP
    // ═══════════════════════════════
    GetPage(
      name: AppRoutes.shopHome,
      page: () => const ShopHomeScreen(),
      binding: ShopBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProductScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.shopReport,
      page: () => const ShopReportScreen(),
      transition: Transition.rightToLeft,
    ),

    // ═══════════════════════════════
    //  RIDER
    // ═══════════════════════════════
    GetPage(
      name: AppRoutes.riderHome,
      page: () => const RiderHomeScreen(),
      binding: RiderBinding(),
      transition: Transition.fadeIn,
    ),

    // ═══════════════════════════════
    //  ADMIN
    // ═══════════════════════════════
    GetPage(
      name: AppRoutes.adminHome,
      page: () => const AdminDashboardScreen(),
      binding: AdminBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.adminAddUser,
      page: () => const AdminAddUserScreen(),
      transition: Transition.rightToLeft,
    ),

    // ═══════════════════════════════
    //  CHAT
    // ═══════════════════════════════
    GetPage(
      name: AppRoutes.chatList,
      page: () => const ChatListScreen(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.chatRoom,
      page: () => const ChatRoomScreen(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
