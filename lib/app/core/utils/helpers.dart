import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class Helpers {
  Helpers._();

  // ── Currency ──
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'lo');
    return '${formatter.format(amount)} ${AppConstants.currency}';
  }

  // ── Date ──
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'ຫາກໍ';
    if (diff.inMinutes < 60) return '${diff.inMinutes} ນາທີກ່ອນ';
    if (diff.inHours < 24) return '${diff.inHours} ຊົ່ວໂມງກ່ອນ';
    if (diff.inDays < 7) return '${diff.inDays} ມື້ກ່ອນ';
    return formatDate(date);
  }

  // ── Snackbar ──
  static void showSuccess(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      'ສຳເລັດ',
      message,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      'ຜິດພາດ',
      message,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showWarning(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      'ແຈ້ງເຕືອນ',
      message,
      backgroundColor: AppColors.warning,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.warning, color: AppColors.textPrimary),
    );
  }

  static void showInfo(String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      'ຂໍ້ມູນ',
      message,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // ── Dialogs ──
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'ຢືນຢັນ',
    String cancelText = 'ຍົກເລີກ',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── Validation ──
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'ກະລຸນາໃສ່ອີເມລ';
    if (!GetUtils.isEmail(value)) return 'ອີເມລບໍ່ຖືກຕ້ອງ';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'ກະລຸນາໃສ່ລະຫັດຜ່ານ';
    if (value.length < AppConstants.minPasswordLength) {
      return 'ລະຫັດຜ່ານຕ້ອງມີຢ່າງໜ້ອຍ ${AppConstants.minPasswordLength} ຕົວອັກສອນ';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'ກະລຸນາໃສ່ເບີໂທ';
    if (!RegExp(r'^[0-9]{8,10}$').hasMatch(value)) {
      return 'ເບີໂທບໍ່ຖືກຕ້ອງ';
    }
    return null;
  }

  static String? validateRequired(String? value, [String field = '']) {
    if (value == null || value.trim().isEmpty) {
      return 'ກະລຸນາໃສ່$field';
    }
    return null;
  }

  // ── Distance ──
  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  // ── Phone ──
  static String formatPhone(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return phone;
  }
}
