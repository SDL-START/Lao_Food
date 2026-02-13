import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger_utils.dart';
import '../models/chat_model.dart';

class ChatService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ── Create chat room when rider accepts order ──
  Future<String> createChatRoom({
    required String orderId,
    required String customerId,
    required String customerName,
    required String riderId,
    required String riderName,
    String? shopId,
    String? shopName,
  }) async {
    try {
      final chatId = const Uuid().v4();
      final room = ChatRoom(
        id: chatId,
        orderId: orderId,
        customerId: customerId,
        customerName: customerName,
        riderId: riderId,
        riderName: riderName,
        shopId: shopId,
        shopName: shopName,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .set(room.toMap());

      // Update order with chatId
      await _db
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({'chatId': chatId});

      Log.i('Chat room created: $chatId for order: $orderId');
      return chatId;
    } catch (e) {
      Log.e('Error creating chat room', e);
      rethrow;
    }
  }

  /// ── Send message ──
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String text,
    String? imageUrl,
    String type = 'text',
  }) async {
    try {
      final messageId = const Uuid().v4();
      final message = ChatMessage(
        id: messageId,
        chatRoomId: chatRoomId,
        senderId: senderId,
        senderName: senderName,
        text: text,
        imageUrl: imageUrl,
        type: type,
        createdAt: DateTime.now(),
      );

      // Add message
      await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatRoomId)
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .set(message.toMap());

      // Update last message on room
      await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatRoomId)
          .update({
        'lastMessage': text,
        'lastMessageAt': DateTime.now(),
      });

      Log.d('Message sent in: $chatRoomId');
    } catch (e) {
      Log.e('Error sending message', e);
      rethrow;
    }
  }

  /// ── Stream messages ──
  Stream<List<ChatMessage>> streamMessages(String chatRoomId) {
    return _db
        .collection(AppConstants.chatsCollection)
        .doc(chatRoomId)
        .collection(AppConstants.messagesCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ChatMessage.fromMap(d.data()))
            .toList());
  }

  /// ── Stream chat rooms for user ──
  Stream<List<ChatRoom>> streamChatRooms(String userId) {
    return _db
        .collection(AppConstants.chatsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ChatRoom.fromMap(d.data() as Map<String, dynamic>))
            .where((room) =>
                room.customerId == userId ||
                room.riderId == userId ||
                room.shopId == userId)
            .toList());
  }

  /// ── Mark messages as read ──
  Future<void> markAsRead(String chatRoomId, String userId) async {
    try {
      await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatRoomId)
          .update({'unreadCount.$userId': 0});
    } catch (e) {
      Log.e('Error marking as read', e);
    }
  }

  /// ── Close chat room ──
  Future<void> closeChatRoom(String chatRoomId) async {
    try {
      await _db
          .collection(AppConstants.chatsCollection)
          .doc(chatRoomId)
          .update({'isActive': false});
    } catch (e) {
      Log.e('Error closing chat room', e);
    }
  }
}
