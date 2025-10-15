
import 'package:ykos_kitchen/enum/category_enum.dart';

class Extra {
  final String name;
  final double price;
  final CategoryEnum extraCategory;
  int anzahl;

  Extra({
    required this.name,
    required this.price,
    required this.extraCategory,
    this.anzahl = 0,
  });


  // ✅ toJson (zum Speichern)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'extraCategory': extraCategory.name, // Enum -> String
      'anzahl': anzahl,
    };
  }

  // ✅ fromJson (zum Lesen)
  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      extraCategory: CategoryEnum.values.firstWhere(
        (e) => e.name == json['extraCategory'],
        orElse: () => CategoryEnum.values.first, // fallback
      ),
      anzahl: json['anzahl'] ?? 0,
    );
  }
}
