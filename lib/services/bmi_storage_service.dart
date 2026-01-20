import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_record.dart';

class BmiStorageService {
  static const String _historyKey = 'bmi_history';

  /// Lưu một bản ghi BMI mới
  static Future<void> saveBmiRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBmiHistory();
    history.add(record);

    final jsonList = history.map((r) => r.toJsonString()).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  /// Lấy toàn bộ lịch sử BMI
  static Future<List<BmiRecord>> getBmiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_historyKey) ?? [];

    return jsonList.map((json) => BmiRecord.fromJsonString(json)).toList();
  }

  /// Xóa một bản ghi BMI theo index
  static Future<void> deleteBmiRecord(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBmiHistory();

    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      final jsonList = history.map((r) => r.toJsonString()).toList();
      await prefs.setStringList(_historyKey, jsonList);
    }
  }

  /// Xóa một bản ghi BMI theo timestamp
  static Future<void> deleteRecord(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBmiHistory();

    history.removeWhere((record) => record.timestamp == timestamp);
    final jsonList = history.map((r) => r.toJsonString()).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  /// Xóa toàn bộ lịch sử
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Lấy BMI trung bình từ lịch sử
  static Future<double?> getAverageBmi() async {
    final history = await getBmiHistory();
    if (history.isEmpty) return null;

    final sum = history.fold<double>(0, (sum, record) => sum + record.bmi);
    return sum / history.length;
  }

  /// Lấy BMI cao nhất
  static Future<double?> getMaxBmi() async {
    final history = await getBmiHistory();
    if (history.isEmpty) return null;

    return history.fold<double>(history[0].bmi,
      (max, record) => record.bmi > max ? record.bmi : max);
  }

  /// Lấy BMI thấp nhất
  static Future<double?> getMinBmi() async {
    final history = await getBmiHistory();
    if (history.isEmpty) return null;

    return history.fold<double>(history[0].bmi,
      (min, record) => record.bmi < min ? record.bmi : min);
  }
}

