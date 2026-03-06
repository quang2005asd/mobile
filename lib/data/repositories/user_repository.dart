import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../../core/database/database_helper.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static const String _webUsersKey = 'web_users';
  static int _webIdCounter = 1;

  // Web storage helpers
  Future<List<User>> _getWebUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_webUsersKey);
    if (usersJson == null) return [];
    
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.map((json) => User.fromMap(json)).toList();
  }

  Future<void> _saveWebUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final String usersJson = jsonEncode(users.map((u) => u.toMap()).toList());
    await prefs.setString(_webUsersKey, usersJson);
  }

  // Create user
  Future<int> createUser(User user) async {
    if (kIsWeb) {
      // Web implementation using SharedPreferences
      final users = await _getWebUsers();
      final newUser = user.copyWith(id: _webIdCounter++);
      users.add(newUser);
      await _saveWebUsers(users);
      return newUser.id!;
    } else {
      // Mobile implementation using SQLite
      final db = await _dbHelper.database;
      return await db.insert('users', user.toMap());
    }
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Get user by id
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update user
  Future<int> updateUser(User user) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
        await _saveWebUsers(users);
        return 1;
      }
      return 0;
    } else {
      final db = await _dbHelper.database;
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      users.removeWhere((u) => u.id == id);
      await _saveWebUsers(users);
      return 1;
    } else {
      final db = await _dbHelper.database;
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Login user
  Future<User?> loginUser(String email, String password) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      try {
        return users.firstWhere(
          (u) => u.email == email && u.password == password,
        );
      } catch (e) {
        return null;
      }
    } else {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    }
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    if (kIsWeb) {
      final users = await _getWebUsers();
      return users.any((u) => u.email == email);
    } else {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return maps.isNotEmpty;
    }
  }
}
