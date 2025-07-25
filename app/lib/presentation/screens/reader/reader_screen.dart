import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';

class ReaderScreen extends StatefulWidget {
  final String bookId;
  
  const ReaderScreen({
    super.key,
    required this.bookId,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _showControls = true;
  double _currentProgress = 0.3;
  int _currentPage = 45;
  int _totalPages = 150;

  @override
  void initState() {
    super.initState();
    _hideControls();
  }

  void _hideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    if (_showControls) {
      _hideControls();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Reading background
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Stack(
            children: [
              // Main reading content
              GestureDetector(
                onTap: _toggleControls,
                child: _buildReaderContent(),
              ),
              
              // Top controls
              if (_showControls)
                _buildTopControls(),
              
              // Bottom controls
              if (_showControls)
                _buildBottomControls(),
              
              // Reading progress overlay
              if (_showControls)
                _buildProgressOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReaderContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > AppConstants.desktopBreakpoint;
          final isTablet = constraints.maxWidth > AppConstants.tabletBreakpoint;
          
          if (isDesktop) {
            // Multi-column layout for desktop
            return _buildMultiColumnText();
          } else if (isTablet) {
            // Optional dual-column for tablet
            return _buildSingleColumnText();
          } else {
            // Single column for mobile
            return _buildSingleColumnText();
          }
        },
      ),
    );
  }

  Widget _buildSingleColumnText() {
    return const SingleChildScrollView(
      child: Text(
        '''Chapter 1: The Beginning

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaeci cupiditate non provident.

[Content continues...]

This is placeholder text for the e-reader. In a real implementation, this would be loaded from the actual book file (EPUB, PDF, etc.) and properly formatted for reading.''',
        style: TextStyle(
          fontSize: AppConstants.defaultFontSize,
          height: 1.6,
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildMultiColumnText() {
    return Row(
      children: [
        Expanded(
          child: _buildSingleColumnText(),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: _buildSingleColumnText(),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Sample Book Title',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.white),
            onPressed: _addBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.text_format, color: Colors.white),
            onPressed: _showTextSettings,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toc',
                child: Text('Table of Contents'),
              ),
              const PopupMenuItem(
                value: 'notes',
                child: Text('Notes & Highlights'),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Text('Search in Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: _previousPage,
                ),
                Expanded(
                  child: Slider(
                    value: _currentProgress,
                    onChanged: (value) {
                      setState(() {
                        _currentProgress = value;
                        _currentPage = (value * _totalPages).round();
                      });
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: _nextPage,
                ),
              ],
            ),
            Text(
              'Page $_currentPage of $_totalPages',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverlay() {
    return Positioned(
      top: 60,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${(_currentProgress * 100).round()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _currentProgress = _currentPage / _totalPages;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _currentProgress = _currentPage / _totalPages;
      });
    }
  }

  void _addBookmark() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark added!')),
    );
  }

  void _showTextSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Text Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Font Size'),
              trailing: const Text('16pt'),
              onTap: () {
                // TODO: Implement font size adjustment
              },
            ),
            ListTile(
              leading: const Icon(Icons.font_download),
              title: const Text('Font Family'),
              trailing: const Text('System'),
              onTap: () {
                // TODO: Implement font family selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              trailing: const Text('Light'),
              onTap: () {
                // TODO: Implement theme selection
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'toc':
        // TODO: Show table of contents
        break;
      case 'notes':
        // TODO: Show notes and highlights
        break;
      case 'search':
        // TODO: Show search dialog
        break;
    }
  }
}