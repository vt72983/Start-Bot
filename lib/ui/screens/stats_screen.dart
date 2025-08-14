import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/gradient_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/log_viewer.dart';

class _DocBlock extends StatelessWidget {
  const _DocBlock({
    required this.title,
    required this.description,
    required this.copyText,
  });

  final String title;
  final String description;
  final String copyText;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      gradientColors: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 12),
          SelectableText(
            copyText,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // Заголовок
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.bookOpenText(),
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'docs.title'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // Обновление статистики
                      },
                      icon: Icon(
                        PhosphorIcons.arrowClockwise(),
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'docs.access.title'.tr(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
                                const SizedBox(height: 16),
                                _DocBlock(
                                  title: 'docs.user.title'.tr(),
                                  description: 'docs.user.desc'.tr(),
                                  copyText: 'docs.user.copy'.tr(),
                                ),
                                const SizedBox(height: 12),
                                _DocBlock(
                                  title: 'docs.admin.title'.tr(),
                                  description: 'docs.admin.desc'.tr(),
                                  copyText: 'docs.admin.copy'.tr(),
                                ),
                                const SizedBox(height: 12),
                                _DocBlock(
                                  title: 'docs.senior.title'.tr(),
                                  description: 'docs.senior.desc'.tr(),
                                  copyText: 'docs.senior.copy'.tr(),
                                ),
                                const SizedBox(height: 12),
                                _DocBlock(
                                  title: 'docs.owner.title'.tr(),
                                  description: 'docs.owner.desc'.tr(),
                                  copyText: 'docs.owner.copy'.tr(),
                                ),
                                // Architecture section removed by request
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
