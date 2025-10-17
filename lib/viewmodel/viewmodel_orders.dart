import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ykos_kitchen/Service/fire_firestore.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/model/order.dart';

class ViewmodelOrders extends ChangeNotifier {
  static var firestore = FireFirestore();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  late Map<OrderStatusEnum, List<Order>> orderLists;
  StreamSubscription? _ordersSub;

  ViewmodelOrders() {
    orderLists = {
      OrderStatusEnum.recieved: [
        // Order(
        //   pickUpUser: null,
        //   isDelivery: true,
        //   deliveryAdress: Adress(
        //     name: "Mara Herrmann",
        //     telefon: "0176543524",
        //     street: "Müllerstraße",
        //     houseNumber: "12a",
        //     plz: "13437",
        //     place: "Berlin",
        //     icon: AdressSymbol(name: "Home", iconData: Icons.home),
        //     information: "bitte nicht klingeln ich komme denn runter",
        //   ),
        //   selectedTime: TimeOfDay(hour: 17, minute: 45),
        //   selectedDate: DateTime.now(),
        //   payment: Payment(
        //     name: "Apple Pay",
        //     img: "assets/images/applepay.png",
        //   ),
        //   orderSummary: OrderSummary(
        //     foods: [
        //       Food(
        //         id: "f6",
        //         name: "Pizza Margherita",
        //         price: 6.90,
        //         extras: [
        //           Extra(
        //             name: "Peperoni",
        //             price: 1.50,
        //             extraCategory: CategoryEnum.pizza,
        //           ),
        //         ],
        //         artikelNr: '0001',
        //         description: 'salat mit essif',
        //         imgAsset: 'lib/img/pizza4.png',
        //         labels: ["lib/img/peper.png"],
        //         allergens: ["A", "D"],
        //         category: Category(
        //           name: CategoryEnum.pizza.label,
        //           categoryImg: "lib/img/pizza_category_icon.png",
        //         ),
        //       ),
        //     ],
        //   ),
        //   orderStatus: OrderStatusEnum.recieved,
        // ),

        // Order(
        //   pickUpUser: User(
        //     name: "Tom",
        //     lastName: "Riddle",
        //     telefon: "0165234589",
        //   ),
        //   isDelivery: false,
        //   deliveryAdress: null,
        //   selectedTime: TimeOfDay(hour: 17, minute: 45),
        //   selectedDate: DateTime.now(),
        //   payment: Payment(
        //     name: "Apple Pay",
        //     img: "assets/images/applepay.png",
        //   ),
        //   orderSummary: OrderSummary(
        //     foods: [
        //       Food(
        //         id: "f6",
        //         name: "Pizza Margherita",
        //         price: 6.90,
        //         extras: [
        //           Extra(
        //             name: "Peperoni",
        //             price: 1.50,
        //             extraCategory: CategoryEnum.pizza,
        //           ),
        //         ],
        //         artikelNr: '0001',
        //         description: 'salat mit essif',
        //         imgAsset: 'lib/img/pizza4.png',
        //         labels: ["lib/img/peper.png"],
        //         allergens: ["A", "D"],
        //         category: Category(
        //           name: CategoryEnum.pizza.label,
        //           categoryImg: "lib/img/pizza_category_icon.png",
        //         ),
        //       ),
        //     ],
        //   ),
        //   orderStatus: OrderStatusEnum.recieved,
        // ),
      ],
      OrderStatusEnum.inProgress: [],
      OrderStatusEnum.onWay: [],
      OrderStatusEnum.delivered: [],
    };
    _listenToOrders();
  }
  // 👇 Bestellung in nächste Phase verschieben
  void moveOrderForward(Order order) async {
    final currentStatus = order.orderStatus;
    final nextIndex = currentStatus.statusIndex + 1;

    if (nextIndex < OrderStatusEnum.values.length) {
      final nextStatus = OrderStatusEnum.values[nextIndex];

      // lokal updaten
      orderLists[currentStatus]?.remove(order);
      final updatedOrder = order.copyWith(orderStatus: nextStatus);
      orderLists[nextStatus]?.add(updatedOrder);
      notifyListeners();

      // Firestore update
      await firestore.updateOrderStatus(
        order,
        nextStatus,
        TimeOfDay.now(),
      ); //TODO: die zeit muss in eine variable sein damit man sie flexible ändern kann
    }
  }

  // 👇 Bestellung zurück verschieben
  void moveOrderBackward(Order order) async {
    final currentStatus = order.orderStatus;
    final prevIndex = currentStatus.statusIndex - 1;

    if (prevIndex >= 0) {
      final prevStatus = OrderStatusEnum.values[prevIndex];

      // lokal updaten
      orderLists[currentStatus]?.remove(order);
      final updatedOrder = order.copyWith(orderStatus: prevStatus);
      orderLists[prevStatus]?.add(updatedOrder);
      notifyListeners();

      // Firestore update
      await firestore.updateOrderStatus(
        order,
        prevStatus,
        TimeOfDay.now(),
      ); //TODO: die zeit muss in eine variable sein damit man sie flexible ändern kann
    }
  }

  void _listenToOrders() {
    _isLoading = true;
    notifyListeners();

    _ordersSub = firestore.fetchOrdersStream().listen(
      (orders) {
        // Bestellungen nach Status gruppieren
        final Map<OrderStatusEnum, List<Order>> grouped = {
          OrderStatusEnum.recieved: [],
          OrderStatusEnum.inProgress: [],
          OrderStatusEnum.onWay: [],
          OrderStatusEnum.delivered: [],
        };

        for (final order in orders) {
          grouped[order.orderStatus]?.add(order);
        }

        orderLists = grouped;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _ordersSub?.cancel();
    super.dispose();
  }
}
