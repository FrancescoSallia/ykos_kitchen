import 'package:uuid/uuid.dart';
import 'package:ykos_kitchen/model/adress_symbol.dart';

class Adress {
  final String id;
  final String name;
  final String street;
  final String houseNumber;
  final String plz;
  final String place;
  final AdressSymbol? icon;
  final String? information;
  final String telefon;

  Adress({
    String? id, // optionaler Parameter
    required this.name,
    required this.telefon,
    required this.street,
    required this.houseNumber,
    required this.plz,
    required this.place,
    required this.icon,
    required this.information,
  }) : id =
           id ??
           const Uuid()
               .v4(); // ✅ wenn kein id übergeben wird, automatisch generieren

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "street": street,
      "houseNumber": houseNumber,
      "plz": plz,
      "place": place,
      "icon": icon?.json(),
      "information": information,
      "telefon": telefon,
    };
  }

  factory Adress.fromJson(Map<String, dynamic> json) {
    return Adress(
      id: json["id"],
      name: json["name"],
      telefon: json["telefon"],
      street: json["street"],
      houseNumber: json["houseNumber"],
      plz: json["plz"],
      place: json["place"],
      icon: json["icon"] != null ? AdressSymbol.fromJson(json["icon"]) : null,
      information: json["information"],
    );
  }
}
