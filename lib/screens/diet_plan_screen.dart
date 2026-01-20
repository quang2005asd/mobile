import 'package:flutter/material.dart';
import '../services/ai_diet_service.dart';
import '../services/health_advisor.dart';

class DietPlanScreen extends StatefulWidget {
  final double bmi;
  final String category;
  final double weight;
  final double height;
  final int age;
  final String gender;

  const DietPlanScreen({
    super.key,
    required this.bmi,
    required this.category,
    required this.weight,
    required this.height,
    this.age = 25,
    this.gender = 'male',
  });

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  late Map<String, dynamic> dietPlan;
  int selectedMealIndex = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDietPlan();
  }

  Future<void> _loadDietPlan() async {
    try {
      // Simulate loading 2s
      await Future.delayed(const Duration(seconds: 2));
      
      final plan = AIDietService.getDietPlan(widget.bmi, widget.category);
      
      if (mounted) {
        setState(() {
          dietPlan = plan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Lỗi: ${e.toString()}';
        });
      }
    }
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'Thiếu cân':
        return const Color(0xFF3B82F6);
      case 'Bình thường':
        return const Color(0xFF10B981);
      case 'Thừa cân':
        return const Color(0xFFF59E0B);
      case 'Béo phì':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Chế độ ăn AI'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang tạo chế độ ăn cho bạn...'),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Chế độ ăn AI'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error ?? 'Có lỗi xảy ra'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadDietPlan();
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final recommendedFoods = dietPlan['recommendedFoods'] as List<dynamic>? ?? [];
    final avoidFoods = dietPlan['avoidFoods'] as List<dynamic>? ?? [];
    final meals = dietPlan['meals'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Chế độ ăn AI'),
      ),
      body: meals.isEmpty
          ? const Center(child: Text('Không có dữ liệu chế độ ăn'))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health Warning Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _getWarningColor().withOpacity(0.1),
                  border: Border.all(
                    color: _getWarningColor().withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HealthAdvisor.getHealthWarning(
                        widget.bmi,
                        widget.category,
                        age: widget.age,
                        gender: widget.gender,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recommendations section
              Text(
                'Khuyến nghị cho bạn',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: HealthAdvisor.getHealthRecommendations(
                    widget.bmi,
                    widget.category,
                    age: widget.age,
                    gender: widget.gender,
                  )
                      .map(
                        (rec) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  rec,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Mục tiêu
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor().withOpacity(0.2),
                      _getCategoryColor().withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(color: _getCategoryColor().withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dietPlan['goal'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '📊 Calo: ${dietPlan['calories']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🎯 ${dietPlan['focus']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Menu hàng ngày
              Text(
                'Menu hàng ngày',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Tab các bữa ăn
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    meals.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedMealIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedMealIndex == index
                                ? _getCategoryColor()
                                : Colors.grey.shade200,
                          ),
                          child: Text(
                            meals[index]['name'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: selectedMealIndex == index
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chi tiết bữa ăn
              if (selectedMealIndex < meals.length)
                _buildMealDetail(meals[selectedMealIndex]),
              const SizedBox(height: 28),

              // Thực phẩm nên ăn
              Text(
                'Thực phẩm nên ăn ✅',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recommendedFoods
                    .map(
                      (food) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green.shade50,
                          border: Border.all(
                            color: Colors.green.shade200,
                          ),
                        ),
                        child: Text(
                          food.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Thực phẩm cần tránh
              Text(
                'Thực phẩm cần tránh ❌',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: avoidFoods
                    .map(
                      (food) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red.shade50,
                          border: Border.all(
                            color: Colors.red.shade200,
                          ),
                        ),
                        child: Text(
                          food.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Lời khuyên
              Text(
                'Lời khuyên 💡',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (dietPlan['tips'] as List<dynamic>? ?? [])
                      .map(
                        (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            tip.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealDetail(Map<String, dynamic> meal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '🕐 ${meal['time']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _getCategoryColor().withOpacity(0.2),
                ),
                child: Text(
                  '${meal['calories']} kcal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getCategoryColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Thực phẩm:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (meal['foods'] as List<dynamic>? ?? [])
                .map(
                  (food) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getCategoryColor(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            food.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Color _getWarningColor() {
    if (widget.bmi < 18.5) {
      return Colors.orange;
    } else if (widget.bmi < 25) {
      return Colors.green;
    } else if (widget.bmi < 30) {
      return Colors.amber;
    } else if (widget.bmi < 35) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
