import 'address_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // admin, shop, rider, customer
  final String? profileImage;
  final bool isActive;
  final bool isOnline; // for riders
  final List<AddressModel> addresses;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Rider-specific
  final String? vehicleType;
  final String? vehiclePlate;
  final String? idCardImage;
  final bool isVerified;
  final double? currentLat;
  final double? currentLng;

  // Shop-specific (shopId reference)
  final String? shopId;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
    this.isActive = true,
    this.isOnline = false,
    this.addresses = const [],
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleType,
    this.vehiclePlate,
    this.idCardImage,
    this.isVerified = false,
    this.currentLat,
    this.currentLng,
    this.shopId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'customer',
      profileImage: map['profileImage'],
      isActive: map['isActive'] ?? true,
      isOnline: map['isOnline'] ?? false,
      addresses: (map['addresses'] as List<dynamic>?)
              ?.map((a) => AddressModel.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt'].millisecondsSinceEpoch)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['updatedAt'].millisecondsSinceEpoch)
          : DateTime.now(),
      vehicleType: map['vehicleType'],
      vehiclePlate: map['vehiclePlate'],
      idCardImage: map['idCardImage'],
      isVerified: map['isVerified'] ?? false,
      currentLat: map['currentLat']?.toDouble(),
      currentLng: map['currentLng']?.toDouble(),
      shopId: map['shopId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'profileImage': profileImage,
      'isActive': isActive,
      'isOnline': isOnline,
      'addresses': addresses.map((a) => a.toMap()).toList(),
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'idCardImage': idCardImage,
      'isVerified': isVerified,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'shopId': shopId,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isShop => role == 'shop';
  bool get isRider => role == 'rider';
  bool get isCustomer => role == 'customer';

  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    bool? isActive,
    bool? isOnline,
    List<AddressModel>? addresses,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vehicleType,
    String? vehiclePlate,
    String? idCardImage,
    bool? isVerified,
    double? currentLat,
    double? currentLng,
    String? shopId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      isOnline: isOnline ?? this.isOnline,
      addresses: addresses ?? this.addresses,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      idCardImage: idCardImage ?? this.idCardImage,
      isVerified: isVerified ?? this.isVerified,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      shopId: shopId ?? this.shopId,
    );
  }
}
