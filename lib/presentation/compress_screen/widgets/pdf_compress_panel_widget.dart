import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import './file_picker_slot_widget.dart';
import './result_card_widget.dart';

class PdfCompressPanelWidget extends StatefulWidget {
  const PdfCompressPanelWidget({super.key});

  @override
  State<PdfCompressPanelWidget> createState() => _PdfCompressPanelWidgetState();
}

class _PdfCompressPanelWidgetState extends State<PdfCompressPanelWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  String? _fileName;
  int? _fileSizeKb;
  int _compressionLevel = 1; // 0=Low, 1=Medium, 2=High
  bool _isCompressing = false;
  bool _showResult = false;
  int _compressedKb = 0;

  final _pdfRed = const Color(0xFFE17055);

  void _pickFile() {
    // TODO: Replace with file_picker integration (type: FileType.custom, extensions: ['pdf'])
    setState(() {
      _fileName = 'annual_report_2025.pdf';
      _fileSizeKb = 12480;
      _showResult = false;
    });
  }

  Future<void> _compress() async {
    if (_fileName == null) return;
    setState(() => _isCompressing = true);
    // TODO: Replace with syncfusion_flutter_pdf or pdf_compressor integration
    await Future.delayed(const Duration(milliseconds: 1800));
    final factors = [0.72, 0.55, 0.38];
    setState(() {
      _isCompressing = false;
      _compressedKb = (_fileSizeKb! * factors[_compressionLevel]).round();
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilePickerSlotWidget(
            fileName: _fileName,
            fileSizeKb: _fileSizeKb,
            acceptLabel: 'PDF files only',
            iconName: 'picture_as_pdf_rounded',
            accentColor: _pdfRed,
            onPick: _pickFile,
            onClear: () => setState(() {
              _fileName = null;
              _fileSizeKb = null;
              _showResult = false;
            }),
          ),
          if (_fileName != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF312D4A), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compression level',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFEAE8F5),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _LevelCard(
                        label: 'Low',
                        subtitle: '~28% smaller',
                        iconName: 'battery_2_bar_rounded',
                        isSelected: _compressionLevel == 0,
                        color: AppTheme.secondary,
                        onTap: () => setState(() => _compressionLevel = 0),
                      ),
                      const SizedBox(width: 8),
                      _LevelCard(
                        label: 'Medium',
                        subtitle: '~45% smaller',
                        iconName: 'battery_4_bar_rounded',
                        isSelected: _compressionLevel == 1,
                        color: _pdfRed,
                        onTap: () => setState(() => _compressionLevel = 1),
                      ),
                      const SizedBox(width: 8),
                      _LevelCard(
                        label: 'High',
                        subtitle: '~62% smaller',
                        iconName: 'battery_full_rounded',
                        isSelected: _compressionLevel == 2,
                        color: AppTheme.primary,
                        onTap: () => setState(() => _compressionLevel = 2),
                      ),
                    ],
                  ),
                  if (_compressionLevel == 2) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.warning.withAlpha(64),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'warning_amber_rounded',
                            color: AppTheme.warning,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'High compression may reduce image quality inside the PDF',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: AppTheme.warning.withAlpha(230),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _isCompressing ? null : _compress,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  color: _isCompressing ? _pdfRed.withAlpha(128) : _pdfRed,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isCompressing
                      ? []
                      : [
                          BoxShadow(
                            color: _pdfRed.withAlpha(89),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Center(
                  child: _isCompressing
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Compressing PDF...',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'picture_as_pdf_rounded',
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Compress PDF',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
          if (_showResult) ...[
            const SizedBox(height: 20),
            ResultCardWidget(
              originalKb: _fileSizeKb!,
              compressedKb: _compressedKb,
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final String iconName;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _LevelCard({
    required this.label,
    required this.subtitle,
    required this.iconName,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withAlpha(31)
                : AppTheme.surfaceVariantDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? color.withAlpha(128)
                  : const Color(0xFF4A4660),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isSelected ? color : const Color(0xFF6B6888),
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? color : const Color(0xFF9A96B8),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  color: isSelected
                      ? color.withAlpha(179)
                      : const Color(0xFF6B6888),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
