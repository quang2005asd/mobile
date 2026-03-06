class Meal {
  final int? id;
  final int userId;
  final String name;
  final String mealType; // breakfast, lunch, dinner, snack
  final int calories;
  final double protein;
  final String? imageUrl;
  final DateTime date;

  Meal({
    this.id,
    required this.userId,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.protein,
    this.imageUrl,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'mealType': mealType,
      'calories': calories,
      'protein': protein,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      name: map['name'] as String,
      mealType: map['mealType'] as String,
      calories: map['calories'] as int,
      protein: map['protein'] as double,
      imageUrl: map['imageUrl'] as String?,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
