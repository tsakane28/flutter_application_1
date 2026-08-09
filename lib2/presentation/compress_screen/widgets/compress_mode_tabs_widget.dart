import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CompressModeTabsWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const CompressModeTabsWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'label': 'Image', 'icon': 'image_rounded', 'color': AppTheme.primary},
      {
        'label': 'WhatsApp',
        'icon': 'chat_rounded',
        'color': const Color(0xFF25D366),
      },
      {
        'label': 'PDF',
        'icon': 'picture_as_pdf_rounded',
        'color': const Color(0xFFE17055),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: List.generate(tabs.length, (i) {
            final tab = tabs[i];
            final isActive = i == selectedIndex;
            final color = tab['color'] as Color;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isActive ? color.withAlpha(38) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isActive
                        ? Border.all(color: color.withAlpha(102), width: 1)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: tab['icon'] as String,
                        color: isActive ? color : const Color(0xFF6B6888),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tab['label'] as String,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive ? color : const Color(0xFF6B6888),
                        ),
                      ),
                    ],
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
