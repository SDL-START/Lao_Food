import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/logger_utils.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/chat_service.dart';

class ChatController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ChatService _chatService = Get.find<ChatService>();

  final RxList<ChatRoom> chatRooms = <ChatRoom>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final Rx<ChatRoom?> currentRoom = Rx<ChatRoom?>(null);
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final RxBool isLoading = true.obs;

  String get userId => _authService.uid;
  String get userName => _authService.userModel?.name ?? '';

  @override
  void onInit() {
    super.onInit();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    _chatService.streamChatRooms(userId).listen((rooms) {
      chatRooms.value = rooms;
      isLoading.value = false;
    });
  }

  void openChatRoom(String chatRoomId) {
    _chatService.streamMessages(chatRoomId).listen((msgs) {
      messages.value = msgs;
      // Auto scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    // Mark as read
    _chatService.markAsRead(chatRoomId, userId);
  }

  Future<void> sendMessage(String chatRoomId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();
    try {
      await _chatService.sendMessage(
        chatRoomId: chatRoomId,
        senderId: userId,
        senderName: userName,
        text: text,
      );
    } catch (e) {
      Log.e('Send message error', e);
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
