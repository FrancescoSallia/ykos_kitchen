import 'package:flutter/cupertino.dart';
import 'package:ykos_kitchen/Service/fire_firestore.dart';
import 'package:ykos_kitchen/model/adress.dart';

class ViewmodelOrders extends ChangeNotifier {
  static var firestore = FireFirestore();

  List<Adress> _adressList = [];
  List<Adress> get adressList => _adressList;

  Future<List<Adress>> fetchAdressList() async {
    _error = null;
    notifyListeners();
    // final list = _adressList;
    try {
      final list = await firestore.fetchAdress();
      _adressList = list;
      notifyListeners();
      return list;
    } on Exception catch (e) {
      _error = e.toString();
      print(e.toString());
      notifyListeners();
      return [];
    } finally {
      _error = null;
      notifyListeners();
    }
  }

  String? _error;
  String? get error => _error;

  Future<void> addToAdressList(Adress adress) async {
    _error = null;
    try {
      firestore.addAdress(adress);
      _adressList.add(adress);
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString();
      print(e.toString());
    } finally {
      _error = null;
      notifyListeners();
    }
  }

  Future<void> removeFromAdressList(Adress adress) async {
    _error = null;
    notifyListeners();
    try {
      await firestore.removeFromAdress(adress);
      final adressIndex = _adressList.indexWhere(
        (element) => element.id == adress.id,
      );
      final list = _adressList;
      list.removeAt(adressIndex);
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString();
      print(e.toString());
      notifyListeners();
    } finally {
      _error = null;
      notifyListeners();
    }
  }

  Future<void> updateAdress(Adress updatedAdress) async {
    //In Firebase abspeichern
    try {
      await firestore.updateAdress(updatedAdress);

      final index = _adressList.indexWhere(
        (adress) => adress.id == updatedAdress.id,
      );

      if (index != -1) {
        // Update an derselben Position
        _adressList[index] = updatedAdress;
        notifyListeners();
      } else {
        print("Adresse nicht gefunden!");
      }
    } on Exception catch (e) {
      _error = e.toString();
      print(e.toString());
      notifyListeners();
    } finally {
      _error = null;
      notifyListeners();
    }
  }
}
