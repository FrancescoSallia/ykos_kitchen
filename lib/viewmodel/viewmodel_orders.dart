import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ykos_kitchen/Service/fire_firestore.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/model/adress.dart';
import 'package:ykos_kitchen/model/order_summary.dart';
import 'package:ykos_kitchen/model/payment.dart';
import 'package:ykos_kitchen/model/user.dart';
import 'package:ykos_kitchen/model/food.dart';
import 'package:ykos_kitchen/enum/category_enum.dart';
import 'package:ykos_kitchen/model/adress_symbol.dart';
import 'package:ykos_kitchen/model/category.dart';
import 'package:ykos_kitchen/model/extra.dart';

class ViewmodelOrders extends ChangeNotifier {
  static var firestore = FireFirestore();

  String? _error;
  String? get error => _error;

  late Map<OrderStatusEnum, List<Order>> orderLists;

  ViewmodelOrders() {
    orderLists = {
      //TODO: Replace Dummy list in recieved with real list !
      OrderStatusEnum.recieved: [
        Order(
          pickUpUser: null,
          isDelivery: true,
          deliveryAdress: Adress(
            name: "Mara Herrmann",
            telefon: "0176543524",
            street: "Müllerstraße",
            houseNumber: "12a",
            plz: "13437",
            place: "Berlin",
            icon: AdressSymbol(name: "Home", iconData: Icons.home),
            information: "bitte nicht klingeln ich komme denn runter",
          ),
          selectedTime: TimeOfDay(hour: 17, minute: 45),
          selectedDate: DateTime.now(),
          payment: Payment(
            name: "Apple Pay",
            img: "assets/images/applepay.png",
          ),
          orderSummary: OrderSummary(
            foods: [
              Food(
                id: "f6",
                name: "Pizza Margherita",
                price: 6.90,
                extras: [
                  Extra(
                    name: "Peperoni",
                    price: 1.50,
                    extraCategory: CategoryEnum.pizza,
                  ),
                ],
                artikelNr: '0001',
                description: 'salat mit essif',
                imgAsset: 'lib/img/pizza4.png',
                labels: ["lib/img/peper.png"],
                allergens: ["A", "D"],
                category: Category(
                  name: CategoryEnum.pizza.label,
                  categoryImg: "lib/img/pizza_category_icon.png",
                ),
              ),
            ],
          ),
          orderStatus: OrderStatusEnum.recieved,
        ),

        Order(
          pickUpUser: User(
            name: "Tom",
            lastName: "Riddle",
            telefon: "0165234589",
          ),
          isDelivery: false,
          deliveryAdress: null,
          selectedTime: TimeOfDay(hour: 17, minute: 45),
          selectedDate: DateTime.now(),
          payment: Payment(
            name: "Apple Pay",
            img: "assets/images/applepay.png",
          ),
          orderSummary: OrderSummary(
            foods: [
              Food(
                id: "f6",
                name: "Pizza Margherita",
                price: 6.90,
                extras: [
                  Extra(
                    name: "Peperoni",
                    price: 1.50,
                    extraCategory: CategoryEnum.pizza,
                  ),
                ],
                artikelNr: '0001',
                description: 'salat mit essif',
                imgAsset: 'lib/img/pizza4.png',
                labels: ["lib/img/peper.png"],
                allergens: ["A", "D"],
                category: Category(
                  name: CategoryEnum.pizza.label,
                  categoryImg: "lib/img/pizza_category_icon.png",
                ),
              ),
            ],
          ),
          orderStatus: OrderStatusEnum.recieved,
        ),
      ],
      OrderStatusEnum.inProgress: [],
      OrderStatusEnum.onWay: [],
      OrderStatusEnum.delivered: [],
    };
  }
  // 👇 Bestellung in nächste Phase verschieben
  void moveOrderForward(Order order) {
    final currentStatus = order.orderStatus;
    final nextIndex = currentStatus.statusIndex + 1;

    if (nextIndex < OrderStatusEnum.values.length) {
      final nextStatus = OrderStatusEnum.values[nextIndex];
      orderLists[currentStatus]?.remove(order);
      orderLists[nextStatus]?.add(order.copyWith(orderStatus: nextStatus));
      notifyListeners();
    }
  }

  // 👇 Bestellung zurück verschieben
  void moveOrderBackward(Order order) {
    final currentStatus = order.orderStatus;
    final prevIndex = currentStatus.statusIndex - 1;

    if (prevIndex >= 0) {
      final prevStatus = OrderStatusEnum.values[prevIndex];
      orderLists[currentStatus]?.remove(order);
      orderLists[prevStatus]?.add(order.copyWith(orderStatus: prevStatus));
      notifyListeners();
    }
  }
}
