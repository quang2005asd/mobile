import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/bmi_record.dart';
import '../../core/database/database_helper.dart';

class BmiRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static const String _webRecordsKey = 'web_bmi_records';
  static int _webIdCounter = 1;

  // Web storage helpers
  Future<List<BmiRecord>> _getWebRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recordsJson = prefs.getString(_webRecordsKey);
    if (recordsJson == null) return [];
    
    final List<dynamic> recordsList = jsonDecode(recordsJson);
    return recordsList.map((json) => BmiRecord.fromMap(json)).toList();
  }

  Future<void> _saveWebRecords(List<BmiRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final String recordsJson = jsonEncode(records.map((r) => r.toMap()).toList());
    await prefs.setString(_webRecordsKey, recordsJson);
  }

  // Create BMI record
  Future<int> createBmiRecord(BmiRecord record) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      final newRecord = record.copyWith(id: _webIdCounter++);
      records.add(newRecord);
      await _saveWebRecords(records);
      return newRecord.id!;
    } else {
      final db = await _dbHelper.database;
      return await db.insert('bmi_records', record.toMap());
    }
  }

  // Get all BMI records for a user
  Future<List<BmiRecord>> getAllBmiRecords(int userId) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      final userRecords = records.where((r) => r.userId == userId).toList();
      userRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return userRecords;
    } else {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'bmi_records',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'timestamp DESC',
      );

      return maps.map((map) => BmiRecord.fromMap(map)).toList();
    }
  }

  // Get BMI record by id
  Future<BmiRecord?> getBmiRecordById(int id) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      try {
        return records.firstWhere((r) => r.id == id);
      } catch (e) {
        return null;
      }
    } else {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'bmi_records',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return BmiRecord.fromMap(maps.first);
      }
      return null;
    }
  }

  // Update BMI record
  Future<int> updateBmiRecord(BmiRecord record) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      final index = records.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        records[index] = record;
        await _saveWebRecords(records);
        return 1;
      }
      return 0;
    } else {
      final db = await _dbHelper.database;
      return await db.update(
        'bmi_records',
        record.toMap(),
        where: 'id = ?',
        whereArgs: [record.id],
      );
    }
  }

  // Delete BMI record
  Future<int> deleteBmiRecord(int id) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      records.removeWhere((r) => r.id == id);
      await _saveWebRecords(records);
      return 1;
    } else {
      final db = await _dbHelper.database;
      return await db.delete(
        'bmi_records',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Search BMI records
  Future<List<BmiRecord>> searchBmiRecords(int userId, String query) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      return records
          .where((r) =>
              r.userId == userId &&
              (r.category.toLowerCase().contains(query.toLowerCase()) ||
                  (r.notes?.toLowerCase().contains(query.toLowerCase()) ??
                      false)))
          .toList();
    } else {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'bmi_records',
        where: 'userId = ? AND (category LIKE ? OR notes LIKE ?)',
        whereArgs: [userId, '%$query%', '%$query%'],
        orderBy: 'timestamp DESC',
      );

      return maps.map((map) => BmiRecord.fromMap(map)).toList();
    }
  }

  // Get BMI records by date range
  Future<List<BmiRecord>> getBmiRecordsByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (kIsWeb) {
      final records = await _getWebRecords();
      return records
          .where((r) =>
              r.userId == userId &&
              r.timestamp.isAfter(startDate) &&
              r.timestamp.isBefore(endDate))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'bmi_records',
        where: 'userId = ? AND timestamp BETWEEN ? AND ?',
        whereArgs: [
          userId,
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
        orderBy: 'timestamp ASC',
      );

      return maps.map((map) => BmiRecord.fromMap(map)).toList();
    }
  }

  // Get average BMI
  Future<double?> getAverageBmi(int userId) async {
    final records = await getAllBmiRecords(userId);
    if (records.isEmpty) return null;
    final sum = records.fold<double>(0, (sum, r) => sum + r.bmi);
    return sum / records.length;
  }

  // Get latest BMI
  Future<BmiRecord?> getLatestBmiRecord(int userId) async {
    final records = await getAllBmiRecords(userId);
    return records.isNotEmpty ? records.first : null;
  }

  // Get BMI statistics
  Future<Map<String, double?>> getBmiStatistics(int userId) async {
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
}
