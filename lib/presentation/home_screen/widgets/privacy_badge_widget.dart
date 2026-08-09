import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrivacyBadgeWidget extends StatelessWidget {
  const PrivacyBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondary.withAlpha(64), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CustomIconWidget(
                iconName: 'shield_rounded',
                color: AppTheme.secondary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% On-Device Processing',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary,
                  ),
                ),
                Text(
                  'No uploads · No watermarks · No signup',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondary.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
          const CustomIconWidget(
            iconName: 'check_circle_rounded',
            color: AppTheme.secondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
