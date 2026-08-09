import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BadgeStatus { success, warning, error, info, neutral }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeStatus status;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    this.status = BadgeStatus.neutral,
  });

  Color _bgColor() {
    switch (status) {
      case BadgeStatus.success:
        return const Color(0xFF00B894).withAlpha(38);
      case BadgeStatus.warning:
        return const Color(0xFFFDCB6E).withAlpha(38);
      case BadgeStatus.error:
        return const Color(0xFFE17055).withAlpha(38);
      case BadgeStatus.info:
        return const Color(0xFF6C5CE7).withAlpha(38);
      case BadgeStatus.neutral:
        return const Color(0xFF4A4660).withAlpha(102);
    }
  }

  Color _textColor() {
    switch (status) {
      case BadgeStatus.success:
        return const Color(0xFF00B894);
      case BadgeStatus.warning:
        return const Color(0xFFFDCB6E);
      case BadgeStatus.error:
        return const Color(0xFFE17055);
      case BadgeStatus.info:
        return const Color(0xFF6C5CE7);
      case BadgeStatus.neutral:
        return const Color(0xFF9A96B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _textColor(),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
