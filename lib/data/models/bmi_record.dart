class BmiRecord {
  final int? id;
  final int userId;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final double bmi;
  final String category;
  final String? notes;
  final DateTime timestamp;

  BmiRecord({
    this.id,
    required this.userId,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.bmi,
    required this.category,
    this.notes,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'bmi': bmi,
      'category': category,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BmiRecord.fromMap(Map<String, dynamic> map) {
    return BmiRecord(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      age: map['age'] as int,
      gender: map['gender'] as String,
      bmi: (map['bmi'] as num).toDouble(),
      category: map['category'] as String,
      notes: map['notes'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  BmiRecord copyWith({
    int? id,
    int? userId,
    double? weight,
    double? height,
    int? age,
    String? gender,
    double? bmi,
    String? category,
    String? notes,
    DateTime? timestamp,
  }) {
    return BmiRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bmi: bmi ?? this.bmi,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
