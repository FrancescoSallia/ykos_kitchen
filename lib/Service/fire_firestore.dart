import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ykos_kitchen/Service/fire_auth.dart';
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
  Stream<List<Order>> ordersStream() {
    return FirebaseFirestore.instance
        .collectionGroup('all_orders') // hört auf alle Bestellungen aller User
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList());
  }
  //Fetch Orders
  // Future<List<Order>> fetchOrders() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collectionGroup(
  //           "all_orders",
  //         ) // Gibt dir direkt die Collection die du brauchst zurück ohne uid's!
  //         .get();
  //     return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  //   } on FirebaseException {
  //     rethrow;
  //   }
  // }

  //Remove Order (optional)
  Future<void> removeOrder(Order item) async {
    try {
      await userRef.collection('orders').doc(item.orderId).delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
