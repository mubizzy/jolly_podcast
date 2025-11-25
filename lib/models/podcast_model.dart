import 'publisher_model.dart';

class Podcast {
  final int id;
  final int userId;
  final String title;
  final String author;
  final String categoryName;
  final String categoryType;
  final String pictureUrl;
  final String? coverPictureUrl;
  final String description;
  final dynamic embeddablePlayerSettings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Publisher? publisher;  // Optional - not in editor's pick response

  Podcast({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.categoryName,
    required this.categoryType,
    required this.pictureUrl,
    this.coverPictureUrl,
    required this.description,
    this.embeddablePlayerSettings,
    required this.createdAt,
    required this.updatedAt,
    this.publisher,
  });

  // Helper method to safely parse int from dynamic value (handles both int and String)
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    if (value is num) return value.toInt();
    return defaultValue;
  }

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      title: json['title'] as String? ?? 'Untitled Podcast',
      author: json['author'] as String? ?? 'Unknown Author',
      categoryName: json['category_name'] as String? ?? '',
      categoryType: json['category_type'] as String? ?? '',
      pictureUrl: json['picture_url'] as String? ?? '',
      coverPictureUrl: json['cover_picture_url'] as String?,
      description: json['description'] as String? ?? '',
      embeddablePlayerSettings: json['embeddable_player_settings'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      publisher: json['publisher'] != null 
          ? Publisher.fromJson(json['publisher'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'author': author,
      'category_name': categoryName,
      'category_type': categoryType,
      'picture_url': pictureUrl,
      'cover_picture_url': coverPictureUrl,
      'description': description,
      'embeddable_player_settings': embeddablePlayerSettings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'publisher': publisher?.toJson(),
    };
  }
}
