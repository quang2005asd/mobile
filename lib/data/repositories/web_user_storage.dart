import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Fallback storage for web platform (since SQLite doesn't work on web)
class WebUserStorage {
  static const String _usersKey = 'users_list';
  static int _nextId = 1;

  // Create user
  static Future<int> createUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    final users = usersJson != null 
        ? (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    
    final newUser = user.copyWith(id: _nextId++);
    users.add(newUser.toMap());
    
    await prefs.setString(_usersKey, jsonEncode(users));
    return newUser.id!;
  }

  // Get user by email
  static Future<User?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;
    
    final users = (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>();
    final userMap = users.firstWhere(
      (u) => u['email'] == email,
      orElse: () => <String, dynamic>{},
    );
    
    return userMap.isEmpty ? null : User.fromMap(userMap);
  }

  // Get user by id
  static Future<User?> getUserById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;
    
    final users = (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>();
    final userMap = users.firstWhere(
      (u) => u['id'] == id,
      orElse: () => <String, dynamic>{},
    );
    
    return userMap.isEmpty ? null : User.fromMap(userMap);
  }

  // Login user
  static Future<User?> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;
    
    final users = (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>();
    final userMap = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => <String, dynamic>{},
    );
    
    return userMap.isEmpty ? null : User.fromMap(userMap);
  }

  // Check if email exists
  static Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Update user
  static Future<int> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return 0;
    
    final users = (jsonDecode(usersJson) as List).cast<Map<String, dynamic>>();
    final index = users.indexWhere((u) => u['id'] == user.id);
    
    if (index != -1) {
      users[index] = user.toMap();
      await prefs.setString(_usersKey, jsonEncode(users));
      return 1;
    }
    return 0;
  }
}
