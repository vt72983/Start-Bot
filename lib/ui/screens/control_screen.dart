import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../features/bot/bot_controller.dart';
import '../../features/auth/token_controller.dart';
import '../widgets/gradient_card.dart';
import '../widgets/animated_status_indicator.dart';
import '../widgets/gradient_button.dart';

class ControlScreen extends ConsumerStatefulWidget {
  const ControlScreen({super.key});

  @override
  ConsumerState<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends ConsumerState<ControlScreen> {
  @override
  void initState() {
    super.initState();
    // Первичная проверка статуса
    Future.microtask(() => ref.read(botControllerProvider.notifier).refreshStatus());
  }

  String _localeName(Locale loc) {
    if (loc.languageCode == 'ru') return 'Русский';
    if (loc.languageCode == 'en') return 'English';
    return loc.toLanguageTag();
  }

  Future<void> _pickLanguage() async {
    final locales = context.supportedLocales;
    await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'settings.language'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: locales.length,
                  itemBuilder: (_, i) {
                    final loc = locales[i];
                    final selected = loc == context.locale;
                    return ListTile(
                      leading: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected 
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: selected 
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      title: Text(
                        _localeName(loc),
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected 
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        await context.setLocale(loc);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final botState = ref.watch(botControllerProvider);
    final isLoading = botState.status == BotStateStatus.loading;
    final isRunning = botState.status == BotStateStatus.running;

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
          child: Column(
            children: [
              // Заголовок с действиями
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'app.title'.tr(),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              background: Paint()
                                ..shader = LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'bot.control.description'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _pickLanguage,
                          icon: Icon(PhosphorIcons.translate()),
                          tooltip: 'settings.language'.tr(),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ref.read(tokenControllerProvider.notifier).clear();
                            if (context.mounted) context.go('/');
                          },
                          icon: Icon(PhosphorIcons.signOut()),
                          tooltip: 'auth.logout'.tr(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Основной контент
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Статус бота
                      GradientCard(
                        child: Column(
                          children: [
                            AnimatedStatusIndicator(
                              isRunning: isRunning,
                              statusText: isRunning 
                                  ? 'bot.status.running'.tr() 
                                  : 'bot.status.stopped'.tr(),
                              size: 140,
                            ),
                            const SizedBox(height: 24),
                             StatusBadge(
                              isRunning: isRunning,
                              text: isRunning 
                                  ? 'bot.status.active'.tr() 
                                  : 'bot.status.inactive'.tr(),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Кнопки управления
                      GradientCard(
                        gradientColors: null,
                        child: Column(
                          children: [
                            Text(
                              'bot.control.title'.tr(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GradientButton(
                              text: isRunning ? 'bot.stop'.tr() : 'bot.start'.tr(),
                              icon: isRunning 
                                  ? PhosphorIcons.stopCircle() 
                                                                      : PhosphorIcons.playCircle(),
                              isLoading: isLoading,
                              isDestructive: isRunning,
                              onPressed: () async {
                                if (isRunning) {
                                  await ref.read(botControllerProvider.notifier).stop();
                                } else {
                                  await ref.read(botControllerProvider.notifier).start();
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: isLoading 
                                  ? null 
                                  : () => ref.read(botControllerProvider.notifier).refreshStatus(),
                                                             icon: Icon(PhosphorIcons.arrowClockwise()),
                              label: Text('bot.refresh'.tr()),
                            ),
                          ],
                        ),
                      ),
                      
                      // Информация о боте
                      if (isRunning) ...[
                        const SizedBox(height: 24),
                        GradientCard(
                          gradientColors: [
                            const Color(0xFF10B981).withOpacity(0.1),
                            const Color(0xFF059669).withOpacity(0.1),
                          ],
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      PhosphorIcons.info(),
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'bot.info.title'.tr(),
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                         Text(
                                          'bot.info.description'.tr(),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                             color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      // Ошибка
                      if (botState.status == BotStateStatus.error && botState.message != null) ...[
                        const SizedBox(height: 24),
                        GradientCard(
                          gradientColors: [
                            const Color(0xFFEF4444).withOpacity(0.1),
                            const Color(0xFFDC2626).withOpacity(0.1),
                          ],
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  PhosphorIcons.warning(),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  botState.message!.tr(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFFDC2626),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => ref.read(botControllerProvider.notifier).refreshStatus(),
                  icon: PhosphorIcons.arrowClockwise(),
        tooltip: 'bot.refresh'.tr(),
      ),
    );
  }
}


