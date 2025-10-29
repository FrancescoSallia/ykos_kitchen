import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/model/category.dart';
import 'package:ykos_kitchen/model/food.dart';
import 'package:ykos_kitchen/model/order.dart';
import 'package:ykos_kitchen/model/payment.dart';
import 'package:ykos_kitchen/model/order_summary.dart';
import 'package:ykos_kitchen/model/adress.dart';

void main() {
  group('🔥 Firestore Order Tests', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test('should write and read an order successfully', () async {
      // Arrange – Beispielwerte erstellen
      final order = getDummyOrder;
      // Act – Order in Fake Firestore schreiben
      await firestore
          .collection('users')
          .doc(order.userId)
          .collection('all_orders')
          .doc(order.orderId)
          .set(order.toJson());

      // Lesen (wie deine App es tun würde)
      final snapshot = await firestore
          .collection('users')
          .doc(order.userId)
          .collection('all_orders')
          .get();

      final loadedOrders = snapshot.docs
          .map((doc) => Order.fromJson(doc.data()))
          .toList();

      // Assert – Sicherstellen, dass Daten gleich sind
      expect(loadedOrders.length, 1);
      expect(loadedOrders.first.userId, order.userId);
      expect(loadedOrders.first.payment.name, order.payment.name);
      expect(loadedOrders.first.orderSummary.foods.length, 1);
      expect(loadedOrders.first.deliveryAdress?.place, 'Berlin');
    });

    test("update order status", () async {
      final order = getDummyOrder;

      final docRef = firestore
          .collection('users')
          .doc(order.userId)
          .collection('all_orders')
          .doc(order.orderId);

      await docRef.set(order.toJson());

      await docRef.update({
        "orderStatus": OrderStatusEnum.inProgress.name,
        "confirmedByKitchen": true,
      });

      final updatedSnapshot = await docRef.get();
      final updatedOrder = Order.fromJson(updatedSnapshot.data()!);

//Prüfen ob die werte aktuallisiert wurden
      expect(updatedOrder.confirmedByKitchen, true);
      expect(updatedOrder.orderStatus.name, OrderStatusEnum.inProgress.name);

//Prüfen ob die anderen werte gleich geblieben sind
      expect(updatedOrder.userId, "123");
      expect(updatedOrder.deliveryAdress?.place, "Berlin");
      
    });
  });
}

Order get getDummyOrder {
  return Order(
    userId: '123',
    pickUpUser: null,
    isDelivery: true,
    deliveryAdress: Adress(
      street: 'Main Street 123',
      name: 'Max Mustermann',
      telefon: '0304198726',
      houseNumber: '12a',
      plz: '13236',
      place: 'Berlin',
      icon: null,
      information: '2 floor, left side',
    ),
    fastDeliveryTime: const TimeOfDay(hour: 12, minute: 30),
    selectedTime: const TimeOfDay(hour: 13, minute: 0),
    selectedDate: DateTime(2025, 10, 29),
    payment: Payment(name: 'Cash', img: 'someImgPath'),
    orderSummary: OrderSummary(
      foods: [
        Food(
          artikelNr: "1",
          name: "Pizza Margherita",
          description: "tomate sauce, mozzarella and basilikum",
          category: Category(name: "Pizza", categoryImg: "someImgPath"),
          imgAsset: "imgPath",
          price: 12.90,
          labels: [],
          allergens: [],
        ),
      ],
    ),
    orderStatus: OrderStatusEnum.recieved,
    confirmedByKitchen: false,
  );
}
