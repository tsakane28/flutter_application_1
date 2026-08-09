import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; 
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import './file_picker_slot_widget.dart';
import './result_card_widget.dart';

class ImageCompressPanelWidget extends StatefulWidget {
  const ImageCompressPanelWidget({super.key});

  @override
  State<ImageCompressPanelWidget> createState() =>
      _ImageCompressPanelWidgetState();
}

class _ImageCompressPanelWidgetState extends State<ImageCompressPanelWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  String? _fileName;
  int? _fileSizeKb;
  double _quality = 30;
  double _maxDimension = 1920;
  bool _isCompressing = false;
  bool _showResult = false;
  int _compressedKb = 0;

  void _pickFile() {
    // TODO: Replace with file_picker integration
    setState(() {
      _fileName = 'holiday_photos_2025.jpg';
      _fileSizeKb = 5840;
      _showResult = false;
    });
  }

  void _clearFile() {
    setState(() {
      _fileName = null;
      _fileSizeKb = null;
      _showResult = false;
    });
  }

  Future<void> _compress() async {
    if (_fileName == null) return;
    setState(() => _isCompressing = true);
    // TODO: Replace with flutter_image_compress integration
    await Future.delayed(const Duration(milliseconds: 1200));
    final reductionFactor = (1 - (_quality / 100)) * 0.85 + 0.05;
    setState(() {
      _isCompressing = false;
      _compressedKb = (_fileSizeKb! * (1 - reductionFactor)).round();
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
            acceptLabel: 'JPEG, PNG, WebP',
            iconName: 'image_rounded',
            accentColor: AppTheme.primary,
            onPick: _pickFile,
            onClear: _clearFile,
          ),
          if (_fileName != null) ...[
            const SizedBox(height: 20),
            _buildSettingsCard(),
            const SizedBox(height: 16),
            _buildCompressButton(),
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

  Widget _buildSettingsCard() {
    return Container(
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
            'Settings',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEAE8F5),
            ),
          ),
          const SizedBox(height: 16),
          _SliderRow(
            label: 'Quality',
            value: _quality,
            min: 10,
            max: 95,
            displayValue: '${_quality.round()}%',
            color: AppTheme.primary,
            onChanged: (v) => setState(() => _quality = v),
          ),
          const SizedBox(height: 16),
          _SliderRow(
            label: 'Max dimension',
            value: _maxDimension,
            min: 480,
            max: 4096,
            displayValue: '${_maxDimension.round()}px',
            color: AppTheme.primary,
            onChanged: (v) => setState(() => _maxDimension = v),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline_rounded',
                  color: AppTheme.primary.withAlpha(179),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Estimated output: ~${((_fileSizeKb ?? 0) * (1 - (_quality / 100) * 0.85)).round()} KB',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppTheme.primary.withAlpha(204),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompressButton() {
    return GestureDetector(
      onTap: _isCompressing ? null : _compress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isCompressing
                ? [
                    AppTheme.primary.withAlpha(128),
                    const Color(0xFF9B59B6).withAlpha(128),
                  ]
                : [AppTheme.primary, const Color(0xFF9B59B6)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isCompressing
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primary.withAlpha(89),
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
                      'Compressing...',
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
                      iconName: 'compress',
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Compress Image',
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
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9A96B8),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withAlpha(31),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                displayValue,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withAlpha(38),
            thumbColor: color,
            overlayColor: color.withAlpha(31),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }
}
