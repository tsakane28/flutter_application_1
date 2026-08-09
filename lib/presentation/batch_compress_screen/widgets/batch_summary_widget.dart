import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import 'dart:ui'; 
class BatchSummaryWidget extends StatefulWidget {
  final int totalFiles;
  final int totalOriginalKb;
  final int totalCompressedKb;

  const BatchSummaryWidget({
    super.key,
    required this.totalFiles,
    required this.totalOriginalKb,
    required this.totalCompressedKb,
  });

  @override
  State<BatchSummaryWidget> createState() => _BatchSummaryWidgetState();
}

class _BatchSummaryWidgetState extends State<BatchSummaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatSize(int kb) {
    if (kb >= 1024) return '${(kb / 1024).toStringAsFixed(1)} MB';
    return '$kb KB';
  }

  int get _reductionPercent => widget.totalOriginalKb > 0
      ? (((widget.totalOriginalKb - widget.totalCompressedKb) /
                    widget.totalOriginalKb) *
                100)
            .round()
      : 0;

  int get _savedKb => widget.totalOriginalKb - widget.totalCompressedKb;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.secondary.withAlpha(89),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondary.withAlpha(31),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomIconWidget(
                    iconName: 'check_circle_rounded',
                    color: AppTheme.secondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Batch complete — ${widget.totalFiles} files',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MetricBlock(
                      label: 'Original',
                      value: _formatSize(widget.totalOriginalKb),
                      color: const Color(0xFF9A96B8),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CustomIconWidget(
                      iconName: 'arrow_forward_rounded',
                      color: AppTheme.secondary,
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: _MetricBlock(
                      label: 'Compressed',
                      value: _formatSize(widget.totalCompressedKb),
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withAlpha(31),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '-$_reductionPercent%',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.secondary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          'saved',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: AppTheme.secondary.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Total saved: ${_formatSize(_savedKb)} across ${widget.totalFiles} files',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: const Color(0xFF9A96B8),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Replace with share_plus batch share integration
                        Fluttertoast.showToast(
                          msg: 'All files shared successfully',
                          backgroundColor: AppTheme.secondary,
                          textColor: Colors.white,
                        );
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primary, Color(0xFF9B59B6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomIconWidget(
                              iconName: 'share_rounded',
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Share All',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // TODO: Replace with file save integration
                      Fluttertoast.showToast(
                        msg: 'All files saved to device',
                        backgroundColor: AppTheme.surfaceVariantDark,
                        textColor: const Color(0xFFEAE8F5),
                      );
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariantDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4A4660),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: CustomIconWidget(
                          iconName: 'save_alt_rounded',
                          color: Color(0xFFEAE8F5),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: const Color(0xFF6B6888),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
