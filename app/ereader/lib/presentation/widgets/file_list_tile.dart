import 'package:flutter/material.dart';
import '../../data/models/file_source.dart';

class FileListTile extends StatelessWidget {
  final FileLocation file;
  final VoidCallback onTap;

  const FileListTile({
    super.key,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: Text(
          file.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getSourceText()),
            if (file.size != null)
              Text(_formatFileSize(file.size!)),
            if (file.lastModified != null)
              Text(_formatDate(file.lastModified!)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLeadingIcon() {
    final extension = file.name.split('.').last.toLowerCase();
    IconData iconData;
    Color iconColor;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'epub':
        iconData = Icons.menu_book;
        iconColor = Colors.blue;
        break;
      case 'txt':
        iconData = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      case 'mobi':
      case 'azw':
      case 'azw3':
        iconData = Icons.book;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    Widget icon = Icon(iconData, color: iconColor, size: 32);

    // Add source indicator
    if (file.source != FileSource.local) {
      return Stack(
        children: [
          icon,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getSourceColor(),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(
                _getSourceIcon(),
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return icon;
  }

  String _getSourceText() {
    switch (file.source) {
      case FileSource.local:
        return 'Local Storage';
      case FileSource.googleDrive:
        return 'Google Drive';
      case FileSource.dropbox:
        return 'Dropbox';
      case FileSource.oneDrive:
        return 'OneDrive';
      case FileSource.url:
        return 'URL';
    }
  }

  Color _getSourceColor() {
    switch (file.source) {
      case FileSource.local:
        return Colors.green;
      case FileSource.googleDrive:
        return Colors.blue;
      case FileSource.dropbox:
        return Colors.lightBlue;
      case FileSource.oneDrive:
        return Colors.indigo;
      case FileSource.url:
        return Colors.purple;
    }
  }

  IconData _getSourceIcon() {
    switch (file.source) {
      case FileSource.local:
        return Icons.phone_android;
      case FileSource.googleDrive:
        return Icons.cloud;
      case FileSource.dropbox:
        return Icons.cloud;
      case FileSource.oneDrive:
        return Icons.cloud;
      case FileSource.url:
        return Icons.link;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}