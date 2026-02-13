import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Modern App Scaffold ──
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Widget? drawer;
  final bool extendBodyBehindAppBar;
  final Widget? flexibleSpace;
  final double? elevation;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.backgroundColor,
    this.bottom,
    this.drawer,
    this.extendBodyBehindAppBar = false,
    this.flexibleSpace,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.scaffoldBg,
      drawer: drawer,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: title != null || showBackButton || leading != null
          ? AppBar(
              title: title != null
                  ? Text(
                      title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    )
                  : null,
              leading: showBackButton
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    )
                  : leading,
              actions: actions,
              bottom: bottom,
              flexibleSpace: flexibleSpace,
              elevation: elevation ?? 0,
            )
          : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

// ── Modern Rating Stars ──
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.interactive = false,
    this.onRatingChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1.0;
        final isActive = starValue <= rating;
        final isHalf = starValue - 0.5 <= rating && starValue > rating;
        
        return GestureDetector(
          onTap: interactive ? () => onRatingChanged?.call(starValue) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              isActive
                  ? Icons.star_rounded
                  : isHalf
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              color: isActive || isHalf
                  ? (activeColor ?? AppColors.starActive)
                  : (inactiveColor ?? AppColors.starInactive),
              size: size,
            ),
          ),
        );
      }),
    );
  }
}

// ── Rating Badge ──
class RatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.starActive,
            size: size * 0.5,
          ),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (reviewCount > 0) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Section Header ──
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionText != null && onAction != null)
            TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(actionText!),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Modern Badge ──
class ModernBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool isOutlined;

  const ModernBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: isOutlined
            ? Border.all(color: color, width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
