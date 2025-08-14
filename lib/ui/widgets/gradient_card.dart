import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final List<Color>? gradientColors;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool animate;

  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.gradientColors,
    this.borderRadius,
    this.onTap,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final useGradient = gradientColors != null;
    final colors = gradientColors ?? [scheme.surface, scheme.surfaceVariant];

    final decoration = useGradient
        ? BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          )
        : BoxDecoration(
            color: scheme.surface,
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(color: scheme.outline, width: 1),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          );

    final card = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );

    if (animate) {
      return card.animate().fadeIn(duration: 600.ms).slideY(
        begin: 0.3,
        duration: 600.ms,
        curve: Curves.easeOutCubic,
      );
    }

    return card;
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool animate;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(24),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (animate) {
      return card.animate().fadeIn(duration: 600.ms).slideY(
        begin: 0.3,
        duration: 600.ms,
        curve: Curves.easeOutCubic,
      );
    }

    return card;
  }
}

