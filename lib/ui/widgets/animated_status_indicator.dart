import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedStatusIndicator extends StatefulWidget {
  final bool isRunning;
  final String statusText;
  final double size;
  final bool showText;

  const AnimatedStatusIndicator({
    super.key,
    required this.isRunning,
    required this.statusText,
    this.size = 120,
    this.showText = true,
  });

  @override
  State<AnimatedStatusIndicator> createState() => _AnimatedStatusIndicatorState();
}

class _AnimatedStatusIndicatorState extends State<AnimatedStatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    if (widget.isRunning) {
      _pulseController.repeat();
      _rotateController.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _pulseController.repeat();
        _rotateController.repeat();
      } else {
        _pulseController.stop();
        _rotateController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Внешний круг с пульсацией
              if (widget.isRunning)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                      return Container(
                      width: widget.size + (_pulseController.value * 20),
                      height: widget.size + (_pulseController.value * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withOpacity(0.25),
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              
              // Основной круг
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isRunning
                        ? [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ]
                        : [
                            const Color(0xFF6B7280),
                            const Color(0xFF4B5563),
                          ],
                  ),
                ),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _rotateController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: widget.isRunning ? _rotateController.value * 2 * 3.14159 : 0,
                        child: Icon(
                          widget.isRunning ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                          size: widget.size * 0.4,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Внутренний круг с эффектом свечения
              if (widget.isRunning)
                Container(
                  width: widget.size * 0.7,
                  height: widget.size * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        if (widget.showText) ...[
          const SizedBox(height: 16),
          Text(
            widget.statusText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.isRunning 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).hintColor,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(
            begin: 0.3,
            duration: 400.ms,
            curve: Curves.easeOutCubic,
          ),
        ],
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final bool isRunning;
  final String text;
  final bool animate;

  const StatusBadge({
    super.key,
    required this.isRunning,
    required this.text,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isRunning
              ? [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                ]
              : [
                  const Color(0xFF6B7280),
                  const Color(0xFF4B5563),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isRunning ? const Color(0xFF10B981) : const Color(0xFF6B7280))
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );

    if (animate) {
      return badge.animate().scale(
        begin: const Offset(0.8, 0.8),
        duration: 300.ms,
        curve: Curves.elasticOut,
      ).fadeIn(duration: 300.ms);
    }

    return badge;
  }
}

