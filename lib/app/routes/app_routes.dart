abstract class AppRoutes {
  // ── Auth ──
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // ── Customer ──
  static const String customerHome = '/customer/home';
  static const String shopDetail = '/customer/shop-detail';
  static const String productDetail = '/customer/product-detail';
  static const String cart = '/customer/cart';
  static const String checkout = '/customer/checkout';
  static const String orderTracking = '/customer/order-tracking';
  static const String orderHistory = '/customer/order-history';
  static const String review = '/customer/review';

  // ── Shop ──
  static const String shopHome = '/shop/home';
  static const String shopOrders = '/shop/orders';
  static const String menuManagement = '/shop/menu';
  static const String addProduct = '/shop/add-product';
  static const String shopReport = '/shop/report';

  // ── Rider ──
  static const String riderHome = '/rider/home';
  static const String riderOrderDetail = '/rider/order-detail';

  // ── Admin ──
  static const String adminHome = '/admin/home';
  static const String adminUsers = '/admin/users';
  static const String adminShops = '/admin/shops';
  static const String adminOrders = '/admin/orders';
  static const String adminAddUser = '/admin/add-user';
  static const String adminSettings = '/admin/settings';

  // ── Chat ──
  static const String chatList = '/chat/list';
  static const String chatRoom = '/chat/room';
}
