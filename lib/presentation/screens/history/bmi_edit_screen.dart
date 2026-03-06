import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/bmi_record.dart';
import '../../../providers/bmi_provider.dart';

class BmiEditScreen extends StatefulWidget {
  final BmiRecord record;

  const BmiEditScreen({super.key, required this.record});

  @override
  State<BmiEditScreen> createState() => _BmiEditScreenState();
}

class _BmiEditScreenState extends State<BmiEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedGender;
  late int _age;
  late double _weight;
  late double _height;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.record.gender == 'male' ? 'Nam' : 'Nữ';
    _age = widget.record.age;
    _weight = widget.record.weight;
    _height = widget.record.height;
  }

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

  Future<void> _updateBMI() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdating = true);
      
      try {
        final bmiProvider = context.read<BmiProvider>();
        
        // Tính BMI mới
        final bmi = _weight / ((_height / 100) * (_height / 100));
        
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
        
        // Tạo record cập nhật
        final updatedRecord = BmiRecord(
          id: widget.record.id,
          userId: widget.record.userId,
          weight: _weight,
          height: _height,
          bmi: bmi,
          category: category,
          gender: _selectedGender == 'Nam' ? 'male' : 'female',
          age: _age,
          timestamp: widget.record.timestamp,
        );

        // Cập nhật vào database
        await bmiProvider.updateBmiRecord(updatedRecord);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã cập nhật thông tin BMI'),
              backgroundColor: AppColors.success,
            ),
          );
          
          // Quay lại màn hình trước
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi cập nhật: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUpdating = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa BMI'),
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
                      child: _buildGenderButton('Nam', Icons.male, isDark),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildGenderButton('Nữ', Icons.female, isDark),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Age and Weight
              Row(
                children: [
                  Expanded(
                    child: _buildCounterCard(
                      'Tuổi',
                      _age,
                      'tuổi',
                      _decrementAge,
                      _incrementAge,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCounterCard(
                      'Cân nặng',
                      _weight.toInt(),
                      'kg',
                      _decrementWeight,
                      _incrementWeight,
                      isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Height Slider
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.grey800.withOpacity(0.5)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.grey700
                        : AppColors.grey200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Chiều cao',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '100 cm',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey400,
                            ),
                          ),
                          Text(
                            '250 cm',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isUpdating ? null : _updateBMI,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: AppColors.primary.withOpacity(0.4),
              elevation: 8,
            ),
            child: _isUpdating
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Cập nhật',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon, bool isDark) {
    final isSelected = _selectedGender == gender;
    return InkWell(
      onTap: () => setState(() => _selectedGender = gender),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.grey400 : AppColors.grey600),
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.grey400 : AppColors.grey600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterCard(
    String label,
    int value,
    String unit,
    VoidCallback onDecrement,
    VoidCallback onIncrement,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.grey700 : AppColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.grey700
                        : AppColors.grey200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
