import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

// Вспомогательный экран для редиректа на нужную вкладку при старте
class HomeShellRedirect extends StatelessWidget {
  const HomeShellRedirect({super.key, this.index = 0});
  final int index;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(index == 1
          ? '/stats'
          : index == 2
              ? '/settings'
              : '/control');
    });
    return const SizedBox.shrink();
  }
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _onTap(int idx) {
    setState(() => _index = idx);
    widget.navigationShell.goBranch(idx, initialLocation: idx == widget.navigationShell.currentIndex);
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
        child: widget.navigationShell,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _NavigationItem(
                    icon: PhosphorIcons.robot(),
                    selectedIcon: PhosphorIcons.robot(),
                    label: 'nav.bot'.tr(),
                    isSelected: _index == 0,
                    onTap: () => _onTap(0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _NavigationItem(
                    icon: PhosphorIcons.bookOpenText(),
                    selectedIcon: PhosphorIcons.bookOpenText(),
                    label: 'nav.stats'.tr(),
                    isSelected: _index == 1,
                    onTap: () => _onTap(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _NavigationItem(
                    icon: PhosphorIcons.gear(),
                    selectedIcon: PhosphorIcons.gear(),
                    label: 'nav.settings'.tr(),
                    isSelected: _index == 2,
                    onTap: () => _onTap(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).hintColor,
              size: 24,
            ).animate(target: isSelected ? 1 : 0)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 200.ms,
                curve: Curves.elasticOut,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).hintColor,
              ),
            ).animate(target: isSelected ? 1 : 0)
              .fadeIn(duration: 200.ms)
              .slideY(
                begin: 0.3,
                duration: 200.ms,
                curve: Curves.easeOutCubic,
              ),
          ],
        ),
      ),
    );
  }
}


