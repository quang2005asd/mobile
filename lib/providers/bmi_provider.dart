import 'package:flutter/material.dart';
import '../data/models/bmi_record.dart';
import '../data/repositories/bmi_repository.dart';
import '../core/services/bmi_calculator_service.dart';

class BmiProvider with ChangeNotifier {
  final BmiRepository _bmiRepository = BmiRepository();
  
  List<BmiRecord> _bmiRecords = [];
  List<BmiRecord> _filteredRecords = [];
  BmiRecord? _selectedRecord;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<BmiRecord> get bmiRecords => _filteredRecords.isEmpty && _searchQuery.isEmpty 
      ? _bmiRecords 
      : _filteredRecords;
  BmiRecord? get selectedRecord => _selectedRecord;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all BMI records for user
  Future<void> loadBmiRecords(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bmiRecords = await _bmiRepository.getAllBmiRecords(userId);
      _filteredRecords = [];
      _searchQuery = '';
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi tải dữ liệu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create new BMI record
  Future<int?> createBmiRecord({
    required int userId,
    required double weight,
    required double height,
    required int age,
    required String gender,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bmi = BmiCalculatorService.calculateBmi(weight, height);
      final category = BmiCalculatorService.getBmiCategory(bmi);

      final record = BmiRecord(
        userId: userId,
        weight: weight,
        height: height,
        age: age,
        gender: gender,
        bmi: bmi,
        category: category,
        notes: notes,
      );

      final id = await _bmiRepository.createBmiRecord(record);
      await loadBmiRecords(userId); // Reload list
      
      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _errorMessage = 'Lỗi tạo bản ghi: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update BMI record
  Future<bool> updateBmiRecord(BmiRecord record) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Recalculate BMI and category
      final bmi = BmiCalculatorService.calculateBmi(record.weight, record.height);
      final category = BmiCalculatorService.getBmiCategory(bmi);
      
      final updatedRecord = record.copyWith(
        bmi: bmi,
        category: category,
      );

      await _bmiRepository.updateBmiRecord(updatedRecord);
      await loadBmiRecords(record.userId); // Reload list
      
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

  // Delete BMI record
  Future<bool> deleteBmiRecord(int id, int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bmiRepository.deleteBmiRecord(id);
      await loadBmiRecords(userId); // Reload list
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi xóa: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search BMI records
  Future<void> searchBmiRecords(int userId, String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredRecords = [];
    } else {
      _isLoading = true;
      notifyListeners();

      try {
        _filteredRecords = await _bmiRepository.searchBmiRecords(userId, query);
      } catch (e) {
        _errorMessage = 'Lỗi tìm kiếm: $e';
      }

      _isLoading = false;
    }
    
    notifyListeners();
  }

  // Get BMI record by id
  Future<void> selectBmiRecord(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedRecord = await _bmiRepository.getBmiRecordById(id);
    } catch (e) {
      _errorMessage = 'Lỗi tải chi tiết: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get BMI statistics
  Future<Map<String, double?>> getBmiStatistics(int userId) async {
    try {
      return await _bmiRepository.getBmiStatistics(userId);
    } catch (e) {
      return {'average': null, 'max': null, 'min': null};
    }
  }

  // Get BMI records for chart (last 6 months)
  Future<List<BmiRecord>> getBmiRecordsForChart(int userId) async {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    
    try {
      return await _bmiRepository.getBmiRecordsByDateRange(
        userId,
        sixMonthsAgo,
        now,
      );
    } catch (e) {
      return [];
    }
  }

  // Get latest BMI record
  Future<BmiRecord?> getLatestBmiRecord(int userId) async {
    try {
      return await _bmiRepository.getLatestBmiRecord(userId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelection() {
    _selectedRecord = null;
    notifyListeners();
  }
}
