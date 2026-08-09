import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../batch_compress_screen.dart';

class BatchFileItemWidget extends StatelessWidget {
  final BatchFileModel file;
  final VoidCallback onRemove;

  const BatchFileItemWidget({
    super.key,
    required this.file,
    required this.onRemove,
  });

  String _formatSize(int kb) {
    if (kb >= 1024) return '${(kb / 1024).toStringAsFixed(1)} MB';
    return '$kb KB';
  }

  String _iconName() {
    switch (file.fileType) {
      case 'pdf':
        return 'picture_as_pdf_rounded';
      default:
        return 'image_rounded';
    }
  }

  Color _typeColor() {
    switch (file.fileType) {
      case 'pdf':
        return const Color(0xFFE17055);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = file.status == BatchFileStatus.done;
    final isCompressing = file.status == BatchFileStatus.compressing;
    final typeColor = _typeColor();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? AppTheme.secondary.withAlpha(77)
              : isCompressing
              ? AppTheme.primary.withAlpha(77)
              : const Color(0xFF312D4A),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeColor.withAlpha(31),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _iconName(),
                    color: typeColor,
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
                      file.fileName,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEAE8F5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          _formatSize(file.originalKb),
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: const Color(0xFF9A96B8),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        if (isDone && file.compressedKb != null) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: CustomIconWidget(
                              iconName: 'arrow_forward_rounded',
                              color: const Color(0xFF6B6888),
                              size: 10,
                            ),
                          ),
                          Text(
                            _formatSize(file.compressedKb!),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _buildStatusBadge(),
              const SizedBox(width: 6),
              if (file.status == BatchFileStatus.idle)
                GestureDetector(
                  onTap: onRemove,
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
                        size: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (isCompressing) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: file.progress,
                backgroundColor: AppTheme.primary.withAlpha(31),
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                minHeight: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    switch (file.status) {
      case BatchFileStatus.idle:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4A4660).withAlpha(102),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Queued',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9A96B8),
            ),
          ),
        );
      case BatchFileStatus.compressing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(31),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${(file.progress * 100).round()}%',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        );
      case BatchFileStatus.done:
        final reduction = file.compressedKb != null
            ? (((file.originalKb - file.compressedKb!) / file.originalKb) * 100)
                  .round()
            : 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.secondary.withAlpha(31),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '-$reduction%',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        );
      case BatchFileStatus.error:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.error.withAlpha(31),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Error',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.error,
            ),
          ),
        );
    }
  }
}
