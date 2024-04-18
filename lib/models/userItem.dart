import 'package:hive/hive.dart';

@HiveType(typeId: 6)
  class UsersHive extends HiveObject {

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String fName;

  @HiveField(2)
  late String lName;

  @HiveField(3)
  late String email;

  @HiveField(4)
  late String role;

  UsersHive({
    this.id = "",
    this.fName = "",
    this.lName = "",
    this.email = "",
    this.role = "",
});

  factory UsersHive.fromJson(Map<String, dynamic> json){
    String id = json['id'].toString() ?? "";
    return UsersHive(
      id: id,
      fName: json['firstName'],
      lName: json['lastName'],
      email: json['email'],
      role: json['role'],
    );
  }
}

