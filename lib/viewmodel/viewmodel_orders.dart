import 'package:flutter/cupertino.dart';
import 'package:ykos_kitchen/Service/fire_firestore.dart';

class ViewmodelOrders extends ChangeNotifier {
  static var firestore = FireFirestore();

  String? _error;
  String? get error => _error;
}