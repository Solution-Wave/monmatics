import 'package:hive/hive.dart';

// class Contact{
//   String? Name;
//   String? phone;
//   String? Email;
//
//   Contact({
//    this.Name,
//    this.Email,
//    this.phone
// });
//
//   Contact.fromJson(Map<String, dynamic> json){
//     Name =  '${json["first_name"]} ${json["last_name"]}';
//     json["mobile"]==null? phone='':phone=  json["mobile"] ;
//     json["email"] ==null? Email='':Email= json["email"]  ;
//
//   }
//   Map<String, dynamic> toJson(){
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.Name;
//     data['mobile']= this.phone;
//     data['email'] = this.Email;
//    return data;
//   }
//
// }

//Hive Class
@HiveType(typeId: 4)
class ContactHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late String fName;

  @HiveField(3)
  late String lName;

  @HiveField(4)
  late String title;

  @HiveField(5)
  late String relatedTo;

  @HiveField(6)
  late String search;

  @HiveField(7)
  late String assignTo;

  @HiveField(8)
  late String phone;

  @HiveField(9)
  late String email;

  @HiveField(10)
  late String officePhone;

  @HiveField(11)
  late String address;

  @HiveField(12)
  late String city;

  @HiveField(13)
  late String state;

  @HiveField(14)
  late String postalCode;

  @HiveField(15)
  late String country;

  @HiveField(16)
  late String description;

  @HiveField(17)
  late DateTime? addedAt;

  @HiveField(18)
  late String assignId;


  // Constructor
  ContactHive({
    this.id = '',
    this.type = '',
    this.fName = '',
    this.lName = '',
    this.title = '',
    this.relatedTo = '',
    this.search = '',
    this.assignTo = '',
    this.phone = '',
    this.email = '',
    this.officePhone = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
    this.description = '',
    this.assignId = '',
    this.addedAt,
  });

  // Factory constructor to deserialize JSON data into a ContactHive object
  factory ContactHive.fromJson(Map<String, dynamic> json) {
    String email = json['email'] ?? '';
    String phone = json['mobile'] ?? '';

    // Check if the contact with the same email or phone already exists
    // bool duplicate = _checkForDuplicate(email, phone);
    // if (duplicate) {
    //   throw Exception('Contact already exists with the same email or phone');
    // }

    return ContactHive(
      id: json['id'] ?? "",
      type: json['type'] ?? '',
      fName: json['first_name'] ?? '',
      lName: json['last_name'] ?? '',
      title: json['title'] ?? '',
      relatedTo: json['related_to_type'] ?? '',
      assignTo: json['assigned_to'] ?? '',
      phone: phone,
      email: email,
      officePhone: json['office_phone'] ?? '',
      country: json['country'] ?? '',
      assignId: json['assigned_to'] ?? "",
    );
  }

// Method to check for duplicate contacts based on email or phone
//   static bool _checkForDuplicate(String email, String phone) {
//     // Open the Hive box to access stored contacts
//     var contactBox = Hive.box('contacts');
//
//     // Iterate through each contact in the box
//     for (var i = 0; i < contactBox.length; i++) {
//       var existingContact = contactBox.getAt(i);
//       if (existingContact != null &&
//           (existingContact.email == email || existingContact.phone == phone)) {
//         return true;
//       }
//     }
//
//     // If no duplicate contact found, return false
//     return false;
//   }
}