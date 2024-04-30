import 'package:hive/hive.dart';

// class Tasks {
//   String? Subject;
//   String? StDate;
//   String? DueDate;
//   String? Status;
//   String? Priority;
//   String? Description;
//
//   Tasks({
//     this.Subject,
//     this.StDate,
//     this.Priority,
//     this.Description,
//     this.DueDate,
//     this.Status,
//   });
//
//   Tasks.fromJson(Map obj) {
//     // print('json in item class: $json');
//     Subject = obj["subject"] ?? '';
//     StDate = obj["start_date"] ?? '';
//     DueDate = obj["due_date"] ?? '';
//     Status = obj["status"] ?? '';
//     Priority = obj["priority"] ?? '';
//     Description = obj["description"] ?? '';
//   }
// }


// Hive
@HiveType(typeId: 2)
class TaskHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late String status;

  @HiveField(3)
  late String type;

  @HiveField(4)
  late String contact;

  @HiveField(5)
  late String startDate;

  @HiveField(6)
  late String dueDate;

  @HiveField(7)
  late String priority;

  @HiveField(8)
  late String assignTo;

  @HiveField(9)
  late String description;

  @HiveField(10)
  late String relatedId;

  @HiveField(11)
  late String assignId;

  @HiveField(12)
  late String companyId;

  @HiveField(13)
  late String relatedTo;

  @HiveField(14)
  late DateTime? addedAt;

  TaskHive({
    this.id = "",
    this.subject = "",
    this.status = "",
    this.type = "",
    this.contact = "",
    this.startDate = "",
    this.dueDate = "",
    this.priority = "",
    this.assignTo = "",
    this.description = "",
    this.relatedId = "",
    this.assignId = "",
    this.companyId = "",
    this.relatedTo = "",
    this.addedAt,
  });

  // Factory constructor to deserialize JSON data into a ContactHive object
  factory TaskHive.fromJson(Map<String, dynamic> json) {
    String id = json['id'] ?? '';

    return TaskHive(
      id: id,
      subject: json['subject'] ?? '',
      status: json['status'] ?? "",
      startDate: json['start_date'] ?? "",
      dueDate: json['due_date'] ?? "",
      type: json['related_to_type'] ?? "",
      contact: json['contact_id'] ?? "",
      priority: json['priority'] ?? "",
      description: json['description'] ?? '',
      relatedId: json['related_id'] ?? "",
      assignId: json['assigned_to'] ?? "",
      companyId: json['companyId'] ?? "",
    );
  }
}