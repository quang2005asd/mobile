import 'package:flutter/material.dart';
import '../models/bmi_record.dart';
import '../models/user_profile.dart';
import '../services/bmi_calculator.dart';
import '../services/bmi_storage_service.dart';
import '../services/user_profile_service.dart';
import 'diet_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String gender = 'male';
  double height = 170;
  double weight = 70;
  int age = 25;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await UserProfileService.getOrCreateProfile();
      setState(() {
        userProfile = profile;
        age = profile.age;
      });
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  void _calculateBMI() {
    final heightM = height / 100;
    final bmi = BmiCalculator.calculateBmi(weight, heightM);
    final category = BmiCalculator.getBmiCategory(bmi);

    _saveBMI(bmi, category);
    
    // Navigate to diet plan screen with age and gender
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DietPlanScreen(
          bmi: bmi,
          category: category,
          weight: weight,
          height: height,
          age: age,
          gender: gender,
        ),
      ),
    );
  }

  Future<void> _saveBMI(double bmi, String category) async {
    final record = BmiRecord(
      weight: weight,
      height: height,
      bmi: bmi,
      category: category,
      weightUnit: 'kg',
      heightUnit: 'cm',
      timestamp: DateTime.now(),
    );
    await BmiStorageService.saveBmiRecord(record);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting section
            if (userProfile != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0A84FF),
                      const Color(0xFF0A84FF).withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0A84FF).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào ${userProfile!.name}!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tuổi: ${userProfile!.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hãy tính toán và giám sát chỉ số BMI của bạn để duy trì sức khỏe tốt nhất',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            Text(
              'BMI Calculator',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildGenderSelector(),
            const SizedBox(height: 28),
            _buildHeightCard(),
            const SizedBox(height: 24),
            _buildWeightCard(),
            const SizedBox(height: 24),
            _buildAgeCard(),
            const SizedBox(height: 32),
            _buildCalculateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildGenderButton('Nam', 'male'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGenderButton('Nữ', 'female'),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = gender == value;
    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected 
              ? const Color(0xFF0A84FF)
              : Colors.grey.shade200,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                value == 'male' ? Icons.male : Icons.female,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            '${height.toStringAsFixed(0)} cm',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A84FF),
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: height,
            min: 100,
            max: 250,
            divisions: 150,
            activeColor: const Color(0xFF0A84FF),
            inactiveColor: Colors.grey.shade300,
            onChanged: (value) => setState(() => height = value),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('100 cm', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text('250 cm', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            '${weight.toStringAsFixed(1)} kg',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A84FF),
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: weight,
            min: 20,
            max: 200,
            divisions: 180,
            activeColor: const Color(0xFF0A84FF),
            inactiveColor: Colors.grey.shade300,
            onChanged: (value) => setState(() => weight = value),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20 kg', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text('200 kg', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            '$age tuổi',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A84FF),
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: age.toDouble(),
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: const Color(0xFF0A84FF),
            inactiveColor: Colors.grey.shade300,
            onChanged: (value) => setState(() => age = value.toInt()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text('100', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: const Color(0xFF0A84FF),
          padding: EdgeInsets.zero,
        ),
        onPressed: _calculateBMI,
        child: const Text(
          'TÍNH BMI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
