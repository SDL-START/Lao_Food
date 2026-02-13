import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/user_model.dart';
import '../controllers/admin_controller.dart';

class ManageUsersScreen extends GetView<AdminController> {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ຈັດການຜູ້ໃຊ້'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ລູກຄ້າ'),
              Tab(text: 'Riders'),
              Tab(text: 'ຮ້ານ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(controller.customers),
            _buildUserList(controller.riders),
            _buildUserList(controller.shopOwners),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(RxList<UserModel> users) {
    return Obx(() {
      if (users.isEmpty) {
        return const EmptyState(
          icon: Icons.people_outline,
          title: 'ບໍ່ມີຜູ້ໃຊ້',
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: users.length,
        itemBuilder: (_, i) => _buildUserTile(users[i]),
      );
    });
  }

  Widget _buildUserTile(UserModel user) {
    return AppCard(
      onTap: () => _showUserActions(user),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                user.isActive ? AppColors.primary : AppColors.offline,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (user.isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          color: AppColors.info, size: 16),
                    ],
                  ],
                ),
                Text(
                  '${user.email} • ${user.phone}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                Text(
                  'ລົງທະບຽນ: ${Helpers.formatDate(user.createdAt)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          StatusBadge(
            text: user.isActive ? 'Active' : 'Banned',
            color: user.isActive ? AppColors.success : AppColors.error,
          ),
        ],
      ),
    );
  }

  void _showUserActions(UserModel user) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              '${user.role.toUpperCase()} • ${user.email}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const Divider(height: 24),
            ListTile(
              leading: Icon(
                user.isActive ? Icons.block : Icons.check_circle,
                color: user.isActive ? AppColors.error : AppColors.success,
              ),
              title: Text(user.isActive ? 'ລະງັບບັນຊີ' : 'ເປີດໃຊ້ງານ'),
              onTap: () {
                Get.back();
                controller.toggleUserActive(user);
              },
            ),
            if (!user.isVerified && (user.isRider || user.isShop))
              ListTile(
                leading:
                    const Icon(Icons.verified, color: AppColors.info),
                title: const Text('ຢືນຢັນ (Verify)'),
                onTap: () {
                  Get.back();
                  controller.verifyUser(user);
                },
              ),
          ],
        ),
      ),
    );
  }
}
