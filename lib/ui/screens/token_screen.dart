import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_card.dart';
import '../widgets/gradient_button.dart';
import '../../features/auth/token_controller.dart';

class TokenScreen extends ConsumerWidget {
  const TokenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenController = ref.watch(tokenControllerProvider);

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
                    IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.go('/control');
                        }
                      },
                      icon: Icon(
                        PhosphorIcons.arrowLeft(),
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'token.title'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Column(
                      children: [
                      // Основная карточка с токеном
                       GradientCard(
                         child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      PhosphorIcons.key(),
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'token.current'.tr(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  (tokenController ?? '').isEmpty
                                      ? 'token.empty'.tr()
                                      : '••••••••••••••••••••••••••••••••',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                    color: (tokenController ?? '').isEmpty
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GradientButton(
                                onPressed: () async {
                                  final token = tokenController ?? '';
                                  if (token.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('token.empty'.tr()),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await Clipboard.setData(ClipboardData(text: token));
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('token.copied'.tr()),
                                      backgroundColor: const Color(0xFF10B981),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                                text: 'token.copy'.tr(),
                                icon: PhosphorIcons.copy(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Поле ввода токена
                      GradientCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: _TokenInput(
                            initialValue: tokenController ?? '',
                            onSave: (value) async {
                              await ref.read(tokenControllerProvider.notifier).save(value);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('token.saved'.tr()),
                                  backgroundColor: const Color(0xFF10B981),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            onClear: () async {
                              await ref.read(tokenControllerProvider.notifier).clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('token.cleared'.tr()),
                                  backgroundColor: Colors.orangeAccent,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Информационная карточка
                      GradientCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.info(),
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'token.info'.tr(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _InfoItem(
                                icon: PhosphorIcons.shieldCheck(),
                                title: 'token.secure'.tr(),
                                subtitle: 'token.secure_desc'.tr(),
                              ),
                              const SizedBox(height: 12),
                              _InfoItem(
                                icon: PhosphorIcons.clock(),
                                title: 'token.expires'.tr(),
                                subtitle: 'token.expires_desc'.tr(),
                              ),
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

class _TokenInput extends StatefulWidget {
  const _TokenInput({
    required this.initialValue,
    required this.onSave,
    required this.onClear,
  });

  final String initialValue;
  final ValueChanged<String> onSave;
  final VoidCallback onClear;

  @override
  State<_TokenInput> createState() => _TokenInputState();
}

class _TokenInputState extends State<_TokenInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'token.input_label'.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'token.input_hint'.tr(),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GradientButton(
                onPressed: () {
                  final value = _controller.text.trim();
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('token.empty'.tr()),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    return;
                  }
                  widget.onSave(value);
                },
                text: 'token.save'.tr(),
                icon: PhosphorIcons.check(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GradientButton(
                onPressed: widget.onClear,
                text: 'token.clear'.tr(),
                icon: PhosphorIcons.trash(),
              ),
            ),
          ],
        ),
      ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}