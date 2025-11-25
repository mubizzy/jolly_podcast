import 'package:flutter/foundation.dart';
import '../models/podcast_subscription_model.dart';
import '../services/podcasts_service.dart';
import '../services/api_client.dart';

class SubscriptionsController extends ChangeNotifier {
  List<PodcastSubscription> _subscriptions = [];
  bool _isLoading = false;
  String? _error;
  int _totalSubscriptions = 0;
  int _currentPage = 1;
  int _lastPage = 1;

  // Getters
  List<PodcastSubscription> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalSubscriptions => _totalSubscriptions;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  bool get hasMore => _currentPage < _lastPage;

  // Fetch subscriptions
  Future<void> fetchSubscriptions({int page = 1, int perPage = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await PodcastsService.getSubscriptions(
        page: page,
        perPage: perPage,
      );

      _subscriptions = result['subscriptions'] as List<PodcastSubscription>;
      _totalSubscriptions = result['total'] as int;
      _currentPage = result['current_page'] as int;
      _lastPage = result['last_page'] as int;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _subscriptions = [];
      _totalSubscriptions = 0;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _subscriptions = [];
      _totalSubscriptions = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more subscriptions (for pagination)
  Future<void> loadMore({int perPage = 10}) async {
    if (!hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await PodcastsService.getSubscriptions(
        page: _currentPage + 1,
        perPage: perPage,
      );

      final moreSubscriptions =
          result['subscriptions'] as List<PodcastSubscription>;
      _subscriptions.addAll(moreSubscriptions);
      _currentPage = result['current_page'] as int;
      _lastPage = result['last_page'] as int;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear subscriptions
  void clear() {
    _subscriptions = [];
    _totalSubscriptions = 0;
    _currentPage = 1;
    _lastPage = 1;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
