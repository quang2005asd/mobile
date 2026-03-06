import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/bmi_record.dart';
import 'bmi_edit_screen.dart';

class BmiDetailScreen extends StatelessWidget {
  final BmiRecord record;

  const BmiDetailScreen({super.key, required this.record});

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

  String _getHealthStatus() {
    if (record.bmi < 18.5) {
      return 'Cần tăng cân';
    } else if (record.bmi < 25) {
      return 'Khỏe mạnh';
    } else if (record.bmi < 30) {
      return 'Cần giảm cân nhẹ';
    } else {
      return 'Cần giảm cân';
    }
  }

  double _getIdealMinWeight() {
    return 18.5 * (record.height / 100) * (record.height / 100);
  }

  double _getIdealMaxWeight() {
    return 24.9 * (record.height / 100) * (record.height / 100);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bmiColor = _getBmiColor();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết BMI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BmiEditScreen(record: record),
                ),
              );
            },
            tooltip: 'Chỉnh sửa',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BMI Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bmiColor.withOpacity(0.3),
                    bmiColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: bmiColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Chỉ số BMI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: bmiColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    record.bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: bmiColor,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: bmiColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getBmiCategory(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getHealthStatus(),
                    style: TextStyle(
                      fontSize: 16,
                      color: bmiColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Date & Time
            _buildInfoCard(
              isDark,
              'Thời gian đo',
              [
                _buildInfoRow(
                  Icons.calendar_today,
                  'Ngày',
                  DateFormat('dd/MM/yyyy').format(record.timestamp),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.access_time,
                  'Giờ',
                  DateFormat('HH:mm:ss').format(record.timestamp),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Body Measurements
            _buildInfoCard(
              isDark,
              'Chỉ số cơ thể',
              [
                _buildInfoRow(
                  Icons.monitor_weight,
                  'Cân nặng',
                  '${record.weight.toStringAsFixed(1)} kg',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.height,
                  'Chiều cao',
                  '${record.height.toStringAsFixed(0)} cm',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.wc,
                  'Giới tính',
                  record.gender == 'male' ? 'Nam' : 'Nữ',
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.cake,
                  'Tuổi',
                  '${record.age} tuổi',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Ideal Weight Range
            _buildInfoCard(
              isDark,
              'Cân nặng lý tưởng',
              [
                Text(
                  'Dựa trên chiều cao ${record.height.toStringAsFixed(0)} cm, cân nặng lý tưởng của bạn:',
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Tối thiểu',
                              style: TextStyle(
                                color: AppColors.grey400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_getIdealMinWeight().toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Tối đa',
                              style: TextStyle(
                                color: AppColors.grey400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_getIdealMaxWeight().toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (record.weight < _getIdealMinWeight())
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Bạn cần tăng ${(_getIdealMinWeight() - record.weight).toStringAsFixed(1)} kg để đạt cân nặng lý tưởng',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (record.weight > _getIdealMaxWeight())
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_down, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Bạn cần giảm ${(record.weight - _getIdealMaxWeight()).toStringAsFixed(1)} kg để đạt cân nặng lý tưởng',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cân nặng của bạn đang ở mức lý tưởng!',
                            style: TextStyle(color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Edit Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BmiEditScreen(record: record),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Chỉnh sửa thông tin'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.grey800.withOpacity(0.5)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.grey400,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.grey400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
