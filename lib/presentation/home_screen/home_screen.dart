import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/home_header_widget.dart';
import './widgets/mode_card_widget.dart';
import './widgets/privacy_badge_widget.dart';
import './widgets/recent_job_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<Map<String, dynamic>> _recentJobsMaps = [
    {
      'fileName': 'vacation_beach.jpg',
      'type': 'image',
      'originalKb': 4820,
      'compressedKb': 312,
      'mode': 'Image',
      'timestamp': '2 min ago',
    },
    {
      'fileName': 'project_proposal.pdf',
      'type': 'pdf',
      'originalKb': 8640,
      'compressedKb': 1124,
      'mode': 'PDF',
      'timestamp': '18 min ago',
    },
    {
      'fileName': 'family_photo.png',
      'type': 'image',
      'originalKb': 6210,
      'compressedKb': 198,
      'mode': 'WhatsApp',
      'timestamp': '1 hr ago',
    },
    {
      'fileName': 'batch_5_files.zip',
      'type': 'batch',
      'originalKb': 22400,
      'compressedKb': 3860,
      'mode': 'Batch',
      'timestamp': '3 hr ago',
    },
  ];

  List<Map<String, dynamic>> get _recentJobs => _recentJobsMaps;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _navigateTo(String mode) {
    if (mode == 'Batch') {
      context.go(AppRoutes.batchCompressScreen);
    } else {
      context.go(AppRoutes.compressScreen, extra: mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: HomeHeaderWidget(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: PrivacyBadgeWidget(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: Text(
                      'Choose a tool',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9A96B8),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 4 : 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: isTablet ? 0.85 : 1.1,
                    ),
                    delegate: SliverChildListDelegate([
                      ModeCardWidget(
                        iconName: 'image_rounded',
                        title: 'Image\nCompress',
                        subtitle: 'JPEG · Max 1920px',
                        gradientColors: [
                          AppTheme.primary,
                          const Color(0xFF9B59B6),
                        ],
                        onTap: () => _navigateTo('Image'),
                        delay: 0,
                      ),
                      ModeCardWidget(
                        iconName: 'chat_rounded',
                        title: 'WhatsApp\nOptimizer',
                        subtitle: '200–500 KB target',
                        gradientColors: [
                          const Color(0xFF25D366),
                          const Color(0xFF128C7E),
                        ],
                        onTap: () => _navigateTo('WhatsApp'),
                        delay: 80,
                      ),
                      ModeCardWidget(
                        iconName: 'picture_as_pdf_rounded',
                        title: 'PDF\nCompress',
                        subtitle: 'Reduce PDF size',
                        gradientColors: [
                          const Color(0xFFE17055),
                          const Color(0xFFD63031),
                        ],
                        onTap: () => _navigateTo('PDF'),
                        delay: 160,
                      ),
                      ModeCardWidget(
                        iconName: 'layers_rounded',
                        title: 'Batch\nCompress',
                        subtitle: 'Multiple files',
                        gradientColors: [
                          const Color(0xFFFDCB6E),
                          const Color(0xFFE67E22),
                        ],
                        onTap: () => _navigateTo('Batch'),
                        delay: 240,
                      ),
                    ]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent compressions',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFEAE8F5),
                          ),
                        ),
                        Text(
                          'Today',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final job = _recentJobs[index];
                      final reduction =
                          (((job['originalKb'] as int) -
                                      (job['compressedKb'] as int)) /
                                  (job['originalKb'] as int) *
                                  100)
                              .round();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RecentJobItemWidget(
                          fileName: job['fileName'] as String,
                          fileType: job['type'] as String,
                          originalKb: job['originalKb'] as int,
                          compressedKb: job['compressedKb'] as int,
                          reductionPercent: reduction,
                          mode: job['mode'] as String,
                          timestamp: job['timestamp'] as String,
                        ),
                      );
                    }, childCount: _recentJobs.length),
                  ),
                ),
                // Bottom padding for floating nav
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
