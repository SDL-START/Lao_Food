import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.scaffoldBg,
      drawer: drawer,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : leading,
              actions: actions,
              bottom: bottom,
            )
          : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// ── Rating stars ──
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1.0;
        return GestureDetector(
          onTap: interactive ? () => onRatingChanged?.call(starValue) : null,
          child: Icon(
            starValue <= rating
                ? Icons.star_rounded
                : starValue - 0.5 <= rating
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            color: starValue <= rating
                ? AppColors.starActive
                : AppColors.starInactive,
            size: size,
          ),
        );
      }),
    );
  }
}
