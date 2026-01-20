class BmiCalculator {
  // BMI Categories
  static const String underweight = 'Thiếu cân';
  static const String normalWeight = 'Bình thường';
  static const String overweight = 'Thừa cân';
  static const String obese = 'Béo phì';

  /// Calculate BMI from weight (kg) and height (m)
  /// Formula: BMI = weight / (height * height)
  static double calculateBmi(double weightKg, double heightM) {
    if (heightM <= 0) throw ArgumentError('Height must be positive');
    if (weightKg <= 0) throw ArgumentError('Weight must be positive');
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category based on BMI value
  static String getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return underweight;
    } else if (bmi < 25.0) {
      return normalWeight;
    } else if (bmi < 30.0) {
      return overweight;
    } else {
      return obese;
    }
  }

  /// Convert kg to lbs
  static double kgToLbs(double kg) => kg * 2.20462;

  /// Convert lbs to kg
  static double lbsToKg(double lbs) => lbs / 2.20462;

  /// Convert cm to m
  static double cmToM(double cm) => cm / 100;

  /// Convert m to cm
  static double mToCm(double m) => m * 100;

  /// Convert inches to cm
  static double inchesToCm(double inches) => inches * 2.54;

  /// Convert cm to inches
  static double cmToInches(double cm) => cm / 2.54;

    /// Get color for BMI category
  static String getColorHex(String category) {
    switch (category) {
      case underweight:
        return '#2196F3'; // Blue
      case normalWeight:
        return '#4CAF50'; // Green
      case overweight:
        return '#FF9800'; // Orange
      case obese:
        return '#F44336'; // Red
      default:
        return '#757575'; // Grey
    }
  }
}

