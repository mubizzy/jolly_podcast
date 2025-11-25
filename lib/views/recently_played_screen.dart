import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/episodes_controller.dart';
import '../widgets/episode_list_tile.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  late EpisodesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EpisodesController();
    _controller.fetchRecentlyPlayedEpisodes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EpisodesController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1F1F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1F1F),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Recently Played',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            // Loading state
            if (_controller.isRecentlyPlayedLoading &&
                _controller.recentlyPlayedEpisodes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              );
            }

            // Error state
            if (_controller.hasRecentlyPlayedError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _controller.recentlyPlayedErrorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _controller.retryRecentlyPlayed(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Empty state
            if (_controller.isRecentlyPlayedEmpty ||
                _controller.recentlyPlayedEpisodes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.podcasts,
                        color: Colors.grey[600],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recently played episodes',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Episodes you play will appear here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Success state - show recently played episodes
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _controller.recentlyPlayedEpisodes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final episode = _controller.recentlyPlayedEpisodes[index];
                return EpisodeListTile(
                  title: episode.title,
                  description: episode.description,
                  imageUrl: episode.pictureUrl,
                  onTap: () {
                    // TODO: Navigate to episode detail or play
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
