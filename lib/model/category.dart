
class Category {
  final String name;
  final String categoryImg;

  Category({required this.name, required this.categoryImg});

  // ✅ toJson (zum Speichern in Firestore)
  Map<String, dynamic> toJson() {
    return {'name': name, 'categoryImg': categoryImg};
  }

  // ✅ fromJson (zum Lesen aus Firestore)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
      categoryImg: json['categoryImg'] ?? '',
    );
  }
}
