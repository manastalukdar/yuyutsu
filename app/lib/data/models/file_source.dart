enum FileSource {
  local,
  googleDrive,
  dropbox,
  oneDrive,
  url,
}

class FileLocation {
  final String name;
  final String path;
  final FileSource source;
  final int? size;
  final DateTime? lastModified;
  final Map<String, dynamic>? metadata;

  const FileLocation({
    required this.name,
    required this.path,
    required this.source,
    this.size,
    this.lastModified,
    this.metadata,
  });

  FileLocation copyWith({
    String? name,
    String? path,
    FileSource? source,
    int? size,
    DateTime? lastModified,
    Map<String, dynamic>? metadata,
  }) {
    return FileLocation(
      name: name ?? this.name,
      path: path ?? this.path,
      source: source ?? this.source,
      size: size ?? this.size,
      lastModified: lastModified ?? this.lastModified,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'source': source.name,
      'size': size,
      'lastModified': lastModified?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FileLocation.fromMap(Map<String, dynamic> map) {
    return FileLocation(
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      source: FileSource.values.firstWhere(
        (e) => e.name == map['source'],
        orElse: () => FileSource.local,
      ),
      size: map['size']?.toInt(),
      lastModified: map['lastModified'] != null
          ? DateTime.parse(map['lastModified'])
          : null,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }
}