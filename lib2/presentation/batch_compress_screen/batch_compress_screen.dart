import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/batch_file_item_widget.dart';
import './widgets/batch_summary_widget.dart';

enum BatchFileStatus { idle, compressing, done, error }

class BatchFileModel {
  final String id;
  final String fileName;
  final String fileType;
  final int originalKb;
  BatchFileStatus status;
  int? compressedKb;
  double progress;

  BatchFileModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.originalKb,
    this.status = BatchFileStatus.idle,
    this.compressedKb,
    this.progress = 0.0,
  });

  factory BatchFileModel.fromMap(Map<String, dynamic> map) {
    return BatchFileModel(
      id: map['id'] as String,
      fileName: map['fileName'] as String,
      fileType: map['fileType'] as String,
      originalKb: map['originalKb'] as int,
      status: _statusFromString(map['status'] as String),
      compressedKb: map['compressedKb'] as int?,
      progress: (map['progress'] as num).toDouble(),
    );
  }

  static BatchFileStatus _statusFromString(String v) {
    switch (v) {
      case 'compressing':
        return BatchFileStatus.compressing;
      case 'done':
        return BatchFileStatus.done;
      case 'error':
        return BatchFileStatus.error;
      default:
        return BatchFileStatus.idle;
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'fileName': fileName,
    'fileType': fileType,
    'originalKb': originalKb,
    'status': status.name,
    'compressedKb': compressedKb,
    'progress': progress,
  };
}

class BatchCompressScreen extends StatefulWidget {
  const BatchCompressScreen({super.key});

  @override
  State<BatchCompressScreen> createState() => _BatchCompressScreenState();
}

