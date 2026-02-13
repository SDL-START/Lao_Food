import 'addon_model.dart';

/// ── Single cart item ──
class CartItem {
  final String productId;
  final String productName;
  final String? productImage;
  final double basePrice;
  final int quantity;
  final List<SelectedAddon> addons;
  final String? note;

  CartItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.basePrice,
    this.quantity = 1,
    this.addons = const [],
    this.note,
  });

  /// Total price = (base + addons) * quantity
  double get totalPrice {
    final addonTotal = addons.fold(0.0, (sum, a) => sum + a.price);
    return (basePrice + addonTotal) * quantity;
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'],
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      addons: (map['addons'] as List<dynamic>?)
              ?.map((a) => SelectedAddon.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'basePrice': basePrice,
      'quantity': quantity,
      'addons': addons.map((a) => a.toMap()).toList(),
      'note': note,
    };
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? basePrice,
    int? quantity,
    List<SelectedAddon>? addons,
    String? note,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      addons: addons ?? this.addons,
      note: note ?? this.note,
    );
  }
}

/// ── Cart model (per shop) ──
class CartModel {
  final String shopId;
  final String shopName;
  final List<CartItem> items;

  CartModel({
    required this.shopId,
    required this.shopName,
    this.items = const [],
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  CartModel copyWith({
    String? shopId,
    String? shopName,
    List<CartItem>? items,
  }) {
    return CartModel(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      items: items ?? this.items,
    );
  }
}
