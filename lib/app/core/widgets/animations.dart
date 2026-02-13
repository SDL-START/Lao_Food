import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Fade Slide Animation ──
class FadeSlideAnimation extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final int delay;
  final Offset offset;

  const FadeSlideAnimation({
    super.key,
    required this.child,
    required this.controller,
    this.delay = 0,
    this.offset = const Offset(0, 30),
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay * 0.1,
          (delay * 0.1) + 0.6,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    final slideAnimation = Tween<Offset>(
      begin: offset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay * 0.1,
          (delay * 0.1) + 0.6,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: slideAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ── Scale Animation ──
class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final int delay;

  const ScaleAnimation({
    super.key,
    required this.child,
    required this.controller,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay * 0.1,
          (delay * 0.1) + 0.5,
          curve: Curves.elasticOut,
        ),
      ),
    );

    final fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay * 0.1,
          (delay * 0.1) + 0.5,
          curve: Curves.easeOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ── Staggered List Animation ──
class StaggeredListAnimation extends StatelessWidget {
  final List<Widget> children;
  final AnimationController controller;
  final double delay;

  const StaggeredListAnimation({
    super.key,
    required this.children,
    required this.controller,
    this.delay = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        final animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              index * delay,
              (index * delay) + 0.5,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 20),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              index * delay,
              (index * delay) + 0.5,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: slideAnimation.value,
                child: child,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

// ── Pulse Animation ──
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ── Shimmer Effect ──
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
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
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor ?? AppColors.shimmerBase,
                widget.highlightColor ?? AppColors.shimmerHighlight,
                widget.baseColor ?? AppColors.shimmerBase,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_controller.value * 2), 0),
              end: Alignment(1.0 + (_controller.value * 2), 0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// ── Bounce Animation ──
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  const BounceAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1,
      end: widget.scale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

// ── Loading Skeleton ──
class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const Skeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ── Skeleton Card ──
class SkeletonCard extends StatelessWidget {
  final double height;

  const SkeletonCard({
    super.key,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ShimmerEffect(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

// ── Ripple Effect ──
class RippleEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
    _controller.forward(from: 0).then((_) {
      _controller.reset();
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        children: [
          widget.child,
          if (_tapPosition != null)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  left: _tapPosition!.dx - 50 * _controller.value,
                  top: _tapPosition!.dy - 50 * _controller.value,
                  child: Container(
                    width: 100 * _controller.value,
                    height: 100 * _controller.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.rippleColor ?? AppColors.primary)
                          .withOpacity(0.3 * (1 - _controller.value)),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ── Animated Gradient Border ──
class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double borderWidth;
  final double borderRadius;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.colors,
    this.borderWidth = 3,
    this.borderRadius = 20,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
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
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(widget.borderWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              colors: widget.colors,
              transform: GradientRotation(_controller.value * 2 * 3.14159),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                widget.borderRadius - widget.borderWidth,
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
