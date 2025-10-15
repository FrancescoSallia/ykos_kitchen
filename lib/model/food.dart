import 'package:uuid/uuid.dart';
import 'package:ykos_kitchen/model/category.dart';
import 'package:ykos_kitchen/model/extra.dart';

class Food {
  final String id;
  final String? artikelNr;
  final String name;
  final String description;
  final Category category;
  final String? imgAsset;
  final double price;
  String? note;
  int count;
  bool isFavorited;
  final List<String>? labels;
  final List<String> allergens;
  List<Extra>? extras;

  Food({
    String? id, // optional, wenn beim Update übergeben werden sollte
    required this.artikelNr,
    required this.name,
    required this.description,
    required this.category,
    required this.imgAsset,
    required this.price,
    this.count = 1,
    this.isFavorited = false,
    this.note = "",
    required this.labels,
    required this.allergens,
    List<Extra>? extras,
  }) : id =
           id ??
           const Uuid()
               .v4(), //ID wird nur einmal erstellt zufällig und ist nichtmehr wieder änderbar ,  erzeugt neue ID, wenn keine übergeben wurde
       extras = extras ?? [];

  // ✅ Firestore toJson funktion (zum Speichern)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artikelNr': artikelNr,
      'name': name,
      'description': description,
      'category': category.name, // Category muss in String konvertiert werden
      'imgAsset': imgAsset,
      'price': price,
      'note': note,
      'count': count,
      'isFavorited': isFavorited,
      'labels': labels,
      'allergens': allergens,
      'extras': extras?.map((e) => e.toJson()).toList(),
    };
  }

  // ✅ Firestore fromJson funktion (zum Laden)
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      artikelNr: json['artikelNr'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category:
          (json['category'] is Map)
              ? Category.fromJson(Map<String, dynamic>.from(json['category']))
              : Category(
                name: json['category']?.toString() ?? 'Unbekannt',
                categoryImg: '',
              ),
      imgAsset: json['imgAsset'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] ?? '',
      count: json['count'] ?? 1,
      isFavorited: json['isFavorited'] ?? false,
      labels: (json['labels'] != null) ? List<String>.from(json['labels']) : [],
      allergens:
          (json['allergens'] != null)
              ? List<String>.from(json['allergens'])
              : [],
      extras:
          (json['extras'] != null)
              ? (json['extras'] as List)
                  .map((e) => Extra.fromJson(Map<String, dynamic>.from(e)))
                  .toList()
              : [],
    );
  }
}

extension FoodPriceExtension on Food {
  double get extrasTotal {
    if (extras == null || extras!.isEmpty) return 0.0;
    return extras!.fold(0.0, (sum, extra) => sum + extra.price * extra.anzahl);
  }

  double get totalWithExtras => (price + extrasTotal) * count;
}
