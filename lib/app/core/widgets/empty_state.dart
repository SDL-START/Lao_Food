import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool animated;
  final Color? iconColor;
  final Color? backgroundColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.animated = true,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Animated Icon Container ──
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (iconColor ?? AppColors.primary).withOpacity(0.15),
                    (iconColor ?? AppColors.primary).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: (iconColor ?? AppColors.primary).withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 56,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 28),
            
            // ── Title ──
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              AppButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Empty State with Illustration ──
class EmptyStateWithIllustration extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWithIllustration({
    super.key,
    required this.illustration,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(32),
              ),
              child: illustration,
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              AppButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Error State ──
class ErrorState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title = 'ເກີດຂໍ້ຜິດພາດ',
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      title: title,
      subtitle: subtitle ?? 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
      buttonText: onRetry != null ? 'ລອງໃໝ່' : buttonText,
      onButtonPressed: onRetry ?? onButtonPressed,
    );
  }
}

// ── No Internet State ──
class NoInternetState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off_rounded,
      iconColor: AppColors.warning,
      title: 'ບໍ່ມີການເຊື່ອມຕໍ່',
      subtitle: 'ກະລຸນາກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດ',
      buttonText: 'ລອງໃໝ່',
      onButtonPressed: onRetry,
    );
  }
}

// ── Search Empty State ──
class SearchEmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const SearchEmptyState({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      iconColor: AppColors.textHint,
      title: 'ບໍ່ພົບຜົນການຄົ້ນຫາ',
      subtitle: '"$searchQuery"',
      buttonText: onClearSearch != null ? 'ລົ້າງການຄົ້ນຫາ' : null,
      onButtonPressed: onClearSearch,
    );
  }
}

// ── Cart Empty State ──
class CartEmptyState extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const CartEmptyState({
    super.key,
    this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      iconColor: AppColors.primary,
      title: 'ກະຕ່າຂອງທ່ານວ່າງເປົ່າ',
      subtitle: 'ເລີ່ມເພີ່ມອາຫານໃສ່ກະຕ່າເລີຍ!',
      buttonText: 'ເລີ່ມຊື້ເລີຍ',
      onButtonPressed: onStartShopping,
    );
  }
}
