import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilePickerSlotWidget extends StatelessWidget {
  final String? fileName;
  final int? fileSizeKb;
  final String acceptLabel;
  final String iconName;
  final Color accentColor;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  const FilePickerSlotWidget({
    super.key,
    this.fileName,
    this.fileSizeKb,
    required this.acceptLabel,
    required this.iconName,
    required this.accentColor,
    required this.onPick,
    this.onClear,
  });

  String _formatSize(int kb) {
    if (kb >= 1024) return '${(kb / 1024).toStringAsFixed(1)} MB';
    return '$kb KB';
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;

    return GestureDetector(
      onTap: hasFile ? null : onPick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hasFile ? accentColor.withAlpha(15) : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile
                ? accentColor.withAlpha(102)
                : const Color(0xFF4A4660),
            width: hasFile ? 1.5 : 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: hasFile
            ? Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(31),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName!,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFEAE8F5),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fileSizeKb != null
                              ? _formatSize(fileSizeKb!)
                              : 'Ready to compress',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: const Color(0xFF9A96B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onClear != null)
                    GestureDetector(
                      onTap: onClear,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.error.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'close_rounded',
                            color: AppTheme.error,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(26),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withAlpha(77),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'upload_file_rounded',
                        color: accentColor,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to pick a file',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEAE8F5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    acceptLabel,
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
