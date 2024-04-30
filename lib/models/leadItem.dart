import 'package:hive/hive.dart';

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

  @HiveField(10)
  late DateTime? addedAt;

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
    this.addedAt,
});

  factory LeadHive.fromJson(Map<String, dynamic> json){
    return LeadHive(
      id: json['id'] ?? "",
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
