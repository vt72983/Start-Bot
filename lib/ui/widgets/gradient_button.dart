import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDestructive;
  final double? width;
  final double height;
  final List<Color>? gradientColors;
  final bool animate;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDestructive = false,
    this.width,
    this.height = 56,
    this.gradientColors,
    this.animate = true,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isGradient = widget.gradientColors != null;
    final colors = widget.gradientColors ??
        [scheme.primary, Color.lerp(scheme.primary, scheme.secondary, 0.6)!];

    final button = GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(16),
                 color: isGradient ? null : scheme.primary,
                 gradient: isGradient
                     ? LinearGradient(
                         begin: Alignment.topLeft,
                         end: Alignment.bottomRight,
                         colors: widget.isLoading ? [scheme.outline, scheme.outline] : colors,
                       )
                     : null,
                 boxShadow: [
                   BoxShadow(
                     color: scheme.primary.withOpacity(0.25),
                     blurRadius: 14,
                     offset: const Offset(0, 8),
                   ),
                 ],
               ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.animate) {
      return button.animate().fadeIn(duration: 400.ms).slideY(
        begin: 0.3,
        duration: 400.ms,
        curve: Curves.easeOutCubic,
      );
    }

    return button;
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool animate;

  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final fab = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 56,
            height: 56,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );

    if (animate) {
      return fab.animate().scale(
        begin: const Offset(0, 0),
        duration: 400.ms,
        curve: Curves.elasticOut,
      ).fadeIn(duration: 400.ms);
    }

    return fab;
  }
}

