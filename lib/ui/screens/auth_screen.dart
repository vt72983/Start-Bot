import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/gradient_card.dart';
import '../widgets/gradient_button.dart';
import '../../features/auth/token_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final token = _controller.text.trim();
    if (token.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(tokenControllerProvider.notifier).save(token);
      if (context.mounted) context.go('/control');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(tokenControllerProvider);
    if (token != null && token.isNotEmpty) {
      // Уже авторизованы — уходим на экран управления
      Future.microtask(() => context.go('/control'));
    }

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Логотип и заголовок
                  Container(
                    padding: const EdgeInsets.all(24),
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
                    child: Icon(
                      PhosphorIcons.robot(),
                      color: Colors.white,
                      size: 48,
                    ),
                  ).animate().scale(
                    begin: const Offset(0, 0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'app.title'.tr(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(
                    begin: 0.3,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'auth.welcome'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms).slideY(
                    begin: 0.3,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Форма входа
                  GradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.key(),
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'auth.token.title'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'auth.token.description'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 14,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        TextField(
                          controller: _controller,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            hintText: 'token.placeholder'.tr(),
                            prefixIcon: Icon(PhosphorIcons.lock()),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure ? PhosphorIcons.eye() : PhosphorIcons.eyeSlash(),
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        GradientButton(
                          text: 'auth.login'.tr(),
                          icon: PhosphorIcons.signIn(),
                          isLoading: _saving,
                          onPressed: _saving ? null : _save,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Center(
                          child: TextButton.icon(
                            onPressed: () => context.go('/control'),
                            icon: Icon(PhosphorIcons.arrowRight()),
                            label: Text('auth.skip'.tr()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Информация
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.info(),
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'auth.info'.tr(),
                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(
                    begin: 0.3,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
