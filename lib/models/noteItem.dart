import 'package:hive/hive.dart';

// class Notes{
// String? Subject;
// String? Description;
// String? RelatedTo;
//
// Notes({
//   this.Subject, this.Description , this.RelatedTo
// });
//
// Notes.fromJson(Map<String, dynamic> json){
//   json["subject"] == null ? Subject = '' : Subject=json["subject"];
//   json["description"] == null ? Description  = ''  : Description = json["description"];
//   json["related_to_type"] == null ? RelatedTo = '': RelatedTo=json["related_to_type"];
//
// }
//
// }

@HiveType(typeId: 0)
class NoteHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late String relatedTo;

  @HiveField(3)
  late String search;

  @HiveField(4)
  late String assignTo;

  @HiveField(5)
  late String description;

  NoteHive({
    this.id = "",
    this.subject = "",
    this.relatedTo = "",
    this.search = "",
    this.assignTo = "",
    this.description = "",
});
  // Factory constructor to deserialize JSON data into a ContactHive object
  factory NoteHive.fromJson(Map<String, dynamic> json) {
    String id = json['id'] ?? '';
    // String phone = json['mobile'] ?? '';

    // Check if the contact with the same email or phone already exists
    // bool duplicate = _checkForDuplicate(email, phone);
    // if (duplicate) {
    //   throw Exception('Contact already exists with the same email or phone');
    // }

    return NoteHive(
      id: id,
      subject: json['subject'] ?? '',
      search: json['related_id'] ?? '',
      relatedTo: json['related_to_type'] ?? '',
      assignTo: json['assigned_to'] ?? '',
      description: json['description'] ?? '',
    );
  }
}