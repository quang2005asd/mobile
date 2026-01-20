import 'dart:convert';

class BmiRecord {
  final double weight;
  final double height;
  final double bmi;
  final String category;
  final String weightUnit;
  final String heightUnit;
  final DateTime timestamp;

  BmiRecord({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.weightUnit,
    required this.heightUnit,
    required this.timestamp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'category': category,
      'weightUnit': weightUnit,
      'heightUnit': heightUnit,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    return BmiRecord(
      weight: json['weight'] as double,
      height: json['height'] as double,
      bmi: json['bmi'] as double,
      category: json['category'] as String,
      weightUnit: json['weightUnit'] as String,
      heightUnit: json['heightUnit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Serialize to string
  String toJsonString() => jsonEncode(toJson());

  // Deserialize from string
  static BmiRecord fromJsonString(String jsonString) {
    return BmiRecord.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}

