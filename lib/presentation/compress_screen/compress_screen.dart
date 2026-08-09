import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import './widgets/compress_mode_tabs_widget.dart';
import './widgets/image_compress_panel_widget.dart';
import './widgets/pdf_compress_panel_widget.dart';
import './widgets/whatsapp_compress_panel_widget.dart';

class CompressScreen extends StatefulWidget {
  const CompressScreen({super.key});

  @override
  State<CompressScreen> createState() => _CompressScreenState();
}

class _CompressScreenState extends State<CompressScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _selectedMode = 0; // 0=Image, 1=WhatsApp, 2=PDF
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedMode = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            CompressModeTabsWidget(
              selectedIndex: _selectedMode,
              onTabChanged: (i) {
                setState(() => _selectedMode = i);
                _tabController.animateTo(i);
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ImageCompressPanelWidget(),
                  WhatsAppCompressPanelWidget(),
                  PdfCompressPanelWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compress',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEAE8F5),
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Pick a file and shrink it instantly',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A96B8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.secondary.withAlpha(77),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_rounded, size: 12, color: AppTheme.secondary),
                const SizedBox(width: 4),
                Text(
                  'On-Device',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
