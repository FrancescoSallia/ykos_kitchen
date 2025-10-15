enum OrderStatusEnum { recieved, inProgress, onWay, delivered, ready }

extension OrderLabelText on OrderStatusEnum {
  String get labelText {
    switch (this) {
      case OrderStatusEnum.recieved:
        return "Bestellung ist eingegangen";
      case OrderStatusEnum.inProgress:
        return "Wird Zubereitet";
      case OrderStatusEnum.onWay:
        return "Unterwegs zu dir";
      case OrderStatusEnum.delivered:
        return "Geliefert";
      case OrderStatusEnum.ready:
        return "Abholbereit";
    }
  }

  int get statusIndex {
    switch (this) {
      case OrderStatusEnum.recieved:
        return 0;
      case OrderStatusEnum.inProgress:
        return 1;
      case OrderStatusEnum.onWay:
        return 2;
      case OrderStatusEnum.delivered:
        return 3;
      case OrderStatusEnum.ready:
        return 4;
    }
  }

  String get lottieAnimation {
    switch (this) {
      case OrderStatusEnum.recieved:
        return "assets/animations/entry_order.json";
      case OrderStatusEnum.inProgress:
        return "assets/animations/prepare_food.json";
      case OrderStatusEnum.onWay:
        return "assets/animations/delivery_riding.json";
      case OrderStatusEnum.delivered:
        return "assets/animations/delivered.json";
      case OrderStatusEnum.ready:
        return "assets/animations/delivered.json";
    }
  }
}
