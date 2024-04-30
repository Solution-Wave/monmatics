import 'package:hive/hive.dart';

@HiveType(typeId: 5)
  class CallHive extends HiveObject{

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late String status;

  @HiveField(3)
  late String relatedTo;

  @HiveField(4)
  late String relatedId;

  @HiveField(5)
  late String contactName;

  @HiveField(6)
  late String startDate;

  @HiveField(7)
  late String startTime;

  @HiveField(8)
  late String endDate;

  @HiveField(9)
  late String endTime;

  @HiveField(10)
  late String communicationType;

  @HiveField(11)
  late String assignTo;

  @HiveField(12)
  late String description;

  @HiveField(13)
  late String assignId;

  @HiveField(14)
  late String relatedType;

  @HiveField(15)
  late String contactId;

  @HiveField(16)
  late DateTime? addedAt;

  CallHive({
    this.id = "",
    this.subject = "",
    this.status = "",
    this.relatedTo = "",
    this.relatedId = "",
    this.contactName = "",
    this.startDate = "",
    this.startTime = "",
    this.endDate = "",
    this.endTime = "",
    this.communicationType = "",
    this.assignTo = "",
    this.description = "",
    this.assignId = "",
    this.relatedType = "",
    this.contactId = "",
    this.addedAt,
});

  factory CallHive.fromJson(Map<String, dynamic> json){
    String id = json['id']?.toString() ?? "";

    return CallHive(
      id: id,
      subject: json['subject'] ?? "",
      status: json['status'] ?? "",
      relatedType: json['related_to_type'] ?? "",
      relatedId: json['related_id']?.toString() ?? "",
      // contactName: json['contact_name'] ?? "",
      startDate: json['start_date'] ?? "",
      // startTime: json['start_time'] ?? "",
      endDate: json['end_date'] ?? "",
      // endTime: json['end_time'] ?? "",
      communicationType: json['communication_type'] ?? "",
      assignTo: json['assigned_to']?.toString() ?? "",
      description: json['description'] ?? "",
      assignId: json['assigned_to']?.toString() ?? "",
      contactId: json['contact_id']?.toString() ?? "",
    );
  }

}

