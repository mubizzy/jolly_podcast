class Playlist {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unnamed Playlist',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      userId: json['user_id'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PaginatedPlaylistResponse {
  final List<Playlist> playlists;
  final int currentPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginatedPlaylistResponse({
    required this.playlists,
    required this.currentPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginatedPlaylistResponse.fromJson(Map<String, dynamic> json) {
    final playlistsData = json['data'] as List<dynamic>? ?? [];
    
    return PaginatedPlaylistResponse(
      playlists: playlistsData
          .map((item) => Playlist.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }
}
