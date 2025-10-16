

// Die IDs der Food-Objekte sind fest gesetzt, damit Favoriten korrekt funktionieren.

import 'package:ykos_kitchen/enum/category_enum.dart';
import 'package:ykos_kitchen/model/category.dart';
import 'package:ykos_kitchen/model/extra.dart';
import 'package:ykos_kitchen/model/food.dart';

class FoodRepository {
  // ✅ 1. Privater Konstruktor – verhindert, dass jemand versehentlich eine neue Instanz erstellt
  FoodRepository._privateConstructor();

  // ✅ 2. Statische Singleton-Instanz
  static final instance = FoodRepository._privateConstructor();

  List<Food> getFoodsOrDrinks() {
    final List<Food> list = [
      Food(
        id: "1",
        name: "Chicken Drumstick's",
        description:
            "Juicy, tender, and perfectly seasoned with a shattering crunch.",

        imgAsset: "lib/img/chicken_drumsticks.png",
        price: 12.90,
        artikelNr: null,
        labels: [],
        allergens: ["A", "F"],
        category: Category(
          name: CategoryEnum.chicken.label,
          categoryImg: "lib/img/chicken_category_icon.png",
        ),
        extras: [],
      ),
      // 1. Gegrillte Spieße
      Food(
        id: "2",
        name: "Flame-Grilled Skewers",
        description:
            "Tender cubes of chicken breast, marinated in garlic-lime and flame-kissed.",
        category: Category(
          name: CategoryEnum.chicken.label,
          categoryImg: "lib/img/chicken_category_icon.png",
        ),
        imgAsset: "lib/img/food2.png",
        price: 13.50,
        artikelNr: null,
        labels: [],
        allergens: ["2", "1", "P"],
        extras: [],
      ),
      // 2. Scharf-Süße Flügel
      Food(
        id: "3",
        name: "Sweet Chili Wings",
        description:
            "Crisp wings coated in a sticky, sweet-spicy chili glaze. Perfect for sharing.",
        category: Category(
          name: CategoryEnum.chicken.label,
          categoryImg: "lib/img/chicken_category_icon.png",
        ),
        imgAsset: "lib/img/food1.png",
        artikelNr: null,
        price: 9.90,
        labels: [],
        allergens: ["G", "S"],
        extras: [],
      ),
      Food(
        id: "4",
        name: "Pizza Angela",
        description:
            "with tomatosauce, Mozzarella, spicy Salami, Mushroom's and Onion's.",
        category: Category(
          name: CategoryEnum.pizza.label,
          categoryImg: "lib/img/pizza_category_icon.png",
        ),
        imgAsset: "lib/img/pizza_angela1.png",
        artikelNr: null,
        price: 12.50,
        labels: [],
        allergens: ["2", "1", "P"],
        extras: [],
      ),
      Food(
        id: "5",
        name: "Pizza Tonno",
        description: "with tomatosauce, Mozzarella, Tuna and Onion's.",
        category: Category(
          name: CategoryEnum.pizza.label,
          categoryImg: "lib/img/pizza_category_icon.png",
        ),
        imgAsset: "lib/img/pizza_tonno1.png",
        artikelNr: null,
        price: 14.90,
        labels: ["lib/img/peper.png", "lib/img/peper.png"],
        allergens: ["A", "F"],
        extras: [],
      ),
      Food(
        id: "6",
        name: "Pizza Gattopardo",
        description:
            "with tomatosauce, Mozzarella, spicy Salami and Stracciatella.",
        category: Category(
          name: CategoryEnum.pizza.label,
          categoryImg: "lib/img/pizza_category_icon.png",
        ),
        imgAsset: "lib/img/pizza4.png",
        artikelNr: null,
        price: 16.90,
        labels: [],
        allergens: ["A", "F"],
        extras: [],
      ),
      Food(
        id: "7",
        name: "Pizza della Nonna",
        description:
            "with tomatosauce, Mozzarella, black Olive's, caper's, anchovies and artichokes .",
        category: Category(
          name: CategoryEnum.pizza.label,
          categoryImg: "lib/img/pizza_category_icon.png",
        ),
        imgAsset: "lib/img/pizza_nonna.png",
        artikelNr: null,
        price: 15.90,
        labels: [],
        allergens: ["2", "LM", "P"],
        extras: [],
      ),

      Food(
        id: "8",
        name: "Rindersteak mit Kräuterbutter",
        description: "Grilled beef steak served with herb butter and fries.",
        category: Category(
          name: CategoryEnum.main.label,
          categoryImg: "lib/img/category1.png",
        ),
        imgAsset: "lib/img/meat2.png",
        artikelNr: null,
        price: 26.50,
        labels: [],
        allergens: ["G"],
        extras: [],
      ),
      Food(
        id: "9",
        name: "Hähnchenbrustfilet mit Gemüse",
        description:
            "Grilled chicken breast with seasonal vegetables and rice.",
        category: Category(
          name: CategoryEnum.main.label,
          categoryImg: "lib/img/category1.png",
        ),
        imgAsset: "lib/img/meat1.png",
        artikelNr: null,
        price: 18.90,
        labels: [],
        allergens: ["A"],
        extras: [],
      ),

      // Pasta Gerichte
      Food(
        id: "10",
        name: "Spaghetti Carbonara",
        description:
            "Classic Italian pasta with creamy sauce, bacon and Parmesan.",
        category: Category(
          name: CategoryEnum.pasta.label,
          categoryImg: "lib/img/pasta_category_icon.png",
        ),
        imgAsset: "lib/img/pasta1.png",
        artikelNr: null,
        price: 13.90,
        labels: [],
        allergens: ["A", "C", "G"],
        extras: [],
      ),
      Food(
        id: "11",
        name: "Penne Arrabbiata",
        description: "Spicy tomato sauce with garlic, chili and olive oil.",
        category: Category(
          name: CategoryEnum.pasta.label,
          categoryImg: "lib/img/pasta_category_icon.png",
        ),
        imgAsset: "lib/img/pasta2.png",
        artikelNr: null,
        price: 12.50,
        labels: [],
        allergens: ["A"],
        extras: [],
      ),

      Food(
        id: "12",
        name: "Cocktail Sunrise",
        description: "Cocktail Sunrise with Orange slice and ice cubes",
        category: Category(
          name: CategoryEnum.drinks.label,
          categoryImg: "lib/img/category3.png",
        ),
        imgAsset: "lib/img/cocktail1.png",
        artikelNr: null,
        price: 15.90,
        labels: [],
        allergens: ["2", "LM", "P"],
        extras: [],
      ),
      Food(
        id: "13",
        name: "Cocktail Orange Rum",
        description:
            "Cocktail Orange Rum with Orange slice and ice cubes and Orange juice",
        category: Category(
          name: CategoryEnum.drinks.label,
          categoryImg: "lib/img/category3.png",
        ),
        imgAsset: "lib/img/cocktail2.png",
        artikelNr: null,
        price: 15.90,
        labels: [],
        allergens: ["2", "LM", "P"],
        extras: [],
      ),
    ];

    return list;
  }

