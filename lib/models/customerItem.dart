import 'dart:convert';

import 'package:hive/hive.dart';

// class customer{
//   String? Name;
//   String? Category;
//   String? Phone;
//   String? CompanyName;
//   String? Email;
//   String? Location;
//   String? Address;
//
//   customer({
//     this.Name,
//     this.Email,
//     this.Category,
//     this.Location,
//     this.Address,
//     this.CompanyName,
//     this.Phone
// });
//
//   customer.fromJson(Map<String, dynamic> json){
//     json["name"]==null ? Name='':Name = json["name"];
//     json["category"]==null? Category='':Category = json["category"];
//     json["phone"]==null? Phone='':Phone = json["phone"];
//     json["email"]==null? Email='':Email = json["email"];
//     json["location"]==null? Location='':Location= json["location"];
//     json["address"]==null? Address='':Address = json["address"];
//     json["company_name"]==null? CompanyName='':CompanyName = json["company_name"];
//
//   }
//   Map<String, dynamic> toJson(){
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//
//     return data;
//   }
// }

// Hive
@HiveType(typeId: 1)
class CustomerHive extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String phone;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late String account;

  @HiveField(5)
  late String accountCode;

  @HiveField(6)
  late String limit;

  @HiveField(7)
  late String amount;

  @HiveField(8)
  late String taxNumber;

  @HiveField(9)
  late String status;

  @HiveField(10)
  late String type;

  @HiveField(11)
  late String margin;

  @HiveField(12)
  late String note;

  @HiveField(12)
  late String address;

  @HiveField(13)
  late String id;

  @HiveField(14)
  late DateTime? addedAt;

  @HiveField(14)
  late String assignId;

  CustomerHive({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.category = "",
    this.account = "",
    this.accountCode = "",
    this.limit = "",
    this.amount = "",
    this.taxNumber = "",
    this.status = "",
    this.type = "",
    this.margin = "",
    this.note = "",
    this.address = "",
    this.addedAt,
    this.assignId = "",
});

  factory CustomerHive.fromJson(Map<String, dynamic> json) {
    String id = json['id']?.toString() ?? "";

    return CustomerHive(
      id: id,
      name: json['name']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      phone: json['phone']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
      account: json['account']?.toString() ?? "",
      accountCode: json['account_code']?.toString() ?? "",
      limit: json['limit']?.toString() ?? "",
      amount: json['amount']?.toString() ?? "",
      taxNumber: json['tax_number']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      type: json['type']?.toString() ?? "",
      margin: json['margin']?.toString() ?? "",
      note: json['note']?.toString() ?? "",
      address: json['address']?.toString() ?? "",
      assignId: json['assigned_to']?.toString() ?? "",
    );
  }
}