import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ykos_kitchen/Error/app_error_handler.dart';
import 'package:ykos_kitchen/Page/new_order_dialog.dart';
import 'package:ykos_kitchen/Service/fire_firestore.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/main.dart';
import 'package:ykos_kitchen/model/order.dart';

class ViewmodelOrders extends ChangeNotifier {
  static var firestore = FireFirestore();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void clearError() {
  _error = null;
  notifyListeners();
}

  late Map<OrderStatusEnum, List<Order>> orderLists;
  StreamSubscription? _ordersSub;

  TimeOfDay? prepareTime;

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
    int nextIndex = currentStatus.statusIndex + 1;

    // 🔹 Prüfen, ob Bestellung Abholung ist und Status 'onWay' überspringen
    if (!order.isDelivery) {
      // 'onWay' ist typischerweise StatusIndex 2 (nach 'inProgress')
      // Wir springen direkt auf 'delivered' (StatusIndex 3)
      if (OrderStatusEnum.values[nextIndex] == OrderStatusEnum.onWay) {
        nextIndex++; // Status überspringen
      }
    }

    if (nextIndex < OrderStatusEnum.values.length) {
      final nextStatus = OrderStatusEnum.values[nextIndex];

      // lokal updaten
      orderLists[currentStatus]?.remove(order);
      final updatedOrder = order.copyWith(orderStatus: nextStatus);
      orderLists[nextStatus]?.add(updatedOrder);
      notifyListeners();

      if (order.selectedDate != null && order.selectedTime != null) {
        // Datum und Zeit der Bestellung kombinieren
        final orderDateTime = DateTime(
          order.selectedDate!.year,
          order.selectedDate!.month,
          order.selectedDate!.day,
          order.selectedTime!.hour,
          order.selectedTime!.minute,
        );

        // +40 Minuten zur gewählten Kundenzeit
        final fastTime = orderDateTime.add(const Duration(minutes: 40));
        prepareTime = TimeOfDay.fromDateTime(fastTime);
      } else {
        // Fallback: wenn keine Zeit angegeben ist, aktuelle Zeit +40 Minuten
        final fastTime = DateTime.now().add(const Duration(minutes: 40));
        prepareTime = TimeOfDay.fromDateTime(fastTime);
      }

      // Firestore update
      await firestore.updateOrder(
        order: order,
        newStatus: nextStatus,
        selectedTime: order.selectedTime,
        fastDeliveryTime: order.fastDeliveryTime,
        selectedDate: order.selectedDate,
      );
    }
  }

  // 👇 Bestellung zurück verschieben
  void moveOrderBackward(Order order) async {
    final currentStatus = order.orderStatus;
    int prevIndex = currentStatus.statusIndex - 1;

    // 🔹 Prüfen, ob Abholbestellung und Status 'onWay' überspringen
    if (!order.isDelivery) {
      if (OrderStatusEnum.values[prevIndex] == OrderStatusEnum.onWay) {
        prevIndex--; // Status überspringen
      }
    }

    if (prevIndex >= 0) {
      final prevStatus = OrderStatusEnum.values[prevIndex];

      // lokal updaten
      orderLists[currentStatus]?.remove(order);
      final updatedOrder = order.copyWith(orderStatus: prevStatus);
      orderLists[prevStatus]?.add(updatedOrder);
      notifyListeners();

      // Firestore update
      await firestore.updateOrder(
        order: order,
        newStatus: prevStatus,
        selectedTime: order.selectedTime,
        fastDeliveryTime: order.fastDeliveryTime,
        selectedDate: order.selectedDate,
      );
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

        // 🔹 Finde neu eingegangene Bestellungen
        final oldRecievedOrders = orderLists[OrderStatusEnum.recieved] ?? [];
        final newRecievedOrders = grouped[OrderStatusEnum.recieved] ?? [];

        // Vergleiche IDs — finde Bestellungen, die vorher nicht da waren
        final newOnes = newRecievedOrders.where((newOrder) {
          return !oldRecievedOrders.any(
            (old) => old.orderId == newOrder.orderId,
          );
        }).toList();

        orderLists = grouped;
        _isLoading = false;
        notifyListeners();

        // 🔹 Öffne Dialog für jede neue Bestellung (nur, wenn noch kein Dialog offen ist)
        for (final order in newOnes) {
          if (ModalRoute.of(navigatorKey.currentContext!)?.isCurrent != true) {
            // Verhindert mehrfachen Dialog während Firestore mehrere Snapshots liefert
            Future.delayed(const Duration(milliseconds: 300), () {
              _showNewOrderDialog(order);
            });
          }
        }
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

  void _showNewOrderDialog(Order order) {
    final context = navigatorKey
        .currentContext; //von der globalen NavigatorKey in der main für den context
    if (context == null || order.confirmedByKitchen == true) return;

    // 🔹 Berechne hier die vorgeschlagene Vorbereitungszeit bevor der Dialog geöffnet wird.
    // Wenn der Kunde eine Vorbestellung mit Datum+Uhrzeit gemacht hat, verwenden wir
    // diese Zeit + 40 Minuten. Ansonsten Fallback auf jetzt + 40 Minuten.
    if (order.selectedDate != null && order.selectedTime != null) {
      final orderDateTime = DateTime(
        order.selectedDate!.year,
        order.selectedDate!.month,
        order.selectedDate!.day,
        order.selectedTime!.hour,
        order.selectedTime!.minute,
      );

      final fastTime = orderDateTime.add(const Duration(minutes: 40));
      prepareTime = TimeOfDay.fromDateTime(fastTime);
    } else {
      final fastTime = DateTime.now().add(const Duration(minutes: 40));
      prepareTime = TimeOfDay.fromDateTime(fastTime);
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NewOrderDialog(
        order: order,
        initialPrepareTime: prepareTime,
        onConfirm: (TimeOfDay newPrepareTime) async {
          Navigator.of(context).pop();

          // 🔹 Zeit speichern
          await firestore.updateOrder(
            order: order,
            newStatus: order.orderStatus,
            selectedTime: newPrepareTime,
            fastDeliveryTime: order.fastDeliveryTime,
            selectedDate: order.selectedDate,
          );
        },
      ),
    );
  }

  Future<void> updateOrder(Order order) async {
    TimeOfDay newPrepareTime =
        order.selectedTime ??
        TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 40)));

    await firestore.updateOrder(
      order: order,
      newStatus: order.orderStatus,
      selectedTime: newPrepareTime,
      fastDeliveryTime: order.fastDeliveryTime,
      selectedDate: order.selectedDate,
    );
  }

  Future<void> removeOrder(Order order) async {
    _error = null;
    notifyListeners();

    try {
      await firestore.removeOrder(order);
      notifyListeners();
    } on Exception catch (e) {
      final message = AppErrorHandler.getMessageFromException(e);
      _error = message;
      notifyListeners();
    }
  }

  Future<void> clearListsFromDB(List<Order>? orderList) async {
      if (orderList == null) return;

      for (var item in orderList) {
        await removeOrder(item);
      }
    }
}
