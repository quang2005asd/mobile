import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Initialize - check if user is already logged in
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId != null) {
        _currentUser = await _userRepository.getUserById(userId);
      }
    } catch (e) {
      _errorMessage = 'Lỗi khởi tạo: $e';
    }
    
    // Only notify after initialization is complete
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required DateTime dateOfBirth,
    required double height,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if email already exists
      final emailExists = await _userRepository.emailExists(email);
      if (emailExists) {
        _errorMessage = 'Email đã tồn tại';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create new user
      final user = User(
        name: name,
        email: email,
        password: password,
        gender: gender,
        dateOfBirth: dateOfBirth,
        height: height,
      );

      final userId = await _userRepository.createUser(user);
      _currentUser = user.copyWith(id: userId);

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi đăng ký: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.loginUser(email, password);
      
      if (_currentUser != null) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', _currentUser!.id!);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email hoặc mật khẩu không đúng';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Lỗi đăng nhập: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userRepository.updateUser(user);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi cập nhật: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
