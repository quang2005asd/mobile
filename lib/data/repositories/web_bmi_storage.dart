import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';

/// Fallback storage for web platform
class WebBmiStorage {
  static const String _recordsKey = 'bmi_records_list';
  static int _nextId = 1;

  // Create BMI record
  static Future<int> createBmiRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_recordsKey);
    final records = recordsJson != null 
        ? (jsonDecode(recordsJson) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    
    final newRecord = record.copyWith(id: _nextId++);
    records.add(newRecord.toMap());
    
    await prefs.setString(_recordsKey, jsonEncode(records));
    return newRecord.id!;
  }

  // Get all BMI records for a user
  static Future<List<BmiRecord>> getAllBmiRecords(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_recordsKey);
    if (recordsJson == null) return [];
    
    final records = (jsonDecode(recordsJson) as List)
        .cast<Map<String, dynamic>>()
        .where((r) => r['userId'] == userId)
        .map((r) => BmiRecord.fromMap(r))
        .toList();
    
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  // Get BMI record by id
  static Future<BmiRecord?> getBmiRecordById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_recordsKey);
    if (recordsJson == null) return null;
    
    final records = (jsonDecode(recordsJson) as List).cast<Map<String, dynamic>>();
    final recordMap = records.firstWhere(
      (r) => r['id'] == id,
      orElse: () => <String, dynamic>{},
    );
    
    return recordMap.isEmpty ? null : BmiRecord.fromMap(recordMap);
  }

  // Update BMI record
  static Future<int> updateBmiRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_recordsKey);
    if (recordsJson == null) return 0;
    
    final records = (jsonDecode(recordsJson) as List).cast<Map<String, dynamic>>();
    final index = records.indexWhere((r) => r['id'] == record.id);
    
    if (index != -1) {
      records[index] = record.toMap();
      await prefs.setString(_recordsKey, jsonEncode(records));
      return 1;
    }
    return 0;
  }

  // Delete BMI record
  static Future<int> deleteBmiRecord(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_recordsKey);
    if (recordsJson == null) return 0;
    
    final records = (jsonDecode(recordsJson) as List).cast<Map<String, dynamic>>();
    final initialLength = records.length;
    records.removeWhere((r) => r['id'] == id);
    
    if (records.length < initialLength) {
      await prefs.setString(_recordsKey, jsonEncode(records));
      return 1;
    }
    return 0;
  }

  // Search BMI records
  static Future<List<BmiRecord>> searchBmiRecords(int userId, String query) async {
    final allRecords = await getAllBmiRecords(userId);
    return allRecords.where((record) {
      return record.category.toLowerCase().contains(query.toLowerCase()) ||
             (record.notes?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Get BMI statistics
  static Future<Map<String, double?>> getBmiStatistics(int userId) async {
    final records = await getAllBmiRecords(userId);
    
    if (records.isEmpty) {
      return {'average': null, 'max': null, 'min': null};
    }
    
    final bmis = records.map((r) => r.bmi).toList();
    return {
      'average': bmis.reduce((a, b) => a + b) / bmis.length,
      'max': bmis.reduce((a, b) => a > b ? a : b),
      'min': bmis.reduce((a, b) => a < b ? a : b),
    };
  }

  // Get latest BMI record
  static Future<BmiRecord?> getLatestBmiRecord(int userId) async {
    final records = await getAllBmiRecords(userId);
    return records.isEmpty ? null : records.first;
  }
}
