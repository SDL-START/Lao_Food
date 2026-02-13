/// ── Chat Room (1 order = 1 room) ──
class ChatRoom {
  final String id;
  final String orderId;
  final String customerId;
  final String customerName;
  final String riderId;
  final String riderName;
  final String? shopId;
  final String? shopName;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCount; // {userId: count}
  final bool isActive;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.riderId,
    required this.riderName,
    this.shopId,
    this.shopName,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = const {},
    this.isActive = true,
    required this.createdAt,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      orderId: map['orderId'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      riderId: map['riderId'] ?? '',
      riderName: map['riderName'] ?? '',
      shopId: map['shopId'],
      shopName: map['shopName'],
      lastMessage: map['lastMessage'],
      lastMessageAt: map['lastMessageAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['lastMessageAt'].millisecondsSinceEpoch)
          : null,
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? {}),
      isActive: map['isActive'] ?? true,
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
      'riderId': riderId,
      'riderName': riderName,
      'shopId': shopId,
      'shopName': shopName,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt,
      'unreadCount': unreadCount,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}

/// ── Chat Message ──
class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String text;
  final String? imageUrl;
  final String type; // text, image, system
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.imageUrl,
    this.type = 'text',
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      type: map['type'] ?? 'text',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['createdAt'].millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'imageUrl': imageUrl,
      'type': type,
      'createdAt': createdAt,
    };
  }
}
