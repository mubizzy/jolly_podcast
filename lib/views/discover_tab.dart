import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_header.dart';
import '../widgets/section_header.dart';
import '../widgets/episode_list_tile.dart';
import '../widgets/editors_pick_card.dart';
import '../widgets/new_release_card.dart';
import '../widgets/hero_podcast_card.dart';
import '../controllers/episodes_controller.dart';
import 'podcast_detail_screen.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  @override
  void initState() {
    super.initState();
    // Fetch trending episodes and editor's pick when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<EpisodesController>();
      controller.fetchTrendingEpisodes(refresh: true);
      controller.fetchEditorsPick(refresh: true);
      controller.fetchTopJollyPodcasts(refresh: true);
      controller.fetchLatestEpisodes(refresh: true);
      controller.fetchHandpickedEpisodes(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F1F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const AppHeader(),

              // Hero Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      '🔥 Hot & trending episodes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Hero podcast cards - API driven
                    Consumer<EpisodesController>(
                      builder: (context, controller, child) {
                        // Loading state
                        if (controller.isLoading &&
                            controller.trendingEpisodes.isEmpty) {
                          return SizedBox(
                            height: 408,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Color(0xFFD4E157),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Loading trending episodes...',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Error state
                        if (controller.hasError) {
                          return SizedBox(
                            height: 408,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[300],
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.errorMessage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () => controller.retry(),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFD4E157,
                                        ),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // Empty state
                        if (controller.isEmpty) {
                          return SizedBox(
                            height: 408,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.podcasts,
                                    color: Colors.grey[600],
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No trending episodes available',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Success state - show episodes
                        return SizedBox(
                          height: 408,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.trendingEpisodes.length,
                            itemBuilder: (context, index) {
                              final episode =
                                  controller.trendingEpisodes[index];
                              return Container(
                                width: MediaQuery.of(context).size.width - 32,
                                margin: EdgeInsets.only(
                                  right:
                                      index <
                                          controller.trendingEpisodes.length - 1
                                      ? 16
                                      : 0,
                                ),
                                child: HeroPodcastCard(
                                  podcastTitle: episode.podcast.title,
                                  episodeTitle: episode.title,
                                  description: episode.description,
                                  imageUrl: episode.pictureUrl,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PodcastDetailScreen(
                                              podcastTitle:
                                                  episode.podcast.title,
                                              episodeTitle: episode.title,
                                              description: episode.description,
                                              imageUrl: episode.pictureUrl,
                                              audioUrl: episode.contentUrl,
                                              date: episode
                                                  .formattedPublishedDate,
                                              duration:
                                                  episode.formattedDuration,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Editors pick Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SectionHeader(
                  title: '⭐️ Editor\'s pick',
                  onSeeAllTap: () {},
                ),
              ),
              const SizedBox(height: 12),

              // Editor's pick card - API driven
              Consumer<EpisodesController>(
                builder: (context, controller, child) {
                  // Loading state
                  if (controller.isEditorsPickLoading &&
                      controller.editorsPick == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4E157),
                          ),
                        ),
                      ),
                    );
                  }

                  // Error state
                  if (controller.hasEditorsPickError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[300],
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  controller.editorsPickErrorMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      controller.retryEditorsPick(),
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4E157),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  // Empty state
                  if (controller.editorsPick == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.podcasts,
                                color: Colors.grey[600],
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No editor\'s pick available',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Success state - show editor's pick
                  final episode = controller.editorsPick!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PodcastDetailScreen(
                              podcastTitle: episode.podcast.title,
                              episodeTitle: episode.title,
                              description: episode.description,
                              imageUrl: episode.pictureUrl,
                              audioUrl: episode.contentUrl,
                              date: episode.formattedPublishedDate,
                              duration: episode.formattedDuration,
                            ),
                          ),
                        );
                      },
                      child: EditorsPickCard(
                        title: episode.title,
                        author: 'by ${episode.podcast.author}',
                        description: episode.description,
                        imagePath: episode.pictureUrl,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // New Releases Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SectionHeader(title: 'New releases', onSeeAllTap: () {}),
              ),
              const SizedBox(height: 12),

              // New releases - API driven
              Consumer<EpisodesController>(
                builder: (context, controller, child) {
                  // Loading state
                  if (controller.isTopJollyLoading &&
                      controller.topJollyPodcasts.isEmpty) {
                    return SizedBox(
                      height: 270,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Color(0xFFD4E157),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading new releases...',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Error state
                  if (controller.hasTopJollyError) {
                    return SizedBox(
                      height: 270,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red[300],
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                controller.topJollyErrorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => controller.retryTopJolly(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4E157),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Empty state
                  if (controller.isTopJollyEmpty ||
                      controller.topJollyPodcasts.isEmpty) {
                    return SizedBox(
                      height: 270,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.podcasts,
                              color: Colors.grey[600],
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No new releases available',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Success state - show podcasts
                  return SizedBox(
                    height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: controller.topJollyPodcasts.length,
                      itemBuilder: (context, index) {
                        final podcast = controller.topJollyPodcasts[index];
                        return NewReleaseCard(
                          title: podcast.title,
                          author: 'By: ${podcast.author}',
                          imageUrl: podcast.pictureUrl,
                          isFollowing: false,
                          onTap: () {
                            // Navigate to podcast detail screen
                            // You can implement this later if needed
                          },
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // latest Episodes Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SectionHeader(
                  title: 'Latest episodes',
                  onSeeAllTap: () {},
                ),
              ),
              const SizedBox(height: 12),

              // Latest episodes - API driven
              Consumer<EpisodesController>(
                builder: (context, controller, child) {
                  // Loading state
                  if (controller.isLatestEpisodesLoading &&
                      controller.allLatestEpisodes.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFD4E157),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Error state
                  if (controller.hasLatestEpisodesError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[300],
                                  size: 32,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  controller.latestEpisodesErrorMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      controller.retryLatestEpisodes(),
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4E157),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  // Empty state
                  if (controller.isLatestEpisodesEmpty ||
                      controller.allLatestEpisodes.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.podcasts,
                                color: Colors.grey[600],
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No latest episodes available',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Success state - show episodes
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ...controller.latestEpisodes.map((episode) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PodcastDetailScreen(
                                    podcastTitle: episode.podcast.title,
                                    episodeTitle: episode.title,
                                    description: episode.description,
                                    imageUrl: episode.pictureUrl,
                                    audioUrl: episode.contentUrl,
                                    date: episode.formattedPublishedDate,
                                    duration: episode.formattedDuration,
                                  ),
                                ),
                              );
                            },
                            child: EpisodeListTile(
                              title: episode.title,
                              description: episode.description,
                              imageUrl: episode.pictureUrl,
                            ),
                          );
                        }),
                        if (controller.canShowMoreLatestEpisodes)
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  controller.showMoreLatestEpisodes(),
                              child: const Text(
                                'Show more',
                                style: TextStyle(
                                  color: Color(0xFFD4E157),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else if (controller.latestEpisodes.length > 3)
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  controller.showLessLatestEpisodes(),
                              child: const Text(
                                'Show less',
                                style: TextStyle(
                                  color: Color(0xFFD4E157),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // What if you tried & liked Section

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: SectionHeader(
              //     title: 'What if you tried & liked',
              //     onSeeAllTap: () {},
              //   ),
              // ),
              // const SizedBox(height: 12),
              // // 2x2 Grid
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: GridView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       mainAxisSpacing: 12,
              //       crossAxisSpacing: 12,
              //       childAspectRatio: 0.7,
              //     ),
              //     itemCount: 4,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         decoration: BoxDecoration(
              //           color: Colors.grey[850],
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             // Podcast cover
              //             Expanded(
              //               child: Container(
              //                 margin: const EdgeInsets.all(8),
              //                 decoration: BoxDecoration(
              //                   color: Colors.grey[700],
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //                 child: const Center(
              //                   child: Icon(
              //                     Icons.podcasts,
              //                     color: Colors.white,
              //                     size: 40,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             // Podcast info
              //             Padding(
              //               padding: const EdgeInsets.all(12.0),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   const Text(
              //                     'The NDL Show',
              //                     style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 13,
              //                       fontWeight: FontWeight.w600,
              //                     ),
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                   const SizedBox(height: 4),
              //                   Text(
              //                     'By Nathan Jassey',
              //                     style: TextStyle(
              //                       color: Colors.grey[400],
              //                       fontSize: 11,
              //                     ),
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              const SizedBox(height: 14),

              // Handpicked for you Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // const Icon(
                        //   Icons.star,
                        //   color: Color(0xFFD4E157),
                        //   size: 20,
                        // ),
                        const SizedBox(width: 8),
                        const Text(
                          '🔥 Handpicked for you',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: const Text(
                        'Podcasts you\'d love',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Handpicked podcast cards - API driven
                    Consumer<EpisodesController>(
                      builder: (context, controller, child) {
                        // Loading state
                        if (controller.isHandpickedLoading &&
                            controller.handpickedEpisodes.isEmpty) {
                          return Column(
                            children: [
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFD4E157),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        // Error state
                        if (controller.hasHandpickedError) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[300],
                                      size: 32,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      controller.handpickedErrorMessage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          controller.retryHandpicked(),
                                      icon: const Icon(Icons.refresh, size: 16),
                                      label: const Text('Retry'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFD4E157,
                                        ),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // Empty state
                        if (controller.isHandpickedEmpty ||
                            controller.handpickedEpisodes.isEmpty) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.podcasts,
                                    color: Colors.grey[600],
                                    size: 32,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No handpicked podcasts available',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Success state - show handpicked episodes
                        return Column(
                          children: controller.handpickedEpisodes
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final episode = entry.value;
                                return Column(
                                  children: [
                                    _buildSpotlightCard(
                                      episode.title,
                                      'By ${episode.podcast.author}',
                                      episode.description,
                                      imageUrl: episode.pictureUrl,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PodcastDetailScreen(
                                                  podcastTitle:
                                                      episode.podcast.title,
                                                  episodeTitle: episode.title,
                                                  description:
                                                      episode.description,
                                                  imageUrl: episode.pictureUrl,
                                                  audioUrl: episode.contentUrl,
                                                  date: episode
                                                      .formattedPublishedDate,
                                                  duration:
                                                      episode.formattedDuration,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (index <
                                        controller.handpickedEpisodes.length -
                                            1)
                                      const SizedBox(height: 16),
                                  ],
                                );
                              })
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Tags Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Browse by category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildCategoryChip('Arts'),
                        _buildCategoryChip('Business'),
                        _buildCategoryChip('Comedy'),
                        _buildCategoryChip('Education'),
                        _buildCategoryChip('Fiction'),
                        _buildCategoryChip('Government'),
                        _buildCategoryChip('Health & Fitness'),
                        _buildCategoryChip('History'),
                        _buildCategoryChip('Kids & Family'),
                        _buildCategoryChip('Leisure'),
                        _buildCategoryChip('Music'),
                        _buildCategoryChip('News'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _buildSpotlightCard(
    String title,
    String author,
    String description, {
    String? imageUrl,
    VoidCallback? onTap,
    int? episodeCount,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Podcast cover
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
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
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.podcasts,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              author,
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.grey[300], fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Follow'),
                  ),
                ),
                if (episodeCount != null) ...[
                  const SizedBox(width: 24),
                  Text(
                    "$episodeCount Episode${episodeCount != 1 ? 's' : ''}",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
