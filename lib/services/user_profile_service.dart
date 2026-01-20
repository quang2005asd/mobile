import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'dart:convert';

class UserProfileService {
  static const String _userProfileKey = 'user_profile';
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final jsonString = jsonEncode(profile.toJson());
      await _prefs.setString(_userProfileKey, jsonString);
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  // Get user profile
  static Future<UserProfile?> getUserProfile() async {
    try {
      final jsonString = _prefs.getString(_userProfileKey);
      if (jsonString == null) {
        return null;
      }
      final json = jsonDecode(jsonString);
      return UserProfile.fromJson(json);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Check if user has profile
  static Future<bool> hasProfile() async {
    return _prefs.containsKey(_userProfileKey);
  }

  // Delete user profile
  static Future<void> deleteUserProfile() async {
    try {
      await _prefs.remove(_userProfileKey);
    } catch (e) {
      print('Error deleting user profile: $e');
    }
  }

  // Update user profile
  static Future<UserProfile?> updateUserProfile({
    String? name,
    String? gender,
    DateTime? dateOfBirth,
    String? avatar,
  }) async {
    try {
      final existingProfile = await getUserProfile();
      if (existingProfile == null) {
        return null;
      }

      final updatedProfile = existingProfile.copyWith(
        name: name,
        gender: gender,
        dateOfBirth: dateOfBirth,
        avatar: avatar,
      );

      await saveUserProfile(updatedProfile);
      return updatedProfile;
    } catch (e) {
      print('Error updating user profile: $e');
      return null;
    }
  }

  // Get or create default profile
  static Future<UserProfile> getOrCreateProfile() async {
    final profile = await getUserProfile();
    if (profile != null) {
      return profile;
    }

    final defaultProfile = UserProfile(
      name: 'Người dùng',
      gender: 'male',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 25)),
    );

    await saveUserProfile(defaultProfile);
    return defaultProfile;
  }
}
