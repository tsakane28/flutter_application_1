import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import './custom_icon_widget.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final bool useGradient;

  const AppBarWidget({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
    this.useGradient = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: useGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.backgroundDark,
                  AppTheme.backgroundDark.withAlpha(217),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
          : const BoxDecoration(color: AppTheme.backgroundDark),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBack
            ? GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const CustomIconWidget(
                    iconName: 'arrow_back_ios_new_rounded',
                    color: Color(0xFFEAE8F5),
                    size: 18,
                  ),
                ),
              )
            : null,
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFEAE8F5),
          ),
        ),
        actions: actions,
      ),
    );
  }
}
