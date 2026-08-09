import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import './file_picker_slot_widget.dart';
import './result_card_widget.dart';

class WhatsAppCompressPanelWidget extends StatefulWidget {
  const WhatsAppCompressPanelWidget({super.key});

  @override
  State<WhatsAppCompressPanelWidget> createState() =>
      _WhatsAppCompressPanelWidgetState();
}

class _WhatsAppCompressPanelWidgetState
    extends State<WhatsAppCompressPanelWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  String? _fileName;
  int? _fileSizeKb;
  bool _progressiveDownscale = true;
  bool _lightSharpening = true;
  int _targetSizeKb = 350;
  bool _isCompressing = false;
  bool _showResult = false;
  int _compressedKb = 0;

  void _pickFile() {
    // TODO: Replace with file_picker integration
    setState(() {
      _fileName = 'birthday_dinner.jpg';
      _fileSizeKb = 7240;
      _showResult = false;
    });
  }

  Future<void> _compress() async {
    if (_fileName == null) return;
    setState(() => _isCompressing = true);
    // TODO: Replace with flutter_image_compress with WhatsApp-targeted parameters
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isCompressing = false;
      _compressedKb = _targetSizeKb + ((_targetSizeKb * 0.12).round());
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final waGreen = const Color(0xFF25D366);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WhatsApp info badge
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: waGreen.withAlpha(18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: waGreen.withAlpha(64), width: 1),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'chat_rounded',
                  color: waGreen,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Targets WhatsApp\'s low-loss 200–500 KB band so images arrive sharp, not re-encoded.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: waGreen.withAlpha(230),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FilePickerSlotWidget(
            fileName: _fileName,
            fileSizeKb: _fileSizeKb,
            acceptLabel: 'JPEG, PNG',
            iconName: 'image_rounded',
            accentColor: waGreen,
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
                    'WhatsApp Settings',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFEAE8F5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTargetSizeSelector(waGreen),
                  const SizedBox(height: 16),
                  _buildToggleRow(
                    label: 'Progressive downscaling',
                    subtitle: 'Gradually reduce resolution for best quality',
                    value: _progressiveDownscale,
                    color: waGreen,
                    onChanged: (v) => setState(() => _progressiveDownscale = v),
                  ),
                  const SizedBox(height: 12),
                  _buildToggleRow(
                    label: 'Light sharpening',
                    subtitle: 'Compensate for compression softness',
                    value: _lightSharpening,
                    color: waGreen,
                    onChanged: (v) => setState(() => _lightSharpening = v),
                  ),
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
                  color: _isCompressing ? waGreen.withAlpha(128) : waGreen,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isCompressing
                      ? []
                      : [
                          BoxShadow(
                            color: waGreen.withAlpha(89),
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
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Optimizing...',
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
                            const CustomIconWidget(
                              iconName: 'chat_rounded',
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Optimize for WhatsApp',
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

  Widget _buildTargetSizeSelector(Color color) {
    final options = [
      {'label': '200 KB', 'value': 200},
      {'label': '350 KB', 'value': 350},
      {'label': '500 KB', 'value': 500},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target size',
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9A96B8),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            final isSelected = _targetSizeKb == opt['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => _targetSizeKb = opt['value'] as int),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withAlpha(38)
                        : AppTheme.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? color.withAlpha(128)
                          : const Color(0xFF4A4660),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      opt['label'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected ? color : const Color(0xFF9A96B8),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String label,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEAE8F5),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: const Color(0xFF9A96B8),
                ),
              ),
            ],
          ),
        ),
          Switch(
        value: value,
        onChanged: onChanged,
        // FIXED: Controls the thumb bubble color based on active/inactive states
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return color;
          }
          return const Color(0xFF4A4660); // Inactive thumb color
        }),
        // FIXED: Controls the background track color based on active/inactive states
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return color.withAlpha(64);
          }
          return const Color(0xFF2A2640); // Inactive track color
        }),
      ),
      ],
    );
  }
}
