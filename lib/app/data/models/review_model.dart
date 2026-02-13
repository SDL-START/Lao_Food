class ReviewModel {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName;
  final String? customerImage;

  // Shop review
  final String? shopId;
  final double shopRating;
  final String? shopComment;

  // Rider review
  final String? riderId;
  final double riderRating;
  final String? riderComment;

  final List<String> images;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    this.customerImage,
    this.shopId,
    this.shopRating = 0,
    this.shopComment,
    this.riderId,
    this.riderRating = 0,
    this.riderComment,
    this.images = const [],
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      orderId: map['orderId'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerImage: map['customerImage'],
      shopId: map['shopId'],
      shopRating: (map['shopRating'] ?? 0).toDouble(),
      shopComment: map['shopComment'],
      riderId: map['riderId'],
      riderRating: (map['riderRating'] ?? 0).toDouble(),
      riderComment: map['riderComment'],
      images: List<String>.from(map['images'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt'].millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'customerImage': customerImage,
      'shopId': shopId,
      'shopRating': shopRating,
      'shopComment': shopComment,
      'riderId': riderId,
      'riderRating': riderRating,
      'riderComment': riderComment,
      'images': images,
      'createdAt': createdAt,
    };
  }
}
