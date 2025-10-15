enum CategoryEnum<String> {
  recommend,
  starters,
  chicken,
  menu,
  main,
  drinks,
  pizza,
  pasta,
  salat,
}

extension CategoryName on CategoryEnum {
  String get label {
    switch (this) {
      case CategoryEnum.recommend:
        return "Recommand";
      case CategoryEnum.menu:
        return "Menu";
      case CategoryEnum.starters:
        return "Starter's";
      case CategoryEnum.drinks:
        return "Drink's";
      case CategoryEnum.main:
        return "Main";
      case CategoryEnum.pizza:
        return "Pizza";
      case CategoryEnum.pasta:
        return "Pasta";
      case CategoryEnum.salat:
        return "Salat";
      case CategoryEnum.chicken:
        return "Chicken";
    }
  }
}
