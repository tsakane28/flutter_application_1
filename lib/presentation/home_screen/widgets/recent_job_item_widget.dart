import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import 'dart:ui'; 

class RecentJobItemWidget extends StatelessWidget {
  final String fileName;
  final String fileType;
  final int originalKb;
  final int compressedKb;
  final int reductionPercent;
  final String mode;
  final String timestamp;

  const RecentJobItemWidget({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.originalKb,
    required this.compressedKb,
    required this.reductionPercent,
    required this.mode,
    required this.timestamp,
  });

  String _formatSize(int kb) {
    if (kb >= 1024) {
      return '${(kb / 1024).toStringAsFixed(1)} MB';
    }
    return '$kb KB';
  }

  String _iconName() {
    switch (fileType) {
      case 'pdf':
        return 'picture_as_pdf_rounded';
      case 'batch':
        return 'layers_rounded';
      default:
        return 'image_rounded';
    }
  }

  Color _iconColor() {
    switch (fileType) {
      case 'pdf':
        return const Color(0xFFE17055);
      case 'batch':
        return const Color(0xFFFDCB6E);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _iconColor(), width: 2.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconColor().withAlpha(31),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _iconName(),
                color: _iconColor(),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEAE8F5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      _formatSize(originalKb),
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9A96B8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CustomIconWidget(
                        iconName: 'arrow_forward_rounded',
                        color: const Color(0xFF6B6888),
                        size: 10,
                      ),
                    ),
                    Text(
                      _formatSize(compressedKb),
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timestamp,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B6888),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withAlpha(31),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '-$reductionPercent%',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
