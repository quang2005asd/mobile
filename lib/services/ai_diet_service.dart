class AIDietService {
  /// Gợi ý chế độ ăn dựa trên BMI
  static Map<String, dynamic> getDietPlan(double bmi, String category) {
    if (category == 'Thiếu cân') {
      return {
        'goal': 'TĂNG CÂN - Tăng cường dinh dưỡng',
        'calories': '+300-500 calo/ngày',
        'focus': 'Tăng protein, carbs, healthy fats',
        'meals': [
          {
            'name': 'Bữa sáng',
            'time': '7:00 - 8:00',
            'foods': [
              '2 bánh mì nguyên cốc + bơ lạc',
              '2 quả trứng chiên',
              'Sữa tươi 200ml',
              'Chuối hoặc cam',
            ],
            'calories': '500-600',
          },
          {
            'name': 'Bữa phụ 1',
            'time': '10:00 - 10:30',
            'foods': [
              'Hạt điều hoặc hạnh nhân (50g)',
              'Sữa chua Hy Lạp',
              'Mật ong',
            ],
            'calories': '250-300',
          },
          {
            'name': 'Bữa trưa',
            'time': '12:00 - 13:00',
            'foods': [
              'Thịt đỏ/Cá: 150-200g',
              'Cơm trắng: 2 tô',
              'Rau xanh luộc',
              'Dầu ôm',
            ],
            'calories': '700-800',
          },
          {
            'name': 'Bữa phụ 2',
            'time': '15:00 - 15:30',
            'foods': [
              'Sinh tố bơ + sữa',
              'Bánh quy bơ',
            ],
            'calories': '300-400',
          },
          {
            'name': 'Bữa tối',
            'time': '18:00 - 19:00',
            'foods': [
              'Gà/Cá: 150g',
              'Khoai tây nướng',
              'Xà lách',
              'Dầu olive',
            ],
            'calories': '600-700',
          },
        ],
        'tips': [
          '✓ Ăn 5-6 bữa nhỏ mỗi ngày',
          '✓ Uống sữa, nước trái cây tự nhiên',
          '✓ Tập thể dục nhẹ + ăn nhiều',
          '✓ Ưu tiên thực phẩm giàu năng lượng',
          '✓ Bổ sung vitamin & khoáng chất',
        ],
      };
    } else if (category == 'Bình thường') {
      return {
        'goal': 'GIỮ GÌN SỨC KHỎE - Duy trì cân nặng lý tưởng',
        'calories': 'Bình thường',
        'focus': 'Cân bằng protein, carbs, fats',
        'meals': [
          {
            'name': 'Bữa sáng',
            'time': '7:00 - 8:00',
            'foods': [
              '1-2 bánh mì nguyên cốc',
              '1-2 quả trứng',
              'Rau xanh',
              'Trái cây tươi',
            ],
            'calories': '400-500',
          },
          {
            'name': 'Bữa phụ 1',
            'time': '10:00 - 10:30',
            'foods': [
              'Quả táo hoặc chuối',
              'Sữa chua không đường',
            ],
            'calories': '150-200',
          },
          {
            'name': 'Bữa trưa',
            'time': '12:00 - 13:00',
            'foods': [
              'Thịt gà/Cá: 120-150g',
              'Cơm lứt hoặc mì lúa mạch',
              'Rau xanh',
              'Dầu ôm vừa phải',
            ],
            'calories': '600-700',
          },
          {
            'name': 'Bữa phụ 2',
            'time': '15:00 - 15:30',
            'foods': [
              'Hạt hạnh nhân (30g)',
              'Nước trái cây tự nhiên',
            ],
            'calories': '150-200',
          },
          {
            'name': 'Bữa tối',
            'time': '18:00 - 19:00',
            'foods': [
              'Cá/Tôm: 120-150g',
              'Rau quả đa dạng',
              'Cơm lứt',
              'Súp rau',
            ],
            'calories': '500-600',
          },
        ],
        'tips': [
          '✓ Ăn 3 bữa chính + 2 bữa phụ',
          '✓ Đạo đức ăn uống hợp lý',
          '✓ Uống 2-3L nước mỗi ngày',
          '✓ Tập thể dục 30 phút/ngày',
          '✓ Hạn chế đường & muối',
        ],
      };
    } else if (category == 'Thừa cân') {
      return {
        'goal': 'GIẢM CÂN - Giảm 0.5-1kg/tuần',
        'calories': '-300-500 calo/ngày',
        'focus': 'Giảm carbs, tăng protein & rau xanh',
        'meals': [
          {
            'name': 'Bữa sáng',
            'time': '7:00 - 8:00',
            'foods': [
              '1 bánh mì nguyên cốc',
              '2 quả trứng',
              'Rau xanh',
              'Cà phê hoặc trà (không đường)',
            ],
            'calories': '300-350',
          },
          {
            'name': 'Bữa phụ',
            'time': '10:00 - 10:30',
            'foods': [
              'Táo hoặc cam',
              'Nước lọc',
            ],
            'calories': '80-100',
          },
          {
            'name': 'Bữa trưa',
            'time': '12:00 - 13:00',
            'foods': [
              'Thịt gà nướng/Cá: 150g',
              'Rau xanh nấu canh',
              'Cơm lứt: 1 tô nhỏ',
              'Không dầu',
            ],
            'calories': '400-450',
          },
          {
            'name': 'Bữa phụ 2',
            'time': '15:00 - 15:30',
            'foods': [
              'Sữa chua không đường',
              'Hạt',
            ],
            'calories': '100-150',
          },
          {
            'name': 'Bữa tối',
            'time': '18:00 - 19:00',
            'foods': [
              'Cá trắng hoặc tôm: 120g',
              'Salad rau xanh',
              'Canh rau',
              'Không cơm',
            ],
            'calories': '250-300',
          },
        ],
        'tips': [
          '✓ Giảm cân chậm, bền vững',
          '✓ Ăn nhiều rau, ít tinh bột',
          '✓ Tập thể dục 45-60 phút/ngày',
          '✓ Uống 3L nước/ngày',
          '✓ Tránh đồ ăn nhanh, đồ ngọt',
        ],
      };
    } else {
      // Béo phì
      return {
        'goal': 'GIẢM CÂN NHANH - Giảm 1-1.5kg/tuần',
        'calories': '-500-700 calo/ngày',
        'focus': 'Low carb, High protein, Rau xanh',
        'meals': [
          {
            'name': 'Bữa sáng',
            'time': '7:00 - 8:00',
            'foods': [
              '3 quả trứng (chỉ lấy lòng trắng)',
              'Rau xanh',
              'Cà phê đen không đường',
            ],
            'calories': '200-250',
          },
          {
            'name': 'Bữa phụ',
            'time': '10:00 - 10:30',
            'foods': [
              'Nước lọc',
              'Trái cây ít đường (dâu, lựu)',
            ],
            'calories': '50-80',
          },
          {
            'name': 'Bữa trưa',
            'time': '12:00 - 13:00',
            'foods': [
              'Thịt gà/Cá nướng: 150g',
              'Salad rau xanh',
              'Canh rau nấu nước',
              'Không dầu, không cơm',
            ],
            'calories': '300-350',
          },
          {
            'name': 'Bữa phụ 2',
            'time': '15:00 - 15:30',
            'foods': [
              'Nước lọc hoặc trà xanh',
            ],
            'calories': '0-50',
          },
          {
            'name': 'Bữa tối',
            'time': '18:00 - 19:00',
            'foods': [
              'Cá trắng/Tôm: 100-120g',
              'Rau xanh nấu canh',
              'Không tinh bột',
            ],
            'calories': '200-250',
          },
        ],
        'tips': [
          '✓ Tham khảo bác sĩ trước',
          '✓ Tập thể dục 60+ phút/ngày',
          '✓ Uống 3-4L nước/ngày',
          '✓ Ăn ít muối & đường',
          '✓ Kiên trì dài hạn',
        ],
      };
    }
  }
  static List<String> getRecommendedFoods(String category) {
    if (category == 'Thiếu cân') {
      return [
        'Cá béo: Cá hồi, cá ngừ',
        'Thịt đỏ: Thịt bò, thịt dê',
        'Trứng & Sữa & Pho mát',
        'Hạt & Hạn chế: Bơ lạc, óc chó',
        'Tinh bột: Gạo, bánh mì, khoai',
        'Dầu: Dầu ôm, dầu cọ',
        'Trái cây: Chuối, xoài, dâu',
        'Sữa & Sữa chua',
      ];
    } else if (category == 'Bình thường') {
      return [
        'Cá trắng & Cá béo',
        'Thịt gà không da',
        'Trứng',
        'Rau xanh: Cải, rau muống',
        'Trái cây: Táo, cam, dâu',
        'Ngũ cốc nguyên hạt',
        'Sữa chua không đường',
        'Hạt (vừa phải)',
      ];
    } else if (category == 'Thừa cân') {
      return [
        'Cá trắng: Cá tuyết, cá basa',
        'Thịt gà nướng (không da)',
        'Trứng lòng trắng',
        'Rau xanh đa dạng',
        'Canh rau',
        'Trái cây ít đường',
        'Sữa chua Hy Lạp',
        'Cơm lứt (ít)',
      ];
    } else {
      return [
        'Cá trắng (không dầu)',
        'Tôm, cua (ít béo)',
        'Thịt gà luộc (chỉ lấy lòng ngực)',
        'Rau xanh: Rau muống, cải xoăn, xà lách',
        'Canh rau không dầu',
        'Trái cây ít đường: Dâu, lựu',
        'Nước lọc',
        'Trứng lòng trắng',
      ];
    }
  }

  /// Danh sách thực phẩm cần tránh
  static List<String> getFoodsToAvoid(String category) {
    if (category == 'Thiếu cân') {
      return [
        '⚠️ Đồ ăn nhanh (calo xấu)',
        '⚠️ Đồ ăn kém dinh dưỡng',
        '⚠️ Nước ngọt (uống sữa thay)',
      ];
    } else if (category == 'Bình thường') {
      return [
        '⚠️ Đồ ăn nhanh',
        '⚠️ Nước ngọt & đồ uống có đường',
        '⚠️ Kẹo & bánh ngọt',
        '⚠️ Thực phẩm chiên xào',
        '⚠️ Mỳ ăn liền',
      ];
    } else if (category == 'Thừa cân') {
      return [
        '⚠️ Đồ ăn nhanh',
        '⚠️ Nước ngọt & nước có đường',
        '⚠️ Bánh kẹo',
        '⚠️ Đồ ăn chiên',
        '⚠️ Thịt mỡ',
        '⚠️ Mỳ ăn liền',
        '⚠️ Bánh mì trắng',
      ];
    } else {
      return [
        '⚠️ Tất cả đồ ăn nhanh',
        '⚠️ Nước có đường/soda/bia',
        '⚠️ Bánh kẹo ngọt',
        '⚠️ Đồ chiên xào',
        '⚠️ Thịt có mỡ',
        '⚠️ Kem & sữa',
        '⚠️ Bánh mì & tinh bột',
        '⚠️ Dầu & mỡ động vật',
      ];
    }
  }
}
