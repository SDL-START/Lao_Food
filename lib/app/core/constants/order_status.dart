import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ── Order Status ── unified across all roles
enum OrderStatus {
  placed('PLACED', 'ສັ່ງແລ້ວ', AppColors.orderPlaced, Icons.receipt_long),
  shopAccepted('SHOP_ACCEPTED', 'ຮ້ານຮັບອໍເດີ', AppColors.orderAccepted, Icons.check_circle),
  shopRejected('SHOP_REJECTED', 'ຮ້ານປະຕິເສດ', AppColors.orderCancelled, Icons.cancel),
  preparing('PREPARING', 'ກຳລັງກະກຽມ', AppColors.orderPreparing, Icons.restaurant),
  readyForPickup('READY_FOR_PICKUP', 'ພ້ອມໃຫ້ຮັບ', AppColors.orderReady, Icons.takeout_dining),
  riderAssigned('RIDER_ASSIGNED', 'Rider ຮັບແລ້ວ', AppColors.orderPickedUp, Icons.two_wheeler),
  pickedUp('PICKED_UP', 'ຮັບອາຫານແລ້ວ', AppColors.orderPickedUp, Icons.local_shipping),
  onTheWay('ON_THE_WAY', 'ກຳລັງສົ່ງ', AppColors.orderOnTheWay, Icons.delivery_dining),
  delivered('DELIVERED', 'ສົ່ງສຳເລັດ', AppColors.orderDelivered, Icons.check_circle_outline),
  cancelled('CANCELLED', 'ຍົກເລີກ', AppColors.orderCancelled, Icons.block),
  failed('FAILED', 'ລົ້ມເຫຼວ', AppColors.orderCancelled, Icons.error_outline);

  const OrderStatus(this.value, this.label, this.color, this.icon);

  final String value;
  final String label;
  final Color color;
  final IconData icon;

  static OrderStatus fromValue(String value) {
    return OrderStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => OrderStatus.placed,
    );
  }

  /// Whether the order can be cancelled by customer
  bool get canCancel =>
      this == OrderStatus.placed || this == OrderStatus.shopAccepted;

  /// Whether the order is active (not terminal)
  bool get isActive =>
      this != OrderStatus.delivered &&
      this != OrderStatus.cancelled &&
      this != OrderStatus.failed &&
      this != OrderStatus.shopRejected;

  /// Whether rider location should be tracked
  bool get shouldTrackRider =>
      this == OrderStatus.riderAssigned ||
      this == OrderStatus.pickedUp ||
      this == OrderStatus.onTheWay;
}

/// ── Payment Status ──
enum PaymentStatus {
  unpaid('UNPAID', 'ຍັງບໍ່ຈ່າຍ'),
  paid('PAID', 'ຈ່າຍແລ້ວ'),
  refunded('REFUNDED', 'ຄືນເງິນ');

  const PaymentStatus(this.value, this.label);
  final String value;
  final String label;

  static PaymentStatus fromValue(String value) {
    return PaymentStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => PaymentStatus.unpaid,
    );
  }
}

/// ── Payment Method ──
enum PaymentMethod {
  cod('COD', 'ເກັບເງິນປາຍທາງ', Icons.money),
  online('ONLINE', 'ຈ່າຍອອນໄລ', Icons.payment);

  const PaymentMethod(this.value, this.label, this.icon);
  final String value;
  final String label;
  final IconData icon;

  static PaymentMethod fromValue(String value) {
    return PaymentMethod.values.firstWhere(
      (s) => s.value == value,
      orElse: () => PaymentMethod.cod,
    );
  }
}
