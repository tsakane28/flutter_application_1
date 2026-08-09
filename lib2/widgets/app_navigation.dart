import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import './custom_icon_widget.dart';

class _TabSpec {
  final String label;
  final String icon;
  final String activeIcon;
  final int? branchIndex;
  const _TabSpec({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedVisualIndex = 0;
  late AnimationController _animController;

  final List<_TabSpec> _tabs = const [
    _TabSpec(
      label: 'Home',
      icon: 'home_outlined',
      activeIcon: 'home_rounded',
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Compress',
      icon: 'compress_outlined',
      activeIcon: 'compress',
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Batch',
      icon: 'layers_outlined',
      activeIcon: 'layers_rounded',
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'History',
      icon: 'history_outlined',
      activeIcon: 'history',
      branchIndex: null,
    ),
    _TabSpec(
      label: 'Settings',
      icon: 'settings_outlined',
      activeIcon: 'settings_rounded',
      branchIndex: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _selectedVisualIndex = widget.navigationShell.currentIndex;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub tab — silent ignore
    setState(() {
      _selectedVisualIndex = visualIndex;
    });
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(89),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppTheme.primary.withAlpha(38),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final isActive = i == _selectedVisualIndex;
            final isStub = tab.branchIndex == null;
            return GestureDetector(
              onTap: () => _onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Opacity(
                opacity: isStub ? 0.4 : 1.0,
                child: SizedBox(
                  width: 56,
                  height: 64,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      width: isActive ? 48 : 36,
                      height: isActive ? 48 : 36,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppTheme.primary.withAlpha(46)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: isActive ? tab.activeIcon : tab.icon,
                            color: isActive
                                ? AppTheme.primary
                                : const Color(0xFF6B6888),
                            size: 22,
                          ),
                          if (isActive) ...[
                            const SizedBox(height: 2),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