class _BatchCompressScreenState extends State<BatchCompressScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  List<BatchFileModel> _files = [];
  bool _isCompressingAll = false;
  bool _showSummary = false;

  final List<Map<String, dynamic>> _mockFileMaps = [
    {
      'id': 'f1',
      'fileName': 'team_photo_retreat.jpg',
      'fileType': 'image',
      'originalKb': 5230,
      'status': 'idle',
      'compressedKb': null,
      'progress': 0.0,
    },
    {
      'id': 'f2',
      'fileName': 'contract_signed.pdf',
      'fileType': 'pdf',
      'originalKb': 9840,
      'status': 'idle',
      'compressedKb': null,
      'progress': 0.0,
    },
    {
      'id': 'f3',
      'fileName': 'product_launch.png',
      'fileType': 'image',
      'originalKb': 3120,
      'status': 'idle',
      'compressedKb': null,
      'progress': 0.0,
    },
    {
      'id': 'f4',
      'fileName': 'invoice_aug_2025.pdf',
      'fileType': 'pdf',
      'originalKb': 1840,
      'status': 'idle',
      'compressedKb': null,
      'progress': 0.0,
    },
    {
      'id': 'f5',
      'fileName': 'office_event.jpg',
      'fileType': 'image',
      'originalKb': 6650,
      'status': 'idle',
      'compressedKb': null,
      'progress': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _files = _mockFileMaps.map(BatchFileModel.fromMap).toList();
  }

  void _addFiles() {
    // TODO: Replace with file_picker multi-file integration
    final newFiles = [
      BatchFileModel(
        id: 'f${DateTime.now().millisecondsSinceEpoch}',
        fileName: 'new_attachment_${_files.length + 1}.jpg',
        fileType: 'image',
        originalKb: 2800 + (_files.length * 320),
      ),
    ];
    setState(() {
      _files.addAll(newFiles);
      _showSummary = false;
    });
  }

  void _removeFile(String id) {
    setState(() {
      _files.removeWhere((f) => f.id == id);
      if (_files.isEmpty) _showSummary = false;
    });
  }

  Future<void> _compressAll() async {
    if (_files.isEmpty || _isCompressingAll) return;
    setState(() {
      _isCompressingAll = true;
      _showSummary = false;
      for (final f in _files) {
        f.status = BatchFileStatus.idle;
        f.compressedKb = null;
        f.progress = 0.0;
      }
    });

    // TODO: Replace with actual parallel compression using flutter_image_compress / pdf compressor
    for (int i = 0; i < _files.length; i++) {
      setState(() => _files[i].status = BatchFileStatus.compressing);

      for (int p = 1; p <= 10; p++) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() => _files[i].progress = p / 10.0);
      }

      setState(() {
        _files[i].status = BatchFileStatus.done;
        _files[i].compressedKb = (_files[i].originalKb * 0.28).round();
      });
    }

    setState(() {
      _isCompressingAll = false;
      _showSummary = true;
    });
  }

  int get _totalOriginalKb => _files.fold(0, (sum, f) => sum + f.originalKb);

  int get _totalCompressedKb => _files
      .where((f) => f.compressedKb != null)
      .fold(0, (sum, f) => sum + (f.compressedKb ?? 0));

  int get _doneCount =>
      _files.where((f) => f.status == BatchFileStatus.done).length;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: _files.isEmpty
                  ? EmptyStateWidget(
                      iconName: 'layers_rounded',
                      title: 'No files added yet',
                      subtitle:
                          'Add multiple files to compress them all in one go. No uploads — everything stays on your device.',
                      ctaLabel: 'Add Files',
                      onCta: _addFiles,
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: isTablet
                              ? _buildTabletGrid()
                              : _buildPhoneList(),
                        ),
                        if (_showSummary)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: BatchSummaryWidget(
                              totalFiles: _files.length,
                              totalOriginalKb: _totalOriginalKb,
                              totalCompressedKb: _totalCompressedKb,
                            ),
                          ),
                        _buildCompressAllButton(),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch Compress',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEAE8F5),
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${_files.length} file${_files.length != 1 ? 's' : ''} · ${_formatSize(_totalOriginalKb)} total',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: const Color(0xFF9A96B8),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _addFiles,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, const Color(0xFF9B59B6)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withAlpha(77),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'add_rounded',
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Add Files',
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
        ],
      ),
    );
  }

  Widget _buildPhoneList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Dismissible(
            key: Key(file.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _removeFile(file.id),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(38),
                borderRadius: BorderRadius.circular(14),
              ),
              child: CustomIconWidget(
                iconName: 'delete_rounded',
                color: AppTheme.error,
                size: 22,
              ),
            ),
            child: BatchFileItemWidget(
              file: file,
              onRemove: () => _removeFile(file.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.2,
      ),
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        return BatchFileItemWidget(
          file: file,
          onRemove: () => _removeFile(file.id),
        );
      },
    );
  }

  Widget _buildCompressAllButton() {
    final allDone = _doneCount == _files.length && _files.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      child: GestureDetector(
        onTap: _isCompressingAll ? null : _compressAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 54,
          decoration: BoxDecoration(
            gradient: allDone
                ? LinearGradient(
                    colors: [AppTheme.secondary, const Color(0xFF00956F)],
                  )
                : LinearGradient(
                    colors: _isCompressingAll
                        ? [
                            AppTheme.primary.withAlpha(128),
                            const Color(0xFF9B59B6).withAlpha(128),
                          ]
                        : [AppTheme.primary, const Color(0xFF9B59B6)],
                  ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isCompressingAll
                ? []
                : [
                    BoxShadow(
                      color: (allDone ? AppTheme.secondary : AppTheme.primary)
                          .withAlpha(89),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: _isCompressingAll
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
                        'Compressing ${_doneCount + 1} of ${_files.length}...',
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
                        iconName: allDone
                            ? 'check_circle_rounded'
                            : 'layers_rounded',
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        allDone
                            ? 'Compress Again'
                            : 'Compress All ${_files.length} Files',
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
    );
  }

  String _formatSize(int kb) {
    if (kb >= 1024) return '${(kb / 1024).toStringAsFixed(1)} MB';
    return '$kb KB';
  }
}
