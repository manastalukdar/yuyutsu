import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/file_source.dart';
import '../../../data/services/file_service.dart';
import '../../../data/services/google_drive_service.dart';
import '../../providers/file_provider.dart';
import '../../widgets/file_list_tile.dart';

class FileBrowserScreen extends ConsumerStatefulWidget {
  const FileBrowserScreen({super.key});

  @override
  ConsumerState<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends ConsumerState<FileBrowserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _urlController = TextEditingController();
  final FileServiceManager _fileManager = FileServiceManager();
  final GoogleDriveService _googleDriveService = GoogleDriveService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRecentFiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentFiles() async {
    ref.read(fileProvider.notifier).loadRecentFiles();
  }

  Future<void> _browseLocalFiles() async {
    try {
      await _fileManager.requestPermissions();
      final files = await _fileManager.browseLocalFiles();
      ref.read(fileProvider.notifier).setFiles(files);
    } catch (e) {
      _showErrorDialog('Failed to browse local files: $e');
    }
  }

  Future<void> _browseDriveFiles() async {
    try {
      final hasPermission = await _googleDriveService.hasPermission();
      if (!hasPermission) {
        final granted = await _googleDriveService.requestPermission();
        if (!granted) {
          _showErrorDialog('Google Drive access denied');
          return;
        }
      }
      
      final files = await _googleDriveService.browseFiles();
      ref.read(fileProvider.notifier).setFiles(files);
    } catch (e) {
      _showErrorDialog('Failed to browse Google Drive: $e');
    }
  }

  Future<void> _loadFromUrl() async {
    if (_urlController.text.isEmpty) return;
    
    try {
      final fileLocation = await _fileManager.loadFromUrl(_urlController.text);
      if (fileLocation != null) {
        ref.read(fileProvider.notifier).addFile(fileLocation);
        _urlController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL file added successfully')),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to load URL: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileState = ref.watch(fileProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Files'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.folder), text: 'Local'),
            Tab(icon: Icon(Icons.cloud), text: 'Drive'),
            Tab(icon: Icon(Icons.link), text: 'URL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLocalTab(fileState),
          _buildDriveTab(fileState),
          _buildUrlTab(),
        ],
      ),
    );
  }

  Widget _buildLocalTab(FileState fileState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _browseLocalFiles,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Browse Local Files'),
                ),
              ),
            ],
          ),
        ),
        if (fileState.recentFiles.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fileState.recentFiles.length,
              itemBuilder: (context, index) {
                final file = fileState.recentFiles[index];
                return FileListTile(
                  file: file,
                  onTap: () => _openFile(file),
                );
              },
            ),
          ),
        ],
        if (fileState.files.isNotEmpty) ...[
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selected Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fileState.files.length,
              itemBuilder: (context, index) {
                final file = fileState.files[index];
                if (file.source == FileSource.local) {
                  return FileListTile(
                    file: file,
                    onTap: () => _openFile(file),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDriveTab(FileState fileState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _browseDriveFiles,
                  icon: const Icon(Icons.cloud_download),
                  label: Text(_googleDriveService.isSignedIn 
                    ? 'Browse Google Drive' 
                    : 'Sign in to Google Drive'),
                ),
              ),
              if (_googleDriveService.isSignedIn)
                IconButton(
                  onPressed: () async {
                    await _googleDriveService.signOut();
                    setState(() {});
                  },
                  icon: const Icon(Icons.logout),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: fileState.files.length,
            itemBuilder: (context, index) {
              final file = fileState.files[index];
              if (file.source == FileSource.googleDrive) {
                return FileListTile(
                  file: file,
                  onTap: () => _openFile(file),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUrlTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Enter URL',
              hintText: 'https://example.com/book.pdf',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _loadFromUrl(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loadFromUrl,
              icon: const Icon(Icons.download),
              label: const Text('Load from URL'),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Supported formats: PDF, EPUB, TXT, and other text formats',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _openFile(FileLocation file) {
    Navigator.pop(context, file);
  }
}