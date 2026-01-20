/// Service để đưa ra cảnh báo và gợi ý sức khỏe dựa trên BMI, tuổi và giới tính
class HealthAdvisor {
  /// Lấy cảnh báo sức khỏe dựa trên BMI, tuổi và giới tính
  static String getHealthWarning(double bmi, String category, {int age = 25, String gender = 'male'}) {
    // Điều chỉnh cảnh báo dựa trên tuổi
    String ageContext = '';
    if (age < 18) {
      ageContext = '\n\n📌 Lưu ý: Bạn dưới 18 tuổi - cần tham khảo ý kiến bác sĩ trước khi bắt đầu bất kỳ chương trình nào.';
    } else if (age > 60) {
      ageContext = '\n\n⚠️ Lưu ý: Ở độ tuổi này - hãy tham khảo bác sĩ trước khi thực hiện các thay đổi lớn.';
    }
    
    if (bmi < 16) {
      return '⚠️ CẢNH BÁO NGHIÊM TRỌNG\n'
          'BMI của bạn cực kỳ thấp (BMI: ${bmi.toStringAsFixed(1)}). Đây là tình trạng suy dinh dưỡng nặng. '
          'Vui lòng tìm kiếm sự trợ giúp y tế ngay lập tức!$ageContext';
    } else if (bmi < 18.5) {
      return '⚠️ CẢNH BÁO\n'
          'BMI của bạn cho thấy bạn thiếu cân (BMI: ${bmi.toStringAsFixed(1)}). '
          'Điều này có thể dẫn đến suy yếu miễn dịch và các vấn đề sức khỏe khác.$ageContext';
    } else if (bmi < 25) {
      return '✅ TUYỆT VỜI\n'
          'BMI của bạn ở mức lý tưởng (BMI: ${bmi.toStringAsFixed(1)}). '
          'Hãy duy trì lối sống lành mạnh hiện tại của bạn!';
    } else if (bmi < 30) {
      return '⚠️ CHÚ Ý\n'
          'BMI của bạn cao hơn mức bình thường (BMI: ${bmi.toStringAsFixed(1)}). '
          'Cần phải cơ cấu lại chế độ ăn uống và tăng hoạt động thể chất.$ageContext';
    } else if (bmi < 35) {
      return '⚠️ CẢNH BÁO\n'
          'BMI của bạn cho thấy béo phì loại I (BMI: ${bmi.toStringAsFixed(1)}). '
          'Điều này tăng nguy cơ mắc bệnh tim, tiểu đường và các bệnh mãn tính khác.$ageContext';
    } else {
      return '🚨 CẢNH BÁO NGHIÊM TRỌNG\n'
          'BMI của bạn cho thấy béo phì mức độ II hoặc cao hơn (BMI: ${bmi.toStringAsFixed(1)}). '
          'Cần tham khảo ý kiến bác sĩ ngay để có kế hoạch giảm cân an toàn.$ageContext';
    }
  }

