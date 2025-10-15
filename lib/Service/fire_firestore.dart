import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ykos_kitchen/Service/fire_auth.dart';
import 'package:ykos_kitchen/model/adress.dart';
import 'package:ykos_kitchen/model/food.dart';
import 'package:ykos_kitchen/model/order.dart';

class FireFirestore {
  static var firestore = FirebaseFirestore.instance;
  final auth = FireAuth.auth;

  /// Gibt immer die aktuelle Referenz für den eingeloggten Nutzer zurück.
  DocumentReference<Map<String, dynamic>> get userRef {
    final user = auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Kein Benutzer ist derzeit eingeloggt.',
      );
    }
    return firestore.collection("ykos_bbq_chicken").doc(user.uid);
  }

  //FAVORITES
  Future<void> addFavorite(Food item) async {
    try {
      await userRef.collection('favorites').doc(item.id).set(item.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> removeFromFavorite(Food item) async {
    try {
      await userRef.collection('favorites').doc(item.id).delete();
    } on FirebaseException {
      rethrow;
    }
  }

  Future<List<Food>> fetchFavorites() async {
    try {
      final snapshot = await userRef.collection("favorites").get();
      return snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList();
    } on FirebaseException {
      rethrow;
    }
  }

  //ADRESS

  //Add Adress
  Future<void> addAdress(Adress item) async {
    try {
      await userRef.collection('adress').doc(item.id).set(item.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  //Remove Adress
  Future<void> removeFromAdress(Adress item) async {
    try {
      await userRef.collection('adress').doc(item.id).delete();
    } on FirebaseException {
      rethrow;
    }
  }

  //Fetch Adress
  Future<List<Adress>> fetchAdress() async {
    try {
      final snapshot = await userRef.collection("adress").get();
      return snapshot.docs.map((doc) => Adress.fromJson(doc.data())).toList();
    } on FirebaseException {
      rethrow;
    }
  }

  //Update Adress
  Future<void> updateAdress(Adress updatedItem) async {
    try {
      await userRef
          .collection('adress')
          .doc(updatedItem.id)
          .update(updatedItem.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  //Order

  //Add Order
  Future<void> addOrder(Order item) async {
    try {
      await userRef.collection('orders').doc(item.orderId).set(item.toJson());
    } on FirebaseException {
      rethrow;
    }
  }

  //Fetch Orders
  Future<List<Order>> fetchOrders() async {
    try {
      final snapshot = await userRef.collection('orders').get();
      return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
    } on FirebaseException {
      rethrow;
    }
  }

  //Remove Order (optional)
  Future<void> removeOrder(Order item) async {
    try {
      await userRef.collection('orders').doc(item.orderId).delete();
    } on FirebaseException {
      rethrow;
    }
  }
}
