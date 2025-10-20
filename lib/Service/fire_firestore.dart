import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ykos_kitchen/Service/fire_auth.dart';
import 'package:ykos_kitchen/enum/order_status_enum.dart';
import 'package:ykos_kitchen/model/order.dart';

class FireFirestore {
  static var firestore = FirebaseFirestore.instance;
  final auth = FireAuth.auth;

  /// Gibt immer die aktuelle Referenz für den eingeloggten Nutzer zurück.
  DocumentReference<Map<String, dynamic>> get userRef {
    final user = auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: "no-current-user",
        message: "Kein Benutzer ist derzeit eingeloggt.",
      );
    }
    return firestore.collection("ykos_kitchen").doc(user.uid);
  }

  //Order

  // Stream für alle Bestellungen global
  Stream<List<Order>> fetchOrdersStream() {
    return FirebaseFirestore.instance
        .collectionGroup('all_orders')
        // .orderBy("currentDate")
        .snapshots() // hört auf alle Bestellungen aller User
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList(),
        );
  }

  Future<void> updateOrder({
    required Order order,
    required OrderStatusEnum newStatus,
    required TimeOfDay? selectedTime,
    required TimeOfDay? fastDeliveryTime,
    required DateTime? selectedDate,
  }) async {
    try {
      final updatedOrder = order.copyWith(
        orderStatus: newStatus,
        fastDeliveryTime:
            fastDeliveryTime, // optional: aktuelles Änderungsdatum
        confirmedByKitchen: true,
        selectedTime: selectedTime,
        selectedDate: selectedDate,
      );

      // 1️⃣ Update in der User-spezifischen Sammlung
      await firestore
          .collection("ykos_bbq_chicken")
          .doc(order.userId)
          .collection("orders")
          .doc(order.orderId)
          .update(updatedOrder.toJson());

      // 2️⃣ Update in der globalen Sammlung
      await firestore
          .collection("ykos_kitchen")
          .doc("global_orders") // ⚡ fix: nicht userId verwenden!
          // .doc(order.userId)
          .collection("all_orders")
          .doc(order.orderId)
          .update(updatedOrder.toJson());
    } catch (e) {
      debugPrint("🔥 Fehler beim Aktualisieren der Bestellung: $e");
      rethrow;
    }
  }

  //Remove Order (optional)
  Future<void> removeOrder(Order item) async {
    try {
      await firestore
          .collection("ykos_kitchen")
          .doc("global_orders")
          // .doc(order.userId)
          .collection("all_orders")
          .doc(item.orderId)
          .delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
