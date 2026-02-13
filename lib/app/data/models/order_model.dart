import 'cart_model.dart';
import '../../core/constants/order_status.dart';

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String shopId;
  final String shopName;
  final String? riderId;
  final String? riderName;
  final String? riderPhone;

  // ── Items ──
  final List<CartItem> items;

  // ── Address ──
  final String deliveryAddress;
  final double deliveryLat;
  final double deliveryLng;

  // ── Pricing ──
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  // ── Status ──
  final String status; // OrderStatus.value
  final String paymentMethod; // PaymentMethod.value
  final String paymentStatus; // PaymentStatus.value

  // ── COD ──
  final bool codCollected;
  final DateTime? codCollectedAt;

  // ── Promo ──
  final String? promoCode;
  final double promoDiscount;

  // ── Notes ──
  final String? customerNote;
  final String? cancelReason;
  final String? failReason;

  // ── Timestamps ──
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? acceptedAt;
  final DateTime? preparingAt;
  final DateTime? readyAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;

  // ── Chat ──
  final String? chatId;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.shopId,
    required this.shopName,
    this.riderId,
    this.riderName,
    this.riderPhone,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.subtotal,
    required this.deliveryFee,
    this.discount = 0,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.codCollected = false,
    this.codCollectedAt,
    this.promoCode,
    this.promoDiscount = 0,
    this.customerNote,
    this.cancelReason,
    this.failReason,
    required this.createdAt,
    required this.updatedAt,
    this.acceptedAt,
    this.preparingAt,
    this.readyAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancelledAt,
    this.chatId,
  });

  OrderStatus get orderStatus => OrderStatus.fromValue(status);
  PaymentMethod get orderPaymentMethod => PaymentMethod.fromValue(paymentMethod);
  PaymentStatus get orderPaymentStatus => PaymentStatus.fromValue(paymentStatus);

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      shopId: map['shopId'] ?? '',
      shopName: map['shopName'] ?? '',
      riderId: map['riderId'],
      riderName: map['riderName'],
      riderPhone: map['riderPhone'],
      items: (map['items'] as List<dynamic>?)
              ?.map((i) => CartItem.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryLat: (map['deliveryLat'] ?? 0).toDouble(),
      deliveryLng: (map['deliveryLng'] ?? 0).toDouble(),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? 'PLACED',
      paymentMethod: map['paymentMethod'] ?? 'COD',
      paymentStatus: map['paymentStatus'] ?? 'UNPAID',
      codCollected: map['codCollected'] ?? false,
      codCollectedAt: _parseTimestamp(map['codCollectedAt']),
      promoCode: map['promoCode'],
      promoDiscount: (map['promoDiscount'] ?? 0).toDouble(),
      customerNote: map['customerNote'],
      cancelReason: map['cancelReason'],
      failReason: map['failReason'],
      createdAt: _parseTimestamp(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseTimestamp(map['updatedAt']) ?? DateTime.now(),
      acceptedAt: _parseTimestamp(map['acceptedAt']),
      preparingAt: _parseTimestamp(map['preparingAt']),
      readyAt: _parseTimestamp(map['readyAt']),
      pickedUpAt: _parseTimestamp(map['pickedUpAt']),
      deliveredAt: _parseTimestamp(map['deliveredAt']),
      cancelledAt: _parseTimestamp(map['cancelledAt']),
      chatId: map['chatId'],
    );
  }

  static DateTime? _parseTimestamp(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val;
    try {
      return DateTime.fromMillisecondsSinceEpoch(val.millisecondsSinceEpoch);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'shopId': shopId,
      'shopName': shopName,
      'riderId': riderId,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'items': items.map((i) => i.toMap()).toList(),
      'deliveryAddress': deliveryAddress,
      'deliveryLat': deliveryLat,
      'deliveryLng': deliveryLng,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'codCollected': codCollected,
      'codCollectedAt': codCollectedAt,
      'promoCode': promoCode,
      'promoDiscount': promoDiscount,
      'customerNote': customerNote,
      'cancelReason': cancelReason,
      'failReason': failReason,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'acceptedAt': acceptedAt,
      'preparingAt': preparingAt,
      'readyAt': readyAt,
      'pickedUpAt': pickedUpAt,
      'deliveredAt': deliveredAt,
      'cancelledAt': cancelledAt,
      'chatId': chatId,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? shopId,
    String? shopName,
    String? riderId,
    String? riderName,
    String? riderPhone,
    List<CartItem>? items,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    double? subtotal,
    double? deliveryFee,
    double? discount,
    double? total,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    bool? codCollected,
    DateTime? codCollectedAt,
    String? promoCode,
    double? promoDiscount,
    String? customerNote,
    String? cancelReason,
    String? failReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    DateTime? preparingAt,
    DateTime? readyAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? chatId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      riderPhone: riderPhone ?? this.riderPhone,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLat: deliveryLat ?? this.deliveryLat,
      deliveryLng: deliveryLng ?? this.deliveryLng,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      codCollected: codCollected ?? this.codCollected,
      codCollectedAt: codCollectedAt ?? this.codCollectedAt,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
      customerNote: customerNote ?? this.customerNote,
      cancelReason: cancelReason ?? this.cancelReason,
      failReason: failReason ?? this.failReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      preparingAt: preparingAt ?? this.preparingAt,
      readyAt: readyAt ?? this.readyAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      chatId: chatId ?? this.chatId,
    );
  }
}
