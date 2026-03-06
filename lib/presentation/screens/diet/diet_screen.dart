import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/bmi_provider.dart';
import '../../../providers/auth_provider.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  @override
  void initState() {
    super.initState();
    _loadLatestRecord();
  }

  Future<void> _loadLatestRecord() async {
    final authProvider = context.read<AuthProvider>();
    final bmiProvider = context.read<BmiProvider>();
    
    if (authProvider.currentUser != null) {
      await bmiProvider.loadBmiRecords(authProvider.currentUser!.id!);
    }
  }

  String _getDietAdviceTitle(double? bmi) {
    if (bmi == null) return 'Chế độ ăn uống lành mạnh';
    if (bmi < 18.5) return 'Chế độ ăn tăng cân';
    if (bmi < 25) return 'Chế độ ăn duy trì';
    if (bmi < 30) return 'Chế độ ăn giảm cân nhẹ';
    return 'Chế độ ăn giảm cân';
  }

  List<Map<String, dynamic>> _getDietPlan(double? bmi) {
    if (bmi == null || (bmi >= 18.5 && bmi < 25)) {
      // Chế độ ăn duy trì
      return [
        {
          'meal': 'Bữa sáng',
          'icon': Icons.wb_sunny_outlined,
          'time': '7:00 - 8:00',
          'foods': [
            '2 lát bánh mì nguyên cám',
            '1 quả trứng luộc',
            '1 cốc sữa tươi không đường',
            'Trái cây theo mùa',
          ],
          'calories': '400-500 kcal',
          'color': Colors.orange,
        },
        {
          'meal': 'Bữa phụ sáng',
          'icon': Icons.coffee_outlined,
          'time': '10:00',
          'foods': [
            '1 hộp sữa chua không đường',
            'Một nắm hạt hỗn hợp',
          ],
          'calories': '150-200 kcal',
          'color': Colors.amber,
        },
        {
          'meal': 'Bữa trưa',
          'icon': Icons.restaurant_outlined,
          'time': '12:00 - 13:00',
          'foods': [
            'Cơm gạo lứt (1 chén)',
            'Thịt/cá nướng hoặc luộc',
            'Rau xanh luộc',
            'Canh rau',
          ],
          'calories': '600-700 kcal',
          'color': AppColors.success,
        },
        {
          'meal': 'Bữa phụ chiều',
          'icon': Icons.cookie_outlined,
          'time': '16:00',
          'foods': [
            'Trái cây tươi',
            'Nước ép không đường',
          ],
          'calories': '100-150 kcal',
          'color': Colors.green,
        },
        {
          'meal': 'Bữa tối',
          'icon': Icons.dinner_dining_outlined,
          'time': '18:00 - 19:00',
          'foods': [
            'Cơm gạo lứt (1/2 chén)',
            'Thịt gà/cá hấp',
            'Rau củ luộc',
            'Súp',
          ],
          'calories': '500-600 kcal',
          'color': Colors.deepPurple,
        },
      ];
    } else if (bmi < 18.5) {
      // Chế độ ăn tăng cân
      return [
        {
          'meal': 'Bữa sáng',
          'icon': Icons.wb_sunny_outlined,
          'time': '7:00 - 8:00',
          'foods': [
            '3 lát bánh mì bơ',
            '2 quả trứng',
            '1 cốc sữa tươi có đường',
            'Chuối hoặc bơ',
          ],
          'calories': '600-700 kcal',
          'color': Colors.orange,
        },
        {
          'meal': 'Bữa phụ sáng',
          'icon': Icons.coffee_outlined,
          'time': '10:00',
          'foods': [
            'Bánh quy bơ',
            'Sữa chua có đường',
            'Hạt dinh dưỡng',
          ],
          'calories': '300-400 kcal',
          'color': Colors.amber,
        },
        {
          'meal': 'Bữa trưa',
          'icon': Icons.restaurant_outlined,
          'time': '12:00 - 13:00',
          'foods': [
            'Cơm trắng (1.5 chén)',
            'Thịt/cá chiên/kho',
            'Rau xào dầu ô liu',
            'Canh có thịt',
          ],
          'calories': '800-900 kcal',
          'color': AppColors.success,
        },
        {
          'meal': 'Bữa phụ chiều',
          'icon': Icons.cookie_outlined,
          'time': '16:00',
          'foods': [
            'Bánh ngọt',
            'Nước ép trái cây',
            'Sữa tươi',
          ],
          'calories': '300-400 kcal',
          'color': Colors.green,
        },
        {
          'meal': 'Bữa tối',
          'icon': Icons.dinner_dining_outlined,
          'time': '18:00 - 19:00',
          'foods': [
            'Cơm trắng (1 chén)',
            'Thịt/cá/tôm',
            'Rau củ xào',
            'Súp đậu hũ',
          ],
          'calories': '700-800 kcal',
          'color': Colors.deepPurple,
        },
      ];
    } else {
      // Chế độ ăn giảm cân
      return [
        {
          'meal': 'Bữa sáng',
          'icon': Icons.wb_sunny_outlined,
          'time': '7:00 - 8:00',
          'foods': [
            '1 lát bánh mì nguyên cám',
            '1 quả trứng luộc',
            'Rau xanh',
            'Trà xanh không đường',
          ],
          'calories': '300-350 kcal',
          'color': Colors.orange,
        },
        {
          'meal': 'Bữa phụ sáng',
          'icon': Icons.coffee_outlined,
          'time': '10:00',
          'foods': [
            '1 quả táo',
            'Nước lọc',
          ],
          'calories': '80-100 kcal',
          'color': Colors.amber,
        },
        {
          'meal': 'Bữa trưa',
          'icon': Icons.restaurant_outlined,
          'time': '12:00 - 13:00',
          'foods': [
            'Cơm gạo lứt (1/2 chén)',
            'Thịt gà luộc hoặc cá hấp',
            'Nhiều rau xanh',
            'Canh rau không dầu',
          ],
          'calories': '400-450 kcal',
          'color': AppColors.success,
        },
        {
          'meal': 'Bữa phụ chiều',
          'icon': Icons.cookie_outlined,
          'time': '16:00',
          'foods': [
            'Sữa chua không đường',
            'Dưa chuột',
          ],
          'calories': '80-100 kcal',
          'color': Colors.green,
        },
        {
          'meal': 'Bữa tối',
          'icon': Icons.dinner_dining_outlined,
          'time': '18:00 - 19:00',
          'foods': [
            'Salad rau xanh',
            'Thịt gà/cá luộc',
            'Nước súp rau',
          ],
          'calories': '350-400 kcal',
          'color': Colors.deepPurple,
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chế độ ăn uống'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Lưu ý'),
                  content: const Text(
                    'Đây chỉ là gợi ý chung về chế độ ăn uống. '
                    'Bạn nên tham khảo ý kiến bác sĩ hoặc chuyên gia dinh dưỡng '
                    'để có kế hoạch phù hợp với tình trạng sức khỏe của mình.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đã hiểu'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<BmiProvider>(
        builder: (context, bmiProvider, child) {
          final latestRecord = bmiProvider.bmiRecords.isNotEmpty
              ? bmiProvider.bmiRecords.first
              : null;
          final bmi = latestRecord?.bmi;
          final dietPlan = _getDietPlan(bmi);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getDietAdviceTitle(bmi),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (bmi != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Dựa trên BMI ${bmi.toStringAsFixed(1)} của bạn',
                          style: TextStyle(
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              bmi == null || (bmi >= 18.5 && bmi < 25)
                                  ? 'Tổng: ~1,750-2,150 kcal/ngày'
                                  : bmi < 18.5
                                      ? 'Tổng: ~2,700-3,200 kcal/ngày'
                                      : 'Tổng: ~1,210-1,400 kcal/ngày',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Meal Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dietPlan.length,
                  itemBuilder: (context, index) {
                    final meal = dietPlan[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: (meal['color'] as Color).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: (meal['color'] as Color).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    meal['icon'] as IconData,
                                    color: meal['color'] as Color,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal['meal'] as String,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: AppColors.grey400,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            meal['time'] as String,
                                            style: TextStyle(
                                              color: AppColors.grey400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (meal['color'] as Color).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    meal['calories'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: meal['color'] as Color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.grey800.withOpacity(0.3)
                                    : AppColors.grey100.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (meal['foods'] as List<String>)
                                    .map((food) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: meal['color'] as Color,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  food,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
