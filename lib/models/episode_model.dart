import 'podcast_model.dart';

class Episode {
  final int id;
  final int podcastId;
  final String contentUrl;
  final String title;
  final int? season;
  final int? number;
  final String pictureUrl;
  final String description;
  final bool explicit;
  final int duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? playCount;  // Optional - not in editor's pick response
  final int? likeCount;  // Optional - not in editor's pick response
  final double? averageRating;
  final Podcast podcast;
  final DateTime? publishedAt;

  Episode({
    required this.id,
    required this.podcastId,
    required this.contentUrl,
    required this.title,
    this.season,
    this.number,
    required this.pictureUrl,
    required this.description,
    required this.explicit,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    this.playCount,
    this.likeCount,
    this.averageRating,
    required this.podcast,
    this.publishedAt,
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

  // Helper method to safely parse nullable int
  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  // Helper method to safely parse nullable double
  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    if (value is num) return value.toDouble();
    return null;
  }


  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: _parseInt(json['id']),
      podcastId: _parseInt(json['podcast_id']),
      contentUrl: json['content_url'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Episode',
      season: _parseNullableInt(json['season']),
      number: _parseNullableInt(json['number']),
      pictureUrl: json['picture_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      explicit: json['explicit'] as bool? ?? false,
      duration: _parseInt(json['duration']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      playCount: _parseNullableInt(json['play_count']),
      likeCount: _parseNullableInt(json['like_count']),
      averageRating: _parseNullableDouble(json['average_rating']),
      podcast: Podcast.fromJson(json['podcast'] as Map<String, dynamic>),
      publishedAt: json['published_at'] != null 
          ? DateTime.parse(json['published_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'podcast_id': podcastId,
      'content_url': contentUrl,
      'title': title,
      'season': season,
      'number': number,
      'picture_url': pictureUrl,
      'description': description,
      'explicit': explicit,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'play_count': playCount,
      'like_count': likeCount,
      'average_rating': averageRating,
      'podcast': podcast.toJson(),
      'published_at': publishedAt?.toIso8601String(),
    };
  }

  // Helper method to format duration
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes > 0) {
      return '$minutes min${seconds > 0 ? ' $seconds sec' : ''}';
    }
    return '$seconds sec';
  }

  // Helper method to format published date
  String get formattedPublishedDate {
    if (publishedAt == null) return '';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${publishedAt!.day} ${months[publishedAt!.month - 1]}, ${publishedAt!.year.toString().substring(2)}';
  }
}
