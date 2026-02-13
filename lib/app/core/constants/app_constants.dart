class AppConstants {
  AppConstants._();

  // ── App Info ──
  static const String appName = 'Lao Food';
  static const String appVersion = '1.0.0';
  static const String currency = '₭';
  static const String currencyCode = 'LAK';

  // ── Roles ──
  static const String roleAdmin = 'admin';
  static const String roleShop = 'shop';
  static const String roleRider = 'rider';
  static const String roleCustomer = 'customer';

  // ── Firestore Collections ──
  static const String usersCollection = 'users';
  static const String shopsCollection = 'shops';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String reviewsCollection = 'reviews';
  static const String categoriesCollection = 'categories';
  static const String settingsCollection = 'settings';

  // ── Storage Paths ──
  static const String profileImagesPath = 'profile_images';
  static const String shopImagesPath = 'shop_images';
  static const String productImagesPath = 'product_images';
  static const String chatImagesPath = 'chat_images';

  // ── Default Values ──
  static const double defaultDeliveryFee = 15000;
  static const double minOrderAmount = 20000;
  static const double defaultCommissionRate = 0.15; // 15%
  static const int maxDeliveryDistanceKm = 15;
  static const int orderCancelTimeMinutes = 5;

  // ── Pagination ──
  static const int pageSize = 20;
  static const int chatPageSize = 50;

  // ── Validation ──
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxNoteLength = 200;
  static const int phoneLength = 10;

  // ── Image ──
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
  static const int imageQuality = 80;
  static const double maxImageSizeMB = 5.0;

  // ── Location ──
  static const double defaultLat = 17.9757;
  static const double defaultLng = 102.6331;
  static const int locationUpdateIntervalSec = 10;
}
