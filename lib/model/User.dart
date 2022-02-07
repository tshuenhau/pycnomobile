class User {
  String username;
  String email;
  int status;
  String name;
  String surname;
  String locale;
  String? profilePic;
  String? phoneNumber;
  DateTime loggedAt;
  DateTime updatedAt;
  String? farmName;
  String? farmType;
  String? farmAddr;

  User(
      {required this.username,
      required this.email,
      required this.status,
      required this.name,
      required this.surname,
      required this.locale,
      required this.profilePic,
      required this.phoneNumber,
      required this.loggedAt,
      required this.updatedAt,
      required this.farmName,
      required this.farmType,
      required this.farmAddr});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json["email"],
        status: json["status"],
        username: json["username"],
        name: json["name"],
        surname: json["surname"],
        locale: json["locale"],
        profilePic: json["profilePic"],
        phoneNumber: json["phoneNumber"],
        loggedAt: DateTime.parse(json["loggedAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        farmName: json["farmName"],
        farmType: json["farmType"],
        farmAddr: json["farmAddress"]);
  }

  @override
  String toString() {
    return "email: $email, status: $status, username: $username, name: $name, surname: $name, locale: $locale, profilePic: $profilePic, phoneNumber: $phoneNumber, loggedAt: $loggedAt, updatedAt: $updatedAt, farmName: $farmName, farmType: $farmType, farmAddress: $farmAddr";
  }
}
