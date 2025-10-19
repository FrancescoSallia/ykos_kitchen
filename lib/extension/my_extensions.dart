extension PriceFormatting on double {
  String toEuroString() {
    // Prüfen, ob es eine ganze Zahl ist (also kein Nachkommawert)
    if (this % 1 == 0) {
      return "${toInt()} €";
    } else {
      return "${toStringAsFixed(2).replaceAll('.', ',')} €";
    }
  }
}
