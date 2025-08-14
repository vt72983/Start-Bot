import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../features/settings/theme_controller.dart';
import '../../features/auth/token_controller.dart';
import '../widgets/gradient_card.dart';
import '../widgets/gradient_button.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _tokenCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final token = ref.read(tokenControllerProvider);
    _tokenCtrl.text = token ?? '';
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveToken() async {
    setState(() => _saving = true);
    await ref.read(tokenControllerProvider.notifier).save(_tokenCtrl.text.trim());
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('token.saved'.tr()),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
                        if (mounted) setState(() {});
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

  String _localeName(Locale loc) {
    if (loc.languageCode == 'ru') return 'Русский';
    if (loc.languageCode == 'en') return 'English';
    return loc.toLanguageTag();
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
        child: SafeArea(
          child: Column(
            children: [
              // Заголовок
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        PhosphorIcons.gear(),
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'settings.title'.tr(),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'settings.description'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
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
                      // Настройки языка
                      GradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  PhosphorIcons.translate(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'settings.language'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: _pickLanguage,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _localeName(context.locale),
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                    Icon(
                                      PhosphorIcons.caretRight(),
                                      color: Theme.of(context).hintColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // Тема приложения
                      GradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  PhosphorIcons.moonStars(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'settings.theme'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _ThemeSelector(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Настройки токена
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
                                  'token.title'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _tokenCtrl,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'token.placeholder'.tr(),
                                prefixIcon: Icon(PhosphorIcons.lock()),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _tokenCtrl.clear();
                                  },
                                  icon: Icon(PhosphorIcons.x()),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GradientButton(
                              text: 'token.save'.tr(),
                              icon: PhosphorIcons.floppyDisk(),
                              isLoading: _saving,
                              onPressed: _saveToken,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Информация о приложении
                      GradientCard(
                        gradientColors: [
                          const Color(0xFF06B6D4).withOpacity(0.1),
                          const Color(0xFF0891B2).withOpacity(0.1),
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  PhosphorIcons.info(),
                                  color: const Color(0xFF06B6D4),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'app.info.title'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF06B6D4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _InfoItem(
                              icon: PhosphorIcons.info(),
                              title: 'app.info.version'.tr(),
                              subtitle: '1.0.0',
                            ),
                            const SizedBox(height: 12),
                            _InfoItem(
                              icon: PhosphorIcons.info(),
                              title: 'app.info.build'.tr(),
                              subtitle: '1',
                            ),
                            const SizedBox(height: 12),
                            _InfoItem(
                              icon: PhosphorIcons.calendar(),
                              title: 'app.info.date'.tr(),
                                subtitle: '2025',
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    void setMode(AppThemeMode m) {
      ref.read(themeControllerProvider.notifier).setTheme(m);
    }

    return Column(
      children: [
        _ThemeTile(
          title: 'settings.theme.system'.tr(),
          icon: PhosphorIcons.deviceMobile(),
          selected: mode == AppThemeMode.system,
          onTap: () => setMode(AppThemeMode.system),
        ),
        const SizedBox(height: 8),
        _ThemeTile(
          title: 'settings.theme.light'.tr(),
          icon: PhosphorIcons.sun(),
          selected: mode == AppThemeMode.light,
          onTap: () => setMode(AppThemeMode.light),
        ),
        const SizedBox(height: 8),
        _ThemeTile(
          title: 'settings.theme.dark'.tr(),
          icon: PhosphorIcons.moon(),
          selected: mode == AppThemeMode.dark,
          onTap: () => setMode(AppThemeMode.dark),
        ),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? scheme.primary.withOpacity(0.08) : scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? scheme.primary : Theme.of(context).hintColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? scheme.primary : null,
                    ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                color: scheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey.shade600,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


