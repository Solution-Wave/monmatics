import 'package:hive/hive.dart';

// class Lead {
//   String? Name;
//   String? Category;
//   String? Note;
//   String? PhoneNo;
//   String? Email;
//   String? Address;
//   String? location;
//
//   Lead(
//       {this.Name,
//       this.Category,
//       this.Address,
//       this.Email,
//       this.location,
//       this.Note,
//       this.PhoneNo});
//
//   Lead.fromJson(Map<String, dynamic> json) {
//     String temp = json["name"];
//     int? ind;
//     for (int i = 0; i < temp.length; i++) {
//       if (temp[i] == '(') ind = i;
//     }
//     // temp.substring(0,ind)
//     json["name"] == null ? Name = '' : Name = temp.substring(0, ind);
//
//     json["category"] == null ? Category = '' : Category = json["category"];
//
//     json["address"] == null ? Address = '' : Address = json["address"];
//     json["email"] == null ? Email = '' : Email = json["email"];
//     json["location"] == null ? location = '' : location = json["location"];
//     json["note"] == null ? Note = '' : Note = json["note"];
//     json["phone"] == null ? PhoneNo = '' : PhoneNo = json["phone"];
//   }
// }


// Hive
@HiveType(typeId : 3)
class LeadHive extends HiveObject{
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String phone;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late String leadSource;

  @HiveField(6)
  late String status;

  @HiveField(7)
  late String type;

  @HiveField(8)
  late String note;

  @HiveField(9)
  late String address;

  LeadHive({
    this.id  = "",
    this.name  = "",
    this.email  = "",
    this.phone  = "",
    this.category  = "",
    this.leadSource  = "",
    this.status  = "",
    this.type  = "",
    this.note  = "",
    this.address  = "",
});

  factory LeadHive.fromJson(Map<String, dynamic> json){
    String id = json['id'] ?? "";

    return LeadHive(
      id: id,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      category: json['category'] ?? "",
      leadSource: json['lead_source'] ?? "",
      status: json['status'] ?? "",
      type: json['type'] ?? "",
      note: json['note'] ?? "",
      address: json['address'] ?? "",
    );
  }

}
