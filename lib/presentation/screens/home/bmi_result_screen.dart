import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/bmi_record.dart';
import '../history/history_screen.dart';

class BmiResultScreen extends StatelessWidget {
  final BmiRecord record;

  const BmiResultScreen({super.key, required this.record});

  String _getBmiCategory() {
    if (record.bmi < 18.5) return 'Thiếu cân';
    if (record.bmi < 25) return 'Bình thường';
    if (record.bmi < 30) return 'Thừa cân';
    return 'Béo phì';
  }

  Color _getBmiColor() {
    if (record.bmi < 18.5) return Colors.blue;
    if (record.bmi < 25) return AppColors.success;
    if (record.bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String _getBmiAdvice() {
    if (record.bmi < 18.5) {
      return 'Bạn nên tăng cân bằng cách ăn nhiều thực phẩm giàu dinh dưỡng và tập luyện để tăng cơ bắp.';
    } else if (record.bmi < 25) {
      return 'Chúc mừng! Bạn đang có cân nặng lý tưởng. Hãy duy trì lối sống lành mạnh này.';
    } else if (record.bmi < 30) {
      return 'Bạn nên giảm cân nhẹ bằng cách ăn uống điều độ và tăng cường vận động.';
    } else {
      return 'Bạn cần giảm cân nghiêm túc. Hãy tham khảo ý kiến bác sĩ và dinh dưỡng viên để có chế độ phù hợp.';
    }
  }

  IconData _getBmiIcon() {
    if (record.bmi < 18.5) return Icons.trending_down;
    if (record.bmi < 25) return Icons.check_circle;
    if (record.bmi < 30) return Icons.trending_up;
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bmiColor = _getBmiColor();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả BMI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
            tooltip: 'Xem lịch sử',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // BMI Score Circle với Hero animation
            Hero(
              tag: 'bmi_circle_${record.id ?? 'new'}',
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bmiColor.withOpacity(0.3),
                    bmiColor.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: bmiColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getBmiIcon(),
                      size: 60,
                      color: bmiColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      record.bmi.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBmiCategory(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: bmiColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),            ),
            const SizedBox(height: 40),

            // BMI Range Indicator
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey800.withOpacity(0.5) : AppColors.grey100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Phân loại BMI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  _buildBmiRangeItem('< 18.5', 'Thiếu cân', Colors.blue, record.bmi < 18.5),
                  const SizedBox(height: 8),
                  _buildBmiRangeItem('18.5 - 24.9', 'Bình thường', AppColors.success, record.bmi >= 18.5 && record.bmi < 25),
                  const SizedBox(height: 8),
                  _buildBmiRangeItem('25 - 29.9', 'Thừa cân', Colors.orange, record.bmi >= 25 && record.bmi < 30),
                  const SizedBox(height: 8),
                  _buildBmiRangeItem('≥ 30', 'Béo phì', Colors.red, record.bmi >= 30),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Advice Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bmiColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: bmiColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 40,
                    color: bmiColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Lời khuyên',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: bmiColor,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getBmiAdvice(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Your Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey800.withOpacity(0.5) : AppColors.grey100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin của bạn',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.wc,
                          'Giới tính',
                          record.gender == 'male' ? 'Nam' : 'Nữ',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.cake,
                          'Tuổi',
                          '${record.age}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.monitor_weight,
                          'Cân nặng',
                          '${record.weight.toStringAsFixed(0)} kg',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.height,
                          'Chiều cao',
                          '${record.height.toStringAsFixed(0)} cm',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tính lại'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HistoryScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('Lịch sử'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBmiRangeItem(String range, String label, Color color, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? color : color.withOpacity(0.3),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey400,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
