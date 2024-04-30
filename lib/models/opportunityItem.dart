import 'package:hive/hive.dart';

@HiveType(typeId: 7)
class OpportunityHive extends HiveObject {

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String leadName;

  @HiveField(3)
  late String currency;

  @HiveField(4)
  late String amount;

  @HiveField(5)
  late String closeDate;

  @HiveField(6)
  late String type;

  @HiveField(7)
  late String stage;

  @HiveField(8)
  late String source;

  @HiveField(9)
  late String campaign;

  @HiveField(10)
  late String nextStep;

  @HiveField(11)
  late String assignTo;

  @HiveField(12)
  late String description;

  @HiveField(13)
  DateTime? addedAt;

  @HiveField(14)
  late String leadId;

  @HiveField(15)
  late String assignId;

  OpportunityHive({
    this.id = "",
    this.name = "",
    this.leadName = "",
    this.currency = "",
    this.amount = "",
    this.closeDate = "",
    this.type = "",
    this.stage = "",
    this.source = "",
    this.campaign = "",
    this.nextStep = "",
    this.assignTo = "",
    this.description = "",
    this.addedAt,
    this.leadId = "",
    this.assignId = "",
  });

  // Factory constructor to deserialize JSON data into an OpportunityHive object
  factory OpportunityHive.fromJson(Map<String, dynamic> json) {
    // Convert integer values to string where necessary
    return OpportunityHive(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      leadName: json['cust_id'] as String? ?? '',
      currency: json['cur_name'] as String? ?? '',
      amount: json['amount'].toString(),
      closeDate: json['close_date'] as String? ?? '',
      type: json['lead_type'] as String? ?? '',
      stage: json['sale_stage'] as String? ?? '',
      source: json['lead_source'] as String? ?? '',
      campaign: json['campaign_id']?.toString() ?? '',
      nextStep: json['next_step'] as String? ?? '',
      assignTo: json['assigned_to']?.toString() ?? '',
      description: json['description'] as String? ?? '',
      addedAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      leadId: json['cust_id'] as String? ?? '',
      assignId: json['assigned_to']?.toString() ?? '',
    );
  }
}
