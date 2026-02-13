import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';
import '../controllers/chat_controller.dart';

class ChatListScreen extends GetView<ChatController> {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ແຊັດ')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }
        if (controller.chatRooms.isEmpty) {
          return const EmptyState(
            icon: Icons.chat_outlined,
            title: 'ບໍ່ມີການສົນທະນາ',
            subtitle: 'ການສົນທະນາຈະປາກົດເມື່ອ Rider ຮັບອໍເດີ',
          );
        }
        return ListView.builder(
          itemCount: controller.chatRooms.length,
          itemBuilder: (_, i) {
            final room = controller.chatRooms[i];
            final isCustomer = room.customerId == controller.userId;
            final otherName =
                isCustomer ? room.riderName : room.customerName;
            final unread =
                room.unreadCount[controller.userId] ?? 0;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      otherName,
                      style: TextStyle(
                        fontWeight:
                            unread > 0 ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (room.lastMessageAt != null)
                    Text(
                      Helpers.timeAgo(room.lastMessageAt!),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                ],
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Text(
                      room.lastMessage ?? 'ເລີ່ມສົນທະນາ',
                      style: TextStyle(
                        fontSize: 13,
                        color: unread > 0
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight:
                            unread > 0 ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () =>
                  Get.toNamed(AppRoutes.chatRoom, arguments: room.id),
            );
          },
        );
      }),
    );
  }
}
