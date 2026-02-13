import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Modern Loading Widget ──
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size + 24,
            height: size + 24,
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(size / 2 + 12),
            ),
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  color: color ?? AppColors.primary,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Loading Overlay ──
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.4),
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}

// ── Modern Shimmer Box ──
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool hasShadow;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 16,
    this.hasShadow = false,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.hasShadow
                ? [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1.0, 0),
              colors: [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight,
                AppColors.shimmerBase,
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Shimmer Card ──
class ShimmerCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerCard({
    super.key,
    this.height = 200,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ShimmerBox(
        height: height,
        borderRadius: 24,
      ),
    );
  }
}

// ── Loading List ──
class LoadingList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const LoadingList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: itemCount,
      itemBuilder: (_, __) => ShimmerCard(height: itemHeight),
    );
  }
}

// ── Animated Dots Loading ──
class AnimatedDotsLoading extends StatefulWidget {
  final Color? color;
  final double size;

  const AnimatedDotsLoading({
    super.key,
    this.color,
    this.size = 12,
  });

  @override
  State<AnimatedDotsLoading> createState() => _AnimatedDotsLoadingState();
}

class _AnimatedDotsLoadingState extends State<AnimatedDotsLoading>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });
    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      _controllers[i].repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: widget.size,
              height: widget.size + (_controllers[index].value * 8),
              decoration: BoxDecoration(
                color: (widget.color ?? AppColors.primary)
                    .withOpacity(0.6 + (_controllers[index].value * 0.4)),
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
            );
          },
        );
      }),
    );
  }
}

// ── Modern Skeleton List ──
class SkeletonList extends StatelessWidget {
  final int count;

  const SkeletonList({
    super.key,
    this.count = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: count,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                height: 140,
                borderRadius: 16,
              ),
              const SizedBox(height: 16),
              ShimmerBox(
                height: 24,
                width: 200,
                borderRadius: 8,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ShimmerBox(
                    height: 16,
                    width: 80,
                    borderRadius: 6,
                  ),
                  const SizedBox(width: 12),
                  ShimmerBox(
                    height: 16,
                    width: 60,
                    borderRadius: 6,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
