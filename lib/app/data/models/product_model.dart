import 'addon_model.dart';

class ProductModel {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String? image;
  final double price;
  final String category;
  final List<AddonGroup> addonGroups;
  final bool isAvailable;
  final bool isPopular;
  final int preparationTime; // minutes
  final int sortOrder;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    required this.category,
    this.addonGroups = const [],
    this.isAvailable = true,
    this.isPopular = false,
    this.preparationTime = 15,
    this.sortOrder = 0,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      shopId: map['shopId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'],
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      addonGroups: (map['addonGroups'] as List<dynamic>?)
              ?.map((g) => AddonGroup.fromMap(g as Map<String, dynamic>))
              .toList() ??
          [],
      isAvailable: map['isAvailable'] ?? true,
      isPopular: map['isPopular'] ?? false,
      preparationTime: map['preparationTime'] ?? 15,
      sortOrder: map['sortOrder'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt'].millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'category': category,
      'addonGroups': addonGroups.map((g) => g.toMap()).toList(),
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'preparationTime': preparationTime,
      'sortOrder': sortOrder,
      'createdAt': createdAt,
    };
  }

  ProductModel copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    String? image,
    double? price,
    String? category,
    List<AddonGroup>? addonGroups,
    bool? isAvailable,
    bool? isPopular,
    int? preparationTime,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      addonGroups: addonGroups ?? this.addonGroups,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      preparationTime: preparationTime ?? this.preparationTime,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
