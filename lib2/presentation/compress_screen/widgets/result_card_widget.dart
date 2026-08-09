import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ResultCardWidget extends StatefulWidget {
  final int originalKb;
  final int compressedKb;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const ResultCardWidget({
    super.key,
    required this.originalKb,
    required this.compressedKb,
    this.onShare,
    this.onSave,
  });

  @override
  State<ResultCardWidget> createState() => _ResultCardWidgetState();
}

class _ResultCardWidgetState extends State<ResultCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = Tween<double>(
      begin: 0.85,
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

  int get _reductionPercent =>
      (((widget.originalKb - widget.compressedKb) / widget.originalKb) * 100)
          .round();

  int get _savedKb => widget.originalKb - widget.compressedKb;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.secondary.withAlpha(77),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondary.withAlpha(26),
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
                  CustomIconWidget(
                    iconName: 'check_circle_rounded',
                    color: AppTheme.secondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Compression complete',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SizeBlock(
                      label: 'Original',
                      value: _formatSize(widget.originalKb),
                      color: const Color(0xFF9A96B8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomIconWidget(
                      iconName: 'arrow_forward_rounded',
                      color: AppTheme.secondary,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: _SizeBlock(
                      label: 'Compressed',
                      value: _formatSize(widget.compressedKb),
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
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
                            fontSize: 20,
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
                'You saved ${_formatSize(_savedKb)}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: const Color(0xFF9A96B8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onShare?.call();
                        // TODO: Replace with real share_plus integration
                        Fluttertoast.showToast(
                          msg: 'File shared successfully',
                          backgroundColor: AppTheme.secondary,
                          textColor: Colors.white,
                        );
                      },
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primary, const Color(0xFF9B59B6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'share_rounded',
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Share',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
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
                      widget.onSave?.call();
                      // TODO: Replace with real file save integration
                      Fluttertoast.showToast(
                        msg: 'File saved to device',
                        backgroundColor: AppTheme.surfaceVariantDark,
                        textColor: const Color(0xFFEAE8F5),
                      );
                    },
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariantDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4A4660),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'save_alt_rounded',
                          color: const Color(0xFFEAE8F5),
                          size: 20,
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

class _SizeBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SizeBlock({
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
