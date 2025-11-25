import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/subscriptions_controller.dart';
import '../models/podcast_subscription_model.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  late SubscriptionsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SubscriptionsController();
    _controller.fetchSubscriptions(perPage: 20);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SubscriptionsController>.value(
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
            'Podcasts You Follow',
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
            if (_controller.isLoading && _controller.subscriptions.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              );
            }

            // Error state
            if (_controller.error != null && _controller.subscriptions.isEmpty) {
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
                        _controller.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _controller.fetchSubscriptions(perPage: 20),
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
            if (_controller.subscriptions.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border,
                        color: Colors.grey[600],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No subscriptions yet',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start following podcasts to see them here',
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

            // Success state - show subscriptions
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _controller.subscriptions.length + 
                         (_controller.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Load more button
                if (index == _controller.subscriptions.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: _controller.isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF4CAF50),
                            )
                          : ElevatedButton(
                              onPressed: () => _controller.loadMore(perPage: 20),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Load More',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                  );
                }

                final subscription = _controller.subscriptions[index];
                return _PodcastSubscriptionCard(subscription: subscription);
              },
            );
          },
        ),
      ),
    );
  }
}

class _PodcastSubscriptionCard extends StatelessWidget {
  final PodcastSubscription subscription;

  const _PodcastSubscriptionCard({required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A3A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to podcast detail screen
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Podcast image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: subscription.pictureUrl.isNotEmpty
                      ? Image.network(
                          subscription.pictureUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFF2F4F4F),
                              child: const Icon(
                                Icons.podcasts,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFF2F4F4F),
                          child: const Icon(
                            Icons.podcasts,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                // Podcast details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        subscription.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Author
                      Text(
                        subscription.author,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Category
                      if (subscription.categoryName.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F4F4F),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            subscription.categoryName,
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      // Subscriber count
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.grey[500],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${subscription.subscriberCount} ${subscription.subscriberCount == 1 ? 'subscriber' : 'subscribers'}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
