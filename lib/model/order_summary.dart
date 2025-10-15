import 'package:ykos_kitchen/enum/category_enum.dart';
import 'package:ykos_kitchen/model/food.dart';

class OrderSummary {
  final List<Food> foods; // Alle Gerichte
  final double? discount; // optionaler Rabatt, z. B. 0.10 für 10%
  final double deliveryCharge; // z. B. 2.50

  OrderSummary({required this.foods, this.discount, this.deliveryCharge = 0.0});

  /// 1️⃣ Basispreis: alle Gerichte inkl. Extras ohne Rabatt oder Lieferkosten
  double get basisPreis =>
      foods.fold(0.0, (sum, food) => sum + food.totalWithExtras);

  /// 2️⃣ Rabattbetrag in Euro (0.0 wenn kein Rabatt)
  double get rabattBetrag => (discount ?? 0.0) * basisPreis;

  /// 3️⃣ Preis nach Rabatt, vor Lieferkosten
  double get nettoPreis => basisPreis - rabattBetrag;

  /// 4️⃣ Endsumme inklusive Lieferkosten
  double get endSumme => nettoPreis + deliveryCharge;

  /// 5️⃣ Berechnet 7% MwSt nur auf Speisen (nach Rabatt)
  double get essenMwst {
    final rabattFaktor = 1 - (discount ?? 0.0);
    return foods
        .where(
          (f) =>
              !f.category.name.toLowerCase().contains(
                CategoryEnum.drinks.label,
              ),
        )
        .fold(0.0, (sum, f) => sum + (f.totalWithExtras * rabattFaktor) * 0.07);
  }

  /// 6️⃣ Berechnet 19% MwSt nur auf Getränke (nach Rabatt)
  double get getraenkeMwst {
    final rabattFaktor = 1 - (discount ?? 0.0);
    return foods
        .where((f) => f.category.name.contains(CategoryEnum.drinks.label))
        .fold(0.0, (sum, f) => sum + (f.totalWithExtras * rabattFaktor) * 0.19);
  }

  /// 7️⃣ Gesamtbetrag der MwSt (nur Info)
  double get gesamtMwst => essenMwst + getraenkeMwst;

  /// 8️⃣ Endsumme (MwSt wird **nicht** addiert, nur informativ)
  double get endSummeMitMwSt => endSumme;

  Map<String, dynamic> toJson() {
    return {
      "foods": foods.map((f) => f.toJson()).toList(),
      "discount": discount,
      "deliveryCharge": deliveryCharge,
    };
  }

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      foods:
          (json["foods"] as List<dynamic>?)
              ?.map((item) => Food.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      discount: (json["discount"] as num?)?.toDouble(),
      deliveryCharge: (json["deliveryCharge"] as num?)?.toDouble() ?? 0.0,
    );
  }
}