  // Funktion: Liefert eine Liste von Extras
  List<Extra> getExtras() {
    return [
      // Pizza Extras
      Extra(
        name: "Extra Käse",
        price: 1.5,
        extraCategory: CategoryEnum.main,
        anzahl: 0,
      ),
      Extra(
        name: "Salami",
        price: 2.0,
        extraCategory: CategoryEnum.pizza,
        anzahl: 0,
      ),
      Extra(
        name: "Schinken",
        price: 2.0,
        extraCategory: CategoryEnum.pizza,
        anzahl: 0,
      ),
      Extra(
        name: "Pilze",
        price: 1.0,
        extraCategory: CategoryEnum.starters,
        anzahl: 0,
      ),

      // Salat Extras
      Extra(
        name: "Oliven",
        price: 0.8,
        extraCategory: CategoryEnum.main,
        anzahl: 0,
      ),
      Extra(
        name: "Tomaten",
        price: 0.7,
        extraCategory: CategoryEnum.recommend,
        anzahl: 0,
      ),
      Extra(name: "Gurken", price: 0.5, extraCategory: CategoryEnum.drinks),

      // Nudeln Extras
      Extra(
        name: "Parmesan",
        price: 1.0,
        extraCategory: CategoryEnum.drinks,
        anzahl: 0,
      ),
      Extra(name: "Basilikum", price: 0.5, extraCategory: CategoryEnum.pasta),
      Extra(name: "Knoblauch", price: 0.3, extraCategory: CategoryEnum.pasta),
    ];
  }
}
