import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _user != null;

  // Initialize - check if user is already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await StorageService.getToken();
      _user = await StorageService.getUser();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String phoneNumber, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call auth service
      final LoginResponse response = await AuthService.login(phoneNumber, password);

      // Save token and user data
      await StorageService.saveToken(response.token);
      await StorageService.saveUser(response.user);

      // Update state
      _token = response.token;
      _user = response.user;
      _errorMessage = null;

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await StorageService.clearAll();
      _token = null;
      _user = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to logout';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
