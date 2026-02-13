class ShopModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String phone;
  final String? coverImage;
  final String? logoImage;
  final String address;
  final double latitude;
  final double longitude;
  final String category; // ອາຫານລາວ, ຝຣັ່ງ, ຍີ່ປຸ່ນ, etc.
  final List<String> tags;
  final bool isActive;
  final bool isVerified;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final double rating;
  final int totalReviews;
  final int totalOrders;
  final double commissionRate;
  final double minOrderAmount;
  final double deliveryFee;
  final int prepTimeMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShopModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.phone,
    this.coverImage,
    this.logoImage,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.tags = const [],
    this.isActive = true,
    this.isVerified = false,
    this.isOpen = false,
    this.openTime = '08:00',
    this.closeTime = '22:00',
    this.rating = 0,
    this.totalReviews = 0,
    this.totalOrders = 0,
    this.commissionRate = 0.15,
    this.minOrderAmount = 20000,
    this.deliveryFee = 15000,
    this.prepTimeMinutes = 20,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'] ?? '',
      coverImage: map['coverImage'],
      logoImage: map['logoImage'],
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      isActive: map['isActive'] ?? true,
      isVerified: map['isVerified'] ?? false,
      isOpen: map['isOpen'] ?? false,
      openTime: map['openTime'] ?? '08:00',
      closeTime: map['closeTime'] ?? '22:00',
      rating: (map['rating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      totalOrders: map['totalOrders'] ?? 0,
      commissionRate: (map['commissionRate'] ?? 0.15).toDouble(),
      minOrderAmount: (map['minOrderAmount'] ?? 20000).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 15000).toDouble(),
      prepTimeMinutes: map['prepTimeMinutes'] ?? 20,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt'].millisecondsSinceEpoch)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['updatedAt'].millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'phone': phone,
      'coverImage': coverImage,
      'logoImage': logoImage,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'tags': tags,
      'isActive': isActive,
      'isVerified': isVerified,
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalOrders': totalOrders,
      'commissionRate': commissionRate,
      'minOrderAmount': minOrderAmount,
      'deliveryFee': deliveryFee,
      'prepTimeMinutes': prepTimeMinutes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ShopModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? phone,
    String? coverImage,
    String? logoImage,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    List<String>? tags,
    bool? isActive,
    bool? isVerified,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    double? rating,
    int? totalReviews,
    int? totalOrders,
    double? commissionRate,
    double? minOrderAmount,
    double? deliveryFee,
    int? prepTimeMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      coverImage: coverImage ?? this.coverImage,
      logoImage: logoImage ?? this.logoImage,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalOrders: totalOrders ?? this.totalOrders,
      commissionRate: commissionRate ?? this.commissionRate,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
