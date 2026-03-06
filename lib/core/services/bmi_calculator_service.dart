class BmiCalculatorService {
  // BMI Categories (Vietnamese)
  static const String underweight = 'Thiếu cân';
  static const String normal = 'Bình thường';
  static const String overweight = 'Thừa cân';
  static const String obese = 'Béo phì';

  /// Calculate BMI from weight (kg) and height (cm)
  static double calculateBmi(double weightKg, double heightCm) {
    if (heightCm <= 0) throw ArgumentError('Chiều cao phải lớn hơn 0');
    if (weightKg <= 0) throw ArgumentError('Cân nặng phải lớn hơn 0');
    
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category based on BMI value
  static String getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return underweight;
    } else if (bmi < 25.0) {
      return normal;
    } else if (bmi < 30.0) {
      return overweight;
    } else {
      return obese;
    }
  }

  /// Get BMI category description
  static String getCategoryDescription(String category) {
    switch (category) {
      case underweight:
        return 'Bạn đang thiếu cân. Hãy ăn uống đầy đủ và tập luyện để tăng cân khỏe mạnh.';
      case normal:
        return 'Tuyệt vời! Bạn đang có một mức cân nặng lý tưởng. Duy trì mức này sẽ giúp giảm nguy cơ mắc các bệnh mãn tính.';
      case overweight:
        return 'Bạn đang thừa cân. Hãy điều chỉnh chế độ ăn và tăng cường vận động để giảm cân.';
      case obese:
        return 'Bạn đang béo phì. Cần có kế hoạch giảm cân nghiêm túc với sự tư vấn của chuyên gia.';
      default:
        return '';
    }
  }

  /// Get BMI range for category
  static String getCategoryRange(String category) {
    switch (category) {
      case underweight:
        return '< 18.5';
      case normal:
        return '18.5 - 24.9';
      case overweight:
        return '25 - 29.9';
      case obese:
        return '> 30';
      default:
        return '';
    }
  }

  /// Calculate ideal weight range for height
  static Map<String, double> getIdealWeightRange(double heightCm) {
    final heightM = heightCm / 100;
    return {
      'min': 18.5 * heightM * heightM,
      'max': 24.9 * heightM * heightM,
    };
  }

  /// Calculate weight to lose/gain to reach ideal BMI
  static double getWeightToIdeal(double currentWeight, double heightCm) {
    final heightM = heightCm / 100;
    final currentBmi = calculateBmi(currentWeight, heightCm);
    
    if (currentBmi < 18.5) {
      // Need to gain weight
      final idealWeight = 18.5 * heightM * heightM;
      return idealWeight - currentWeight; // Positive value
    } else if (currentBmi > 24.9) {
      // Need to lose weight
      final idealWeight = 24.9 * heightM * heightM;
      return currentWeight - idealWeight; // Positive value
    }
    return 0; // Already ideal
  }

  /// Get BMI health tips
  static List<String> getHealthTips(String category) {
    switch (category) {
      case underweight:
        return [
          'Ăn 5-6 bữa nhỏ mỗi ngày',
          'Tăng cường protein và carbs',
          'Uống sữa và nước trái cây',
          'Tập thể dục nhẹ nhàng',
          'Nghỉ ngơi đầy đủ',
        ];
      case normal:
        return [
          'Duy trì chế độ ăn cân bằng',
          'Tập thể dục 30 phút/ngày',
          'Uống 2-3L nước mỗi ngày',
          'Ngủ đủ 7-8 giờ',
          'Kiểm tra sức khỏe định kỳ',
        ];
      case overweight:
        return [
          'Giảm 300-500 calo/ngày',
          'Tăng cường rau xanh và protein',
          'Tập cardio 45-60 phút/ngày',
          'Hạn chế đường và tinh bột',
          'Uống nhiều nước',
        ];
      case obese:
        return [
          'Giảm 500-750 calo/ngày',
          'Tập thể dục mỗi ngày',
          'Tham khảo ý kiến bác sĩ',
          'Theo dõi cân nặng hàng tuần',
          'Kiên trì và không nản chí',
        ];
      default:
        return [];
    }
  }

  /// Calculate daily calorie target
  static int getDailyCalorieTarget(
    String category,
    double weight,
    int age,
    String gender,
  ) {
    // Base metabolic rate (BMR) using Mifflin-St Jeor Equation
    double bmr;
    if (gender == 'male' || gender == 'Nam') {
      bmr = (10 * weight) + (6.25 * 170) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * 170) - (5 * age) - 161;
    }

    // Activity factor (moderate activity)
    final tdee = bmr * 1.55;

    // Adjust based on category
    switch (category) {
      case underweight:
        return (tdee + 300).toInt(); // Surplus
      case normal:
        return tdee.toInt(); // Maintenance
      case overweight:
        return (tdee - 400).toInt(); // Deficit
      case obese:
        return (tdee - 600).toInt(); // Larger deficit
      default:
        return tdee.toInt();
    }
  }
}
