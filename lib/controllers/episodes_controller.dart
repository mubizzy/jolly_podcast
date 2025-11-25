import 'package:flutter/foundation.dart';
import '../models/episode_model.dart';
import '../models/podcast_model.dart';
import '../services/episodes_service.dart';
import '../services/api_client.dart';

enum EpisodesState {
  initial,
  loading,
  loaded,
  error,
  empty,
}

class EpisodesController extends ChangeNotifier {
  EpisodesState _state = EpisodesState.initial;
  List<Episode> _trendingEpisodes = [];
  String _errorMessage = '';
  int _currentPage = 1;
  final int _perPage = 10;
  bool _hasMore = true;

  // Editor's pick state
  EpisodesState _editorsPickState = EpisodesState.initial;
  Episode? _editorsPick;
  String _editorsPickErrorMessage = '';

  // Top jolly podcasts state
  EpisodesState _topJollyState = EpisodesState.initial;
  List<Podcast> _topJollyPodcasts = [];
  String _topJollyErrorMessage = '';

  // Latest episodes state
  EpisodesState _latestEpisodesState = EpisodesState.initial;
  List<Episode> _latestEpisodes = [];
  String _latestEpisodesErrorMessage = '';
  int _latestEpisodesDisplayCount = 3; // Initially show 3 episodes

  // Handpicked podcasts state
  EpisodesState _handpickedState = EpisodesState.initial;
  List<Episode> _handpickedEpisodes = [];
  String _handpickedErrorMessage = '';


  // Getters
  EpisodesState get state => _state;
  List<Episode> get trendingEpisodes => _trendingEpisodes;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == EpisodesState.loading;
  bool get hasError => _state == EpisodesState.error;
  bool get isEmpty => _state == EpisodesState.empty;
  bool get hasMore => _hasMore;

  // Editor's pick getters
  EpisodesState get editorsPickState => _editorsPickState;
  Episode? get editorsPick => _editorsPick;
  String get editorsPickErrorMessage => _editorsPickErrorMessage;
  bool get isEditorsPickLoading => _editorsPickState == EpisodesState.loading;
  bool get hasEditorsPickError => _editorsPickState == EpisodesState.error;
  bool get isEditorsPickEmpty => _editorsPickState == EpisodesState.empty;

  // Top jolly podcasts getters
  EpisodesState get topJollyState => _topJollyState;
  List<Podcast> get topJollyPodcasts => _topJollyPodcasts;
  String get topJollyErrorMessage => _topJollyErrorMessage;
  bool get isTopJollyLoading => _topJollyState == EpisodesState.loading;
  bool get hasTopJollyError => _topJollyState == EpisodesState.error;
  bool get isTopJollyEmpty => _topJollyState == EpisodesState.empty;

  // Latest episodes getters
  EpisodesState get latestEpisodesState => _latestEpisodesState;
  List<Episode> get latestEpisodes => _latestEpisodes.take(_latestEpisodesDisplayCount).toList();
  List<Episode> get allLatestEpisodes => _latestEpisodes;
  String get latestEpisodesErrorMessage => _latestEpisodesErrorMessage;
  bool get isLatestEpisodesLoading => _latestEpisodesState == EpisodesState.loading;
  bool get hasLatestEpisodesError => _latestEpisodesState == EpisodesState.error;
  bool get isLatestEpisodesEmpty => _latestEpisodesState == EpisodesState.empty;
  bool get canShowMoreLatestEpisodes => _latestEpisodes.length > _latestEpisodesDisplayCount;

  // Handpicked podcasts getters
  EpisodesState get handpickedState => _handpickedState;
  List<Episode> get handpickedEpisodes => _handpickedEpisodes;
  String get handpickedErrorMessage => _handpickedErrorMessage;
  bool get isHandpickedLoading => _handpickedState == EpisodesState.loading;
  bool get hasHandpickedError => _handpickedState == EpisodesState.error;
  bool get isHandpickedEmpty => _handpickedState == EpisodesState.empty;

  // Favorite episodes state
  EpisodesState _favoritesState = EpisodesState.initial;
  List<Episode> _favoriteEpisodes = [];
  String _favoritesErrorMessage = '';
  int _totalFavorites = 0;

  // Favorite episodes getters
  EpisodesState get favoritesState => _favoritesState;
  List<Episode> get favoriteEpisodes => _favoriteEpisodes;
  String get favoritesErrorMessage => _favoritesErrorMessage;
  int get totalFavorites => _totalFavorites;
  bool get isFavoritesLoading => _favoritesState == EpisodesState.loading;
  bool get hasFavoritesError => _favoritesState == EpisodesState.error;
  bool get isFavoritesEmpty => _favoritesState == EpisodesState.empty;

  // Recently played episodes state
  EpisodesState _recentlyPlayedState = EpisodesState.initial;
  List<Episode> _recentlyPlayedEpisodes = [];
  String _recentlyPlayedErrorMessage = '';
  int _totalRecentlyPlayed = 0;

  // Recently played episodes getters
  EpisodesState get recentlyPlayedState => _recentlyPlayedState;
  List<Episode> get recentlyPlayedEpisodes => _recentlyPlayedEpisodes;
  String get recentlyPlayedErrorMessage => _recentlyPlayedErrorMessage;
  int get totalRecentlyPlayed => _totalRecentlyPlayed;
  bool get isRecentlyPlayedLoading => _recentlyPlayedState == EpisodesState.loading;
  bool get hasRecentlyPlayedError => _recentlyPlayedState == EpisodesState.error;
  bool get isRecentlyPlayedEmpty => _recentlyPlayedState == EpisodesState.empty;

  // Fetch trending episodes
  Future<void> fetchTrendingEpisodes({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _trendingEpisodes = [];
      _hasMore = true;
    }

    if (_state == EpisodesState.loading) return;

    _state = EpisodesState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final episodes = await EpisodesService.getTrendingEpisodes(
        page: _currentPage,
        perPage: _perPage,
      );

      if (episodes.isEmpty && _trendingEpisodes.isEmpty) {
        _state = EpisodesState.empty;
      } else {
        if (refresh) {
          _trendingEpisodes = episodes;
        } else {
          _trendingEpisodes.addAll(episodes);
        }
        
        _hasMore = episodes.length >= _perPage;
        _currentPage++;
        _state = EpisodesState.loaded;
      }
    } on ApiException catch (e) {
      _state = EpisodesState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = EpisodesState.error;
      _errorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Load more episodes (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _state == EpisodesState.loading) return;
    await fetchTrendingEpisodes();
  }

  // Retry after error
  Future<void> retry() async {
    await fetchTrendingEpisodes(refresh: true);
  }

  // Fetch editor's pick episode
  Future<void> fetchEditorsPick({bool refresh = false}) async {
    if (_editorsPickState == EpisodesState.loading && !refresh) return;

    _editorsPickState = EpisodesState.loading;
    _editorsPickErrorMessage = '';
    notifyListeners();

    try {
      final episode = await EpisodesService.getEditorsPick();
      _editorsPick = episode;
      _editorsPickState = EpisodesState.loaded;
    } on ApiException catch (e) {
      _editorsPickState = EpisodesState.error;
      _editorsPickErrorMessage = e.message;
    } catch (e) {
      _editorsPickState = EpisodesState.error;
      _editorsPickErrorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry editor's pick after error
  Future<void> retryEditorsPick() async {
    await fetchEditorsPick(refresh: true);
  }

  // Fetch top jolly podcasts
  Future<void> fetchTopJollyPodcasts({bool refresh = false}) async {
    if (_topJollyState == EpisodesState.loading && !refresh) return;

    _topJollyState = EpisodesState.loading;
    _topJollyErrorMessage = '';
    notifyListeners();

    try {
      final podcasts = await EpisodesService.getTopJollyPodcasts(
        page: 1,
        perPage: 10,
      );

      if (podcasts.isEmpty) {
        _topJollyState = EpisodesState.empty;
      } else {
        _topJollyPodcasts = podcasts;
        _topJollyState = EpisodesState.loaded;
      }
    } on ApiException catch (e) {
      _topJollyState = EpisodesState.error;
      _topJollyErrorMessage = e.message;
    } catch (e) {
      _topJollyState = EpisodesState.error;
      _topJollyErrorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry top jolly podcasts after error
  Future<void> retryTopJolly() async {
    await fetchTopJollyPodcasts(refresh: true);
  }

  // Fetch latest episodes
  Future<void> fetchLatestEpisodes({bool refresh = false}) async {
    if (_latestEpisodesState == EpisodesState.loading && !refresh) return;

    _latestEpisodesState = EpisodesState.loading;
    _latestEpisodesErrorMessage = '';
    notifyListeners();

    try {
      final episodes = await EpisodesService.getLatestEpisodes(
        page: 1,
        perPage: 20,
      );

      if (episodes.isEmpty) {
        _latestEpisodesState = EpisodesState.empty;
      } else {
        _latestEpisodes = episodes;
        _latestEpisodesState = EpisodesState.loaded;
      }
    } on ApiException catch (e) {
      _latestEpisodesState = EpisodesState.error;
      _latestEpisodesErrorMessage = e.message;
    } catch (e) {
      _latestEpisodesState = EpisodesState.error;
      _latestEpisodesErrorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry latest episodes after error
  Future<void> retryLatestEpisodes() async {
    await fetchLatestEpisodes(refresh: true);
  }

  // Show more latest episodes
  void showMoreLatestEpisodes() {
    if (_latestEpisodes.length > _latestEpisodesDisplayCount) {
      _latestEpisodesDisplayCount = _latestEpisodes.length;
      notifyListeners();
    }
  }

  // Show less latest episodes
  void showLessLatestEpisodes() {
    _latestEpisodesDisplayCount = 3;
    notifyListeners();
  }

  // Fetch handpicked podcasts
  Future<void> fetchHandpickedEpisodes({bool refresh = false}) async {
    if (_handpickedState == EpisodesState.loading && !refresh) return;

    _handpickedState = EpisodesState.loading;
    _handpickedErrorMessage = '';
    notifyListeners();

    try {
      final episodes = await EpisodesService.getHandpickedPodcasts(
        amount: 3,
      );

      if (episodes.isEmpty) {
        _handpickedState = EpisodesState.empty;
      } else {
        _handpickedEpisodes = episodes;
        _handpickedState = EpisodesState.loaded;
      }
    } on ApiException catch (e) {
      _handpickedState = EpisodesState.error;
      _handpickedErrorMessage = e.message;
    } catch (e) {
      _handpickedState = EpisodesState.error;
      _handpickedErrorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry handpicked podcasts after error
  Future<void> retryHandpicked() async {
    await fetchHandpickedEpisodes(refresh: true);
  }

  // Fetch favorite episodes
  Future<void> fetchFavoriteEpisodes({bool refresh = false}) async {
    if (_favoritesState == EpisodesState.loading && !refresh) return;

    _favoritesState = EpisodesState.loading;
    _favoritesErrorMessage = '';
    notifyListeners();

    try {
      final episodes = await EpisodesService.getFavoriteEpisodes(
        page: 1,
        perPage: 50, // Fetch more to get accurate count
      );

      _totalFavorites = episodes.length;

      if (episodes.isEmpty) {
        _favoritesState = EpisodesState.empty;
      } else {
        _favoriteEpisodes = episodes;
        _favoritesState = EpisodesState.loaded;
      }
    } on ApiException catch (e) {
      _favoritesState = EpisodesState.error;
      _favoritesErrorMessage = e.message;
    } catch (e) {
      _favoritesState = EpisodesState.error;
      _favoritesErrorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry favorites after error
  Future<void> retryFavorites() async {
    await fetchFavoriteEpisodes(refresh: true);
  }

  // Fetch recently played episodes
  Future<void> fetchRecentlyPlayedEpisodes({bool refresh = false}) async {
    if (_recentlyPlayedState == EpisodesState.loading && !refresh) return;

    _recentlyPlayedState = EpisodesState.loading;
    _recentlyPlayedErrorMessage = '';
    notifyListeners();

    try {
      final episodes = await EpisodesService.getRecentlyPlayedEpisodes(
        page: 1,
        perPage: 50, // Fetch more to get accurate count
      );

      _totalRecentlyPlayed = episodes.length;

      if (episodes.isEmpty) {
        _recentlyPlayedState = EpisodesState.empty;
      } else {
        _recentlyPlayedEpisodes = episodes;
        _recentlyPlayedState = EpisodesState.loaded;
      }
    } on ApiException catch (e) {
      _recentlyPlayedState = EpisodesState.error;
      _recentlyPlayedErrorMessage = e.message;
    } catch (e) {
      _recentlyPlayedState = EpisodesState.error;
      _recentlyPlayedErrorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry recently played after error
  Future<void> retryRecentlyPlayed() async {
    await fetchRecentlyPlayedEpisodes(refresh: true);
  }

  // Reset state
  void reset() {
    _state = EpisodesState.initial;
    _trendingEpisodes = [];
    _errorMessage = '';
    _currentPage = 1;
    _hasMore = true;
    
    _editorsPickState = EpisodesState.initial;
    _editorsPick = null;
    _editorsPickErrorMessage = '';
    
    _topJollyState = EpisodesState.initial;
    _topJollyPodcasts = [];
    _topJollyErrorMessage = '';
    
    _latestEpisodesState = EpisodesState.initial;
    _latestEpisodes = [];
    _latestEpisodesErrorMessage = '';
    _latestEpisodesDisplayCount = 3;
    
    _handpickedState = EpisodesState.initial;
    _handpickedEpisodes = [];
    _handpickedErrorMessage = '';
    
    _favoritesState = EpisodesState.initial;
    _favoriteEpisodes = [];
    _favoritesErrorMessage = '';
    _totalFavorites = 0;
    
    _recentlyPlayedState = EpisodesState.initial;
    _recentlyPlayedEpisodes = [];
    _recentlyPlayedErrorMessage = '';
    _totalRecentlyPlayed = 0;
    
    notifyListeners();
  }
}
