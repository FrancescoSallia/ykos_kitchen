import 'package:flutter/material.dart';

class AdressSymbol {
  final String name;
  final IconData iconData;

  AdressSymbol({required this.name, required this.iconData});

Map<String, dynamic> json() {
  return {
    "name": name,
    "codePoint": iconData.codePoint,
    "fontFamily": iconData.fontFamily,
    "fontPackage": iconData.fontPackage,
  };
}
factory AdressSymbol.fromJson(Map<String, dynamic> json) {
  return AdressSymbol(
    name: json["name"],
    iconData: IconData(
      json["codePoint"],
      fontFamily: json["fontFamily"],
      fontPackage: json["fontPackage"],
    ),
  );
}
}