  /// Lấy gợi ý cải thiện sức khỏe theo tuổi và giới tính
  static List<String> getHealthRecommendations(double bmi, String category, {int age = 25, String gender = 'male'}) {
    List<String> recommendations = [];
    
    // Khuyến nghị dựa trên độ tuổi
    String ageAdvisory = '';
    if (age < 18) {
      ageAdvisory = '👶 Tuổi vị thành niên - cần giám sát của cha mẹ/bác sĩ';
    } else if (age > 50) {
      ageAdvisory = '👴 Tuổi 50+ - tập luyện nhẹ, kiểm tra sức khỏe thường xuyên';
    }
    
    // Khuyến nghị giới tính cụ thể
    String genderAdvisory = gender == 'female' 
      ? '👩 Nữ giới - chú ý cung cấp sắt, canxi cho xương khỏe'
      : '👨 Nam giới - tăng cường hoạt động cơ bắp';

    if (bmi < 18.5) {
      recommendations.addAll([
        '🥗 Tăng cung cấp calo: Ăn 3 bữa chính + 2-3 bữa phụ mỗi ngày',
        '🥛 Uống sữa, ăn các thực phẩm giàu protein (trứng, thịt, cá)',
        '💪 Tập luyện cơ bằng tạ để xây dựng khối cơ',
        '😴 Ngủ đủ 7-9 giờ mỗi đêm để cơ thể phục hồi',
        '⚕️ Tham khảo chuyên gia dinh dưỡng để lập kế hoạch ăn uống phù hợp',
        if (ageAdvisory.isNotEmpty) ageAdvisory,
        genderAdvisory,
      ]);
    } else if (bmi < 25) {
      recommendations.addAll([
        '✨ Duy trì lối sống lành mạnh hiện tại',
        '🏃 Tập thể dục 150 phút/tuần hoạt động vừa phải',
        '🥗 Tiếp tục ăn cân bằng: rau, trái cây, protein, ngũ cốc',
        '💧 Uống đủ nước: 2-3 lít mỗi ngày',
        '😴 Ngủ đủ 7-9 giờ mỗi đêm',
        if (ageAdvisory.isNotEmpty) ageAdvisory,
        genderAdvisory,
      ]);
    } else if (bmi < 30) {
      recommendations.addAll([
        '🏃 Tăng hoạt động thể chất: 30 phút/ngày đi bộ hoặc tập thể dục',
        '🥗 Giảm calo nhẹ: Ăn nhiều rau xanh, giảm dầu mỡ',
        '🚫 Hạn chế: nước ngọt, đồ ăn nhanh, thực phẩm chế biến',
        '🍎 Ăn nhẹ vào buổi tối, không ăn sau 7 giờ tối',
        '📊 Cân nặng mỗi tuần một lần để theo dõi tiến độ',
        if (ageAdvisory.isNotEmpty) ageAdvisory,
        genderAdvisory,
      ]);
    } else if (bmi < 35) {
      recommendations.addAll([
        '💪 Bắt đầu chương trình tập luyện 45-60 phút/ngày',
        '🥗 Giảm calo có kế hoạch: Giảm 500-1000 calo/ngày',
        '🚫 Loại bỏ: nước ngọt, bánh kẹo, đồ ăn nhanh',
        '🏥 Tham khảo bác sĩ hoặc chuyên gia dinh dưỡng',
        '📱 Sử dụng ứng dụng để theo dõi lượng calo',
        if (ageAdvisory.isNotEmpty) ageAdvisory,
        genderAdvisory,
      ]);
    } else {
      recommendations.addAll([
        '🏥 NGAY LẬP TỨC: Tham khảo bác sĩ để lập kế hoạch giảm cân an toàn',
        '💪 Bắt đầu với hoạt động nhẹ: Đi bộ 20-30 phút/ngày',
        '🥗 Thay đổi chế độ ăn uống cơ bản: Giảm phần ăn, ăn chậm',
        '🥤 Thay nước ngọt bằng nước lọc hoặc trà không đường',
        '👥 Tìm kiếm sự hỗ trợ: Tham gia nhóm giảm cân hoặc tìm người hướng dẫn',
        if (ageAdvisory.isNotEmpty) ageAdvisory,
        genderAdvisory,
      ]);
    }

    return recommendations;
  }

  /// Lấy gợi ý chế độ ăn uống cụ thể theo tuổi và giới tính
  static String getDietSuggestion(double bmi, {int age = 25, String gender = 'male'}) {
    String genderNote = gender == 'female' ? '(Nữ)' : '(Nam)';
    
    if (bmi < 18.5) {
      return '🍽️ GỢI Ý DINH DƯỠNG $genderNote\n'
          '• Sáng: Cơm trắng, trứng, rau luộc, sữa\n'
          '• Trưa: Cơm, thịt/cá, canh, rau\n'
          '• Chiều: Sữa, bánh mì, pho mát\n'
          '• Tối: Cơm chiều, rau xanh, tofu/thịt\n'
          '• Xen kẽ: Hạt, trái cây, sữa chua';
    } else if (bmi < 25) {
      return '🍽️ GỢI Ý DINH DƯỠNG $genderNote\n'
          '• Sáng: Yến mạch, trái cây, sữa\n'
          '• Trưa: Cơm lứt, cá, rau xanh, canh\n'
          '• Chiều: Trà xanh, hạt\n'
          '• Tối: Cơm, thịt nạc, rau luộc\n'
          '• Xen kẽ: Trái cây tươi, sữa chua';
    } else if (bmi < 30) {
      return '🍽️ GỢI Ý DINH DƯỠNG $genderNote\n'
          '• Sáng: Yến mạch, trứng luộc (1), trái cây\n'
          '• Trưa: Cơm lứt (1 bát), cá hấp, rau luộc\n'
          '• Chiều: Nước lọc, trái cây\n'
          '• Tối: Cơm (½ bát), thịt nạc, rau\n'
          '• Tránh: Dầu mỡ, nước ngọt, bánh kẹo';
    } else {
      return '🍽️ GỢI Ý DINH DƯỠNG $genderNote\n'
          '• Sáng: Yến mạch + trứng (1) + trái cây\n'
          '• Trưa: Cơm lứt (¾ bát), cá, rau nấu canh\n'
          '• Chiều: Nước lọc, 1 trái cây nhỏ\n'
          '• Tối: Cơm (½ bát), thịt nạc, rau xanh nhiều\n'
          '• Tránh hoàn toàn: Dầu, dầu mỡ, nước ngọt, bánh kẹo';
    }
  }
  static Map<String, dynamic> getIdealWeightRange(double heightM) {
    double minIdealWeight = 18.5 * heightM * heightM;
    double maxIdealWeight = 24.9 * heightM * heightM;

    return {
      'min': minIdealWeight.toStringAsFixed(1),
      'max': maxIdealWeight.toStringAsFixed(1),
      'message': 'Cân nặng lý tưởng cho bạn: ${minIdealWeight.toStringAsFixed(1)} - ${maxIdealWeight.toStringAsFixed(1)} kg',
    };
  }
}
