class User {
  final String name;
  final String lastName;
  final String telefon;

  User({required this.name, required this.lastName, required this.telefon});

  Map<String, dynamic> toJson() {
    return {"name": name, "lastName": lastName, "telefon": telefon};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      lastName: json["lastName"],
      telefon: json["telefon"],
    );
  }
}
