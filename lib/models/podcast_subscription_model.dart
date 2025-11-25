import 'podcast_model.dart';
import 'publisher_model.dart';

class PodcastSubscription extends Podcast {
  final bool isSubscribed;
  final int subscriberCount;

  PodcastSubscription({
    required super.id,
    required super.userId,
    required super.title,
    required super.author,
    required super.categoryName,
    required super.categoryType,
    required super.pictureUrl,
    super.coverPictureUrl,
    required super.description,
    super.embeddablePlayerSettings,
    required super.createdAt,
    required super.updatedAt,
    super.publisher,
    required this.isSubscribed,
    required this.subscriberCount,
  });

  factory PodcastSubscription.fromJson(Map<String, dynamic> json) {
    return PodcastSubscription(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
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
      isSubscribed: json['is_subscribed'] as bool? ?? false,
      subscriberCount: json['subscriber_count'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['is_subscribed'] = isSubscribed;
    map['subscriber_count'] = subscriberCount;
    return map;
  }
}
