import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/bmi_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/bmi_record.dart';
import 'bmi_result_screen.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'Nam';
  int _age = 25;
  double _weight = 70;
  double _height = 170;
  bool _isCalculating = false;

  void _incrementAge() {
    if (_age < 100) {
      setState(() => _age++);
    }
  }

  void _decrementAge() {
    if (_age > 10) {
      setState(() => _age--);
    }
  }

  void _incrementWeight() {
    if (_weight < 300) {
      setState(() => _weight++);
    }
  }

  void _decrementWeight() {
    if (_weight > 30) {
      setState(() => _weight--);
    }
  }

  void _calculateBMI() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isCalculating = true);
      
      try {
        final authProvider = context.read<AuthProvider>();
        final bmiProvider = context.read<BmiProvider>();
        
        if (authProvider.currentUser == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vui lòng đăng nhập'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Tính BMI
        final bmi = _weight / ((_height / 100) * (_height / 100));
        
        // Lưu vào database
        await bmiProvider.createBmiRecord(
          userId: authProvider.currentUser!.id!,
          weight: _weight,
          height: _height,
          age: _age,
          gender: _selectedGender == 'Nam' ? 'male' : 'female',
          notes: null,
        );
        
        // Xác định category
        String category;
        if (bmi < 18.5) {
          category = 'Thiếu cân';
        } else if (bmi < 25) {
          category = 'Bình thường';
        } else if (bmi < 30) {
          category = 'Thừa cân';
        } else {
          category = 'Béo phì';
        }
        
        // Tạo record object để hiển thị kết quả
        final record = BmiRecord(
          userId: authProvider.currentUser!.id!,
          weight: _weight,
          height: _height,
          bmi: bmi,
          category: category,
          gender: _selectedGender == 'Nam' ? 'male' : 'female',
          age: _age,
        );

        // Chuyển sang màn hình kết quả với animation
        if (mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  BmiResultScreen(record: record),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi tính BMI: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isCalculating = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.account_circle, size: 32),
        ),
        title: const Text('Máy tính BMI'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gender selection
              Text(
                'Giới tính',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey800.withOpacity(0.5) : AppColors.grey200.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedGender = 'Nam');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedGender == 'Nam'
                                ? (isDark ? AppColors.grey700 : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _selectedGender == 'Nam'
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.male,
                                color: _selectedGender == 'Nam'
                                    ? AppColors.primary
                                    : AppColors.grey500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nam',
                                style: TextStyle(
                                  color: _selectedGender == 'Nam'
                                      ? AppColors.primary
                                      : AppColors.grey500,
                                  fontWeight: _selectedGender == 'Nam'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedGender = 'Nữ');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedGender == 'Nữ'
                                ? (isDark ? AppColors.grey700 : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _selectedGender == 'Nữ'
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.female,
                                color: _selectedGender == 'Nữ'
                                    ? AppColors.primary
                                    : AppColors.grey500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nữ',
                                style: TextStyle(
                                  color: _selectedGender == 'Nữ'
                                      ? AppColors.primary
                                      : AppColors.grey500,
                                  fontWeight: _selectedGender == 'Nữ'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Age and Weight
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'TUỔI',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey500,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _decrementAge,
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.grey700
                                          : AppColors.grey100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove, size: 16),
                                  ),
                                ),
                                Text(
                                  '$_age',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _incrementAge,
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.grey700
                                          : AppColors.grey100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'CÂN NẶNG (KG)',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey500,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _decrementWeight,
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.grey700
                                          : AppColors.grey100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove, size: 16),
                                  ),
                                ),
                                Text(
                                  '${_weight.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _incrementWeight,
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.grey700
                                          : AppColors.grey100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Height
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'CHIỀU CAO (CM)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${_height.toInt()}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'cm',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: isDark
                              ? AppColors.grey700
                              : AppColors.grey200,
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                          ),
                          overlayColor: AppColors.primary.withOpacity(0.2),
                          trackHeight: 8,
                        ),
                        child: Slider(
                          value: _height,
                          min: 100,
                          max: 250,
                          divisions: 150,
                          onChanged: (value) {
                            setState(() => _height = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Info text
              Text(
                'Chỉ số khối cơ thể (BMI) là thước đo lượng mỡ trong cơ thể dựa trên chiều cao và cân nặng áp dụng cho nam giới và phụ nữ trưởng thành.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: ElevatedButton(
              onPressed: _isCalculating ? null : _calculateBMI,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: AppColors.primary.withOpacity(0.4),
                elevation: _isCalculating ? 0 : 8,
              ),
            child: _isCalculating
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Tính toán BMI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
