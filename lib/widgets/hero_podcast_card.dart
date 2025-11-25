import 'package:flutter/material.dart';

class HeroPodcastCard extends StatelessWidget {
  final String podcastTitle;
  final String episodeTitle;
  final String description;
  final String? imageUrl;
  final VoidCallback? onTap;

  const HeroPodcastCard({
    super.key,
    required this.podcastTitle,
    required this.episodeTitle,
    required this.description,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: _getImageProvider(),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {},
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Podcast cover with play button overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildImage(),
                    ),
                  ),
                  // Play button overlay
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4E157),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcastTitle,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episodeTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.favorite_border),
                  _buildActionButton(Icons.add_circle_outline),
                  _buildActionButton(Icons.share_outlined),
                  _buildActionButton(Icons.more_horiz),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to determine if URL is a network URL
  bool _isNetworkUrl(String? url) {
    if (url == null) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  // Get appropriate image provider based on URL type
  ImageProvider _getImageProvider() {
    if (_isNetworkUrl(imageUrl)) {
      return NetworkImage(imageUrl!);
    } else if (imageUrl != null) {
      return AssetImage(imageUrl!);
    } else {
      return const AssetImage('assets/images/hero_podcast.png');
    }
  }

  // Build image widget based on URL type
  Widget _buildImage() {
    if (_isNetworkUrl(imageUrl)) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.podcasts,
              color: Colors.white,
              size: 60,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFFD4E157),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl ?? 'assets/images/hero_podcast.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.podcasts,
              color: Colors.white,
              size: 60,
            ),
          );
        },
      );
    }
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 22),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
