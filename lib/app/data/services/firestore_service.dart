import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger_utils.dart';
import '../models/shop_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ═══════════════════════════════════════════
  //  SHOPS
  // ═══════════════════════════════════════════

  Stream<List<ShopModel>> getShops({bool onlyActive = true}) {
    Query query = _db.collection(AppConstants.shopsCollection);
    if (onlyActive) {
      query = query.where('isActive', isEqualTo: true);
    }
    return query.orderBy('name').snapshots().map((snap) =>
        snap.docs.map((d) => ShopModel.fromMap(d.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<ShopModel>> getShopsByCategory(String category) {
    return _db
        .collection(AppConstants.shopsCollection)
        .where('isActive', isEqualTo: true)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ShopModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<ShopModel?> getShopById(String shopId) async {
    try {
      final doc =
          await _db.collection(AppConstants.shopsCollection).doc(shopId).get();
      if (doc.exists) {
        return ShopModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      Log.e('Error getting shop', e);
      return null;
    }
  }

  Stream<ShopModel?> streamShop(String shopId) {
    return _db
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .snapshots()
        .map((doc) => doc.exists ? ShopModel.fromMap(doc.data()!) : null);
  }

  Future<String> createShop(ShopModel shop) async {
    try {
      final ref = _db.collection(AppConstants.shopsCollection).doc();
      final newShop = shop.copyWith(id: ref.id);
      await ref.set(newShop.toMap());
      Log.i('Shop created: ${newShop.name}');
      return ref.id;
    } catch (e) {
      Log.e('Error creating shop', e);
      rethrow;
    }
  }

  Future<void> updateShop(String shopId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _db
          .collection(AppConstants.shopsCollection)
          .doc(shopId)
          .update(data);
    } catch (e) {
      Log.e('Error updating shop', e);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  //  PRODUCTS
  // ═══════════════════════════════════════════

  Stream<List<ProductModel>> getProducts(String shopId) {
    return _db
        .collection(AppConstants.shopsCollection)
        .doc(shopId)
        .collection(AppConstants.productsCollection)
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ProductModel.fromMap(d.data()))
            .toList());
  }

  Future<String> createProduct(ProductModel product) async {
    try {
      final ref = _db
          .collection(AppConstants.shopsCollection)
          .doc(product.shopId)
          .collection(AppConstants.productsCollection)
          .doc();
      final newProduct = product.copyWith(id: ref.id);
      await ref.set(newProduct.toMap());
      Log.i('Product created: ${newProduct.name}');
      return ref.id;
    } catch (e) {
      Log.e('Error creating product', e);
      rethrow;
    }
  }

  Future<void> updateProduct(
      String shopId, String productId, Map<String, dynamic> data) async {
    try {
      await _db
          .collection(AppConstants.shopsCollection)
          .doc(shopId)
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .update(data);
    } catch (e) {
      Log.e('Error updating product', e);
      rethrow;
    }
  }

  Future<void> deleteProduct(String shopId, String productId) async {
    try {
      await _db
          .collection(AppConstants.shopsCollection)
          .doc(shopId)
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .delete();
      Log.i('Product deleted: $productId');
    } catch (e) {
      Log.e('Error deleting product', e);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  //  ORDERS
  // ═══════════════════════════════════════════

  Future<String> createOrder(OrderModel order) async {
    try {
      final ref = _db.collection(AppConstants.ordersCollection).doc();
      final newOrder = order.copyWith(id: ref.id);
      await ref.set(newOrder.toMap());
      Log.i('Order created: ${ref.id}');
      return ref.id;
    } catch (e) {
      Log.e('Error creating order', e);
      rethrow;
    }
  }

  Stream<List<OrderModel>> getOrdersByCustomer(String customerId) {
    return _db
        .collection(AppConstants.ordersCollection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<OrderModel>> getOrdersByShop(String shopId) {
    return _db
        .collection(AppConstants.ordersCollection)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<OrderModel>> getAvailableOrdersForRider() {
    return _db
        .collection(AppConstants.ordersCollection)
        .where('status', isEqualTo: 'READY_FOR_PICKUP')
        .where('riderId', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<OrderModel>> getOrdersByRider(String riderId) {
    return _db
        .collection(AppConstants.ordersCollection)
        .where('riderId', isEqualTo: riderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<OrderModel?> streamOrder(String orderId) {
    return _db
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .map((doc) =>
            doc.exists ? OrderModel.fromMap(doc.data()! as Map<String, dynamic>) : null);
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _db
        .collection(AppConstants.ordersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OrderModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _db
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update(data);
      Log.i('Order updated: $orderId -> ${data['status'] ?? 'no status change'}');
    } catch (e) {
      Log.e('Error updating order', e);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  //  USERS (Admin)
  // ═══════════════════════════════════════════

  Stream<List<UserModel>> getAllUsers() {
    return _db
        .collection(AppConstants.usersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<UserModel>> getUsersByRole(String role) {
    return _db
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: role)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update(data);
    } catch (e) {
      Log.e('Error updating user', e);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  //  RIDERS (role-specific collection)
  // ═══════════════════════════════════════════

  Stream<List<UserModel>> getAllRiders() {
    return _db
        .collection(AppConstants.ridersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateRider(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _db
          .collection(AppConstants.ridersCollection)
          .doc(uid)
          .update(data);
    } catch (e) {
      Log.e('Error updating rider', e);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  //  SHOP OWNERS (role-specific collection)
  // ═══════════════════════════════════════════

  Stream<List<UserModel>> getAllShopOwners() {
    return _db
        .collection(AppConstants.shopOwnersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateShopOwner(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _db
          .collection(AppConstants.shopOwnersCollection)
          .doc(uid)
          .update(data);
    } catch (e) {
      Log.e('Error updating shop owner', e);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  //  REVIEWS
  // ═══════════════════════════════════════════

  Future<void> createReview(ReviewModel review) async {
    try {
      final ref = _db.collection(AppConstants.reviewsCollection).doc();
      await ref.set(review.toMap()..['id'] = ref.id);

      // Update shop rating
      if (review.shopId != null && review.shopRating > 0) {
        await _updateShopRating(review.shopId!, review.shopRating);
      }
      Log.i('Review created for order: ${review.orderId}');
    } catch (e) {
      Log.e('Error creating review', e);
      rethrow;
    }
  }

  Stream<List<ReviewModel>> getReviewsByShop(String shopId) {
    return _db
        .collection(AppConstants.reviewsCollection)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ReviewModel.fromMap(d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> _updateShopRating(String shopId, double newRating) async {
    final shopDoc =
        await _db.collection(AppConstants.shopsCollection).doc(shopId).get();
    if (shopDoc.exists) {
      final data = shopDoc.data()!;
      final currentRating = (data['rating'] ?? 0).toDouble();
      final totalReviews = (data['totalReviews'] ?? 0) as int;
      final updatedRating =
          ((currentRating * totalReviews) + newRating) / (totalReviews + 1);
      await _db.collection(AppConstants.shopsCollection).doc(shopId).update({
        'rating': updatedRating,
        'totalReviews': totalReviews + 1,
      });
    }
  }

  // ═══════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════

  Stream<List<String>> getCategories() {
    return _db
        .collection(AppConstants.categoriesCollection)
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => d['name'] as String).toList());
  }
}
