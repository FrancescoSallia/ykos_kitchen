class Payment {
  final String name;
  final String img;

  Payment({required this.name, required this.img});

  Map<String, dynamic> toJson() {
    return {"name": name, "img": img};
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(name: json["name"], img: json["img"]);
  }
}
