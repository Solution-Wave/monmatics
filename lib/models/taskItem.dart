import 'package:hive/hive.dart';

class Tasks {
  String? Subject;
  String? StDate;
  String? DueDate;
  String? Status;
  String? Priority;
  String? Description;

  Tasks({
    this.Subject,
    this.StDate,
    this.Priority,
    this.Description,
    this.DueDate,
    this.Status,
  });

  Tasks.fromJson(Map obj) {
    // print('json in item class: $json');
    Subject = obj["Subject"] ?? '';
    StDate = obj["StDate"] ?? '';
    DueDate = obj["DueDate"] ?? '';
    Status = obj["Status"] ?? '';
    Priority = obj["Priority"] ?? '';
    Description = obj["Description"] ?? '';
  }
}


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
      assignTo: json['assign_ID'] ?? '',
      description: json['description'] ?? '',
    );
  }
}