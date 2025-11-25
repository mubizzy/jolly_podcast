import 'package:flutter/foundation.dart';
import '../models/playlist_model.dart';
import '../services/playlists_service.dart';
import '../services/api_client.dart';

enum PlaylistsState {
  initial,
  loading,
  loaded,
  error,
  empty,
}

class PlaylistsController extends ChangeNotifier {
  PlaylistsState _state = PlaylistsState.initial;
  List<Playlist> _playlists = [];
  String _errorMessage = '';
  int _totalPlaylists = 0;
  int _currentPage = 1;
  final int _perPage = 15;

  // Getters
  PlaylistsState get state => _state;
  List<Playlist> get playlists => _playlists;
  String get errorMessage => _errorMessage;
  int get totalPlaylists => _totalPlaylists;
  bool get isLoading => _state == PlaylistsState.loading;
  bool get hasError => _state == PlaylistsState.error;
  bool get isEmpty => _state == PlaylistsState.empty;

  // Fetch playlists
  Future<void> fetchPlaylists({
    String? name,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _playlists = [];
    }

    if (_state == PlaylistsState.loading) return;

    _state = PlaylistsState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await PlaylistsService.getPlaylists(
        name: name,
        page: _currentPage,
        perPage: _perPage,
      );

      _totalPlaylists = response.total;

      if (response.playlists.isEmpty && _playlists.isEmpty) {
        _state = PlaylistsState.empty;
      } else {
        if (refresh) {
          _playlists = response.playlists;
        } else {
          _playlists.addAll(response.playlists);
        }
        _currentPage++;
        _state = PlaylistsState.loaded;
      }
    } on ApiException catch (e) {
      _state = PlaylistsState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = PlaylistsState.error;
      _errorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry after error
  Future<void> retry() async {
    await fetchPlaylists(refresh: true);
  }

  // Reset state
  void reset() {
    _state = PlaylistsState.initial;
    _playlists = [];
    _errorMessage = '';
    _totalPlaylists = 0;
    _currentPage = 1;
    notifyListeners();
  }
}
