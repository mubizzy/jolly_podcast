import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/categories_service.dart';
import '../services/api_client.dart';

enum CategoriesState {
  initial,
  loading,
  loaded,
  error,
  empty,
}

class CategoriesController extends ChangeNotifier {
  CategoriesState _state = CategoriesState.initial;
  List<CategoryGroup> _categoryGroups = [];
  String _errorMessage = '';

  // Getters
  CategoriesState get state => _state;
  List<CategoryGroup> get categoryGroups => _categoryGroups;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == CategoriesState.loading;
  bool get hasError => _state == CategoriesState.error;
  bool get isEmpty => _state == CategoriesState.empty;

  // Fetch categories
  Future<void> fetchCategories({bool refresh = false}) async {
    if (_state == CategoriesState.loading && !refresh) return;

    _state = CategoriesState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final categories = await CategoriesService.getCategories();

      if (categories.isEmpty) {
        _state = CategoriesState.empty;
      } else {
        _categoryGroups = categories;
        _state = CategoriesState.loaded;
      }
    } on ApiException catch (e) {
      _state = CategoriesState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = CategoriesState.error;
      _errorMessage = 'An unexpected error occurred. Please try again.';
    }

    notifyListeners();
  }

  // Retry after error
  Future<void> retry() async {
    await fetchCategories(refresh: true);
  }

  // Reset state
  void reset() {
    _state = CategoriesState.initial;
    _categoryGroups = [];
    _errorMessage = '';
    notifyListeners();
  }
}
