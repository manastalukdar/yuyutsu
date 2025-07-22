import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > AppConstants.tabletBreakpoint) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    switch (_currentIndex) {
      case 0:
        return _buildBooksGrid();
      case 1:
        return _buildRecentlyRead();
      case 2:
        return _buildBookmarks();
      default:
        return _buildBooksGrid();
    }
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          labelType: NavigationRailLabelType.selected,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.library_books_outlined),
              selectedIcon: Icon(Icons.library_books),
              label: Text('Library'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: Text('Recent'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: Text('Bookmarks'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: _buildMobileLayout()),
      ],
    );
  }

  Widget _buildBooksGrid() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(),
              childAspectRatio: 0.7,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBookCard(index),
              childCount: 10, // Placeholder count
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyRead() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5, // Placeholder count
      itemBuilder: (context, index) => _buildRecentBookTile(index),
    );
  }

  Widget _buildBookmarks() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 8, // Placeholder count
      itemBuilder: (context, index) => _buildBookmarkTile(index),
    );
  }

  Widget _buildBookCard(int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/reader/book_$index'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.book,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Book ${index + 1}',
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Author Name',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    LinearProgressIndicator(
                      value: (index + 1) * 0.1,
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookTile(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Container(
          width: 48.w,
          height: 64.h,
          color: Colors.grey[300],
          child: const Icon(Icons.book, color: Colors.grey),
        ),
        title: Text('Recent Book ${index + 1}'),
        subtitle: Text('Last read: ${DateTime.now().toString().split(' ')[0]}'),
        trailing: Text('${(index + 1) * 15}%'),
        onTap: () => context.go('/reader/recent_$index'),
      ),
    );
  }

  Widget _buildBookmarkTile(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: Colors.amber),
        title: Text('Bookmark ${index + 1}'),
        subtitle: Text('Page ${(index + 1) * 23} - Chapter ${index + 1}'),
        onTap: () => context.go('/reader/bookmark_$index'),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    if (MediaQuery.of(context).size.width > AppConstants.tabletBreakpoint) {
      return const SizedBox.shrink();
    }

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          activeIcon: Icon(Icons.library_books),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: 'Recent',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          activeIcon: Icon(Icons.bookmark),
          label: 'Bookmarks',
        ),
      ],
    );
  }

  int _getCrossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    if (width > AppConstants.desktopBreakpoint) return 6;
    if (width > AppConstants.tabletBreakpoint) return 4;
    if (width > AppConstants.mobileBreakpoint) return 3;
    return 2;
  }

  void _addBook() {
    // TODO: Implement file picker for adding books
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add book functionality coming soon!')),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Books'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter book title, author, or keyword...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement search functionality
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}