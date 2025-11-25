import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../controllers/playlists_controller.dart';
import '../controllers/episodes_controller.dart';
import '../controllers/subscriptions_controller.dart';
import 'playlists_screen.dart';
import 'favorites_screen.dart';
import 'subscriptions_screen.dart';
import 'recently_played_screen.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  late PlaylistsController _playlistsController;
  late EpisodesController _episodesController;
  late SubscriptionsController _subscriptionsController;

  @override
  void initState() {
    super.initState();
    _playlistsController = PlaylistsController();
    _episodesController = EpisodesController();
    _subscriptionsController = SubscriptionsController();
    
    // Fetch playlists, favorites, subscriptions, and recently played on initialization
    _playlistsController.fetchPlaylists();
    _episodesController.fetchFavoriteEpisodes();
    _subscriptionsController.fetchSubscriptions();
    _episodesController.fetchRecentlyPlayedEpisodes();
  }

  @override
  void dispose() {
    _playlistsController.dispose();
    _episodesController.dispose();
    _subscriptionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaylistsController>.value(
          value: _playlistsController,
        ),
        ChangeNotifierProvider<EpisodesController>.value(
          value: _episodesController,
        ),
        ChangeNotifierProvider<SubscriptionsController>.value(
          value: _subscriptionsController,
        ),
      ],
      child: Consumer3<PlaylistsController, EpisodesController, SubscriptionsController>(
        builder: (context, playlistsController, episodesController, subscriptionsController, _) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A1F1F),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Header
              const AppHeader(),

              const SizedBox(height: 8),

              // Your Library Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Your Library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2x2 Grid of Library Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    _LibraryCard(
                      title: 'Your Favorites',
                      subtitle: episodesController.isFavoritesLoading
                          ? 'Loading...'
                          : '${episodesController.totalFavorites} ${episodesController.totalFavorites == 1 ? 'Episode' : 'Episodes'}',
                      icon: Icons.favorite,
                      iconColor: Colors.white,
                      gradientColors: const [
                        Color(0xFF8B5A5A),
                        Color(0xFF6B4444),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    _LibraryCard(
                      title: 'Recently played',
                      subtitle: episodesController.isRecentlyPlayedLoading
                          ? 'Loading...'
                          : '${episodesController.totalRecentlyPlayed} ${episodesController.totalRecentlyPlayed == 1 ? 'Episode' : 'Episodes'}',
                      icon: Icons.podcasts,
                      iconColor: const Color(0xFF4CAF50),
                      gradientColors: const [
                        Color(0xFFE8E8E8),
                        Color(0xFFC8D4C8),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecentlyPlayedScreen(),
                          ),
                        );
                      },
                    ),
                    _LibraryCard(
                      title: 'Your Playlists',
                      subtitle: playlistsController.isLoading
                          ? 'Loading...'
                          : '${playlistsController.totalPlaylists} ${playlistsController.totalPlaylists == 1 ? 'Playlist' : 'Playlists'}',
                      icon: Icons.queue_music,
                      iconColor: Colors.white,
                      gradientColors: const [
                        Color(0xFF2F4F4F),
                        Color(0xFF1F3F3F),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlaylistsScreen(),
                          ),
                        );
                      },
                    ),
                    _LibraryCard(
                      title: 'Podcast you follow',
                      subtitle: subscriptionsController.isLoading
                          ? 'Loading...'
                          : '${subscriptionsController.totalSubscriptions} ${subscriptionsController.totalSubscriptions == 1 ? 'Podcast' : 'Podcasts'}',
                      icon: Icons.star,
                      iconColor: const Color(0xFF8BC34A),
                      gradientColors: const [
                        Color(0xFF9CCC65),
                        Color(0xFF7CB342),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Episodes in queue Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Episodes in queue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.grey[700]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Empty state for queue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'All the episodes you add to queue will show here',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _LibraryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative circle
            Positioned(
              bottom: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon - Centered
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
