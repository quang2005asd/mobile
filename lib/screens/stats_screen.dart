import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../services/bmi_storage_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? Colors.teal.shade900 : Colors.teal.shade50,
            isDark ? Colors.blue.shade900 : Colors.cyan.shade50,
          ],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildStatsCards(context),
              const SizedBox(height: 32),
              _buildBmiGuidelines(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thống Kê',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Xem thống kê BMI và hướng dẫn',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return FutureBuilder<List<double?>>(
      future: Future.wait([
        BmiStorageService.getAverageBmi(),
        BmiStorageService.getMaxBmi(),
        BmiStorageService.getMinBmi(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final avg = snapshot.data?[0];
        final max = snapshot.data?[1];
        final min = snapshot.data?[2];

        return Column(
          children: [
            _buildStatCard(
              context,
              'BMI Trung Bình',
              avg?.toStringAsFixed(1) ?? 'N/A',
              Icons.trending_up,
              Colors.blue,
              0,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              'BMI Cao Nhất',
              max?.toStringAsFixed(1) ?? 'N/A',
              Icons.arrow_upward,
              Colors.red,
              1,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              'BMI Thấp Nhất',
              min?.toStringAsFixed(1) ?? 'N/A',
              Icons.arrow_downward,
              Colors.green,
              2,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    int delay,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay * 0.15, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                ),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiGuidelines(BuildContext context) {
    final guidelines = [
      {
        'range': 'Dưới 18.5',
        'category': 'Thiếu cân',
        'color': AppColors.primary,
        'icon': Icons.trending_down,
      },
      {
        'range': '18.5 - 24.9',
        'category': 'Bình thường',
        'color': AppColors.success,
        'icon': Icons.check_circle,
      },
      {
        'range': '25.0 - 29.9',
        'category': 'Thừa cân',
        'color': AppColors.warning,
        'icon': Icons.warning,
      },
      {
        'range': '30.0 - 34.9',
        'category': 'Béo phì Độ I',
        'color': AppColors.danger,
        'icon': Icons.health_and_safety,
      },
      {
        'range': '35.0 - 39.9',
        'category': 'Béo phì Độ II',
        'color': Colors.red.shade700,
        'icon': Icons.error,
      },
      {
        'range': 'Từ 40.0',
        'category': 'Béo phì Độ III',
        'color': Colors.red.shade900,
        'icon': Icons.health_and_safety,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hướng Dẫn BMI',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: guidelines.length,
          itemBuilder: (context, index) {
            final guide = guidelines[index];
            return _buildGuidelineItem(
              context,
              guide['range'] as String,
              guide['category'] as String,
              guide['color'] as Color,
              guide['icon'] as IconData,
              index,
            );
          },
        ),
      ],
    );
  }

  Widget _buildGuidelineItem(
    BuildContext context,
    String range,
    String category,
    Color color,
    IconData icon,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              0.3 + (index * 0.08),
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            ),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'BMI: $range',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
