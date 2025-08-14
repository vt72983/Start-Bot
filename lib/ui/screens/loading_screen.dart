import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingScreen extends StatefulWidget {
  final String? message;
  
  const LoadingScreen({
    super.key,
    this.message,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Анимированный логотип
              Container(
                width: 120,
                height: 120,
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
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * 3.14159,
                      child: Icon(
                        PhosphorIcons.robot(),
                        color: Colors.white,
                        size: 60,
                      ),
                    );
                  },
                ),
              ).animate().scale(
                begin: const Offset(0, 0),
                duration: 800.ms,
                curve: Curves.elasticOut,
              ),
              
              const SizedBox(height: 32),
              
              // Заголовок
              Text(
                'StartBot',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(
                begin: 0.3,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
              
              const SizedBox(height: 8),
              
              // Подзаголовок
              Text(
                'Инициализация...',
                style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
              ).animate().fadeIn(delay: 400.ms).slideY(
                begin: 0.3,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
              
              const SizedBox(height: 48),
              
              // Индикатор загрузки
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    // Прогресс бар
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.3 + (_pulseController.value * 0.4),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ]),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Точки загрузки
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: index == 0 
                                    ? 1.0 + (_pulseController.value * 0.3)
                                    : index == 1
                                        ? 1.0 + (_pulseController.value * 0.3) * 0.7
                                        : 1.0 + (_pulseController.value * 0.3) * 0.4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(
                begin: 0.3,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
              
              if (widget.message != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5), width: 1),
                  ),
                  child: Text(
                    widget.message!,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 800.ms).slideY(
                  begin: 0.3,
                  duration: 600.ms,
                  curve: Curves.easeOutCubic,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
      ],
    );
  }
}
