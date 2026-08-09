import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BatchAddFilesWidget extends StatelessWidget {
  final VoidCallback onAddFiles;

  const BatchAddFilesWidget({super.key, required this.onAddFiles});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddFiles,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4A4660),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(26),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary.withAlpha(77),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: CustomIconWidget(
                  iconName: 'add_rounded',
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add Files',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEAE8F5),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Images and PDFs supported',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: const Color(0xFF9A96B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
