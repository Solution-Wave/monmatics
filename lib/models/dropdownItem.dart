import 'package:hive/hive.dart';

@HiveType(typeId: 8)
class DropdownOptions extends HiveObject {
  @HiveField(0)
  List<String> customerCreditLimit;

  @HiveField(1)
  List<String> employeeDesignation;

  @HiveField(2)
  List<String> opportunitiesType;

  @HiveField(3)
  List<String> opportunitiesSaleStage;

  @HiveField(4)
  List<String> taskPriority;

  @HiveField(5)
  List<String> opportunitiesLeadSource;

  @HiveField(6)
  List<String> customerType;

  @HiveField(7)
  List<String> callsCommunicationType;

  @HiveField(8)
  List<String> taskStatus;

  @HiveField(9)
  List<String> ticketStatus;

  @HiveField(10)
  List<String> ticketCategory;

  @HiveField(11)
  List<String> ticketPriority;

  // Constructor
  DropdownOptions({
    required this.customerCreditLimit,
    required this.employeeDesignation,
    required this.opportunitiesType,
    required this.opportunitiesSaleStage,
    required this.taskPriority,
    required this.opportunitiesLeadSource,
    required this.customerType,
    required this.callsCommunicationType,
    required this.taskStatus,
    required this.ticketStatus,
    required this.ticketCategory,
    required this.ticketPriority,
  });

  // Factory constructor to create an instance from a JSON map
  factory DropdownOptions.fromJson(Map<String, dynamic> json) {
    return DropdownOptions(
      customerCreditLimit: List<String>.from(json['customerCreditLimit'] ?? []),
      employeeDesignation: List<String>.from(json['employeeDesignation'] ?? []),
      opportunitiesType: List<String>.from(json['opportunitiesType'] ?? []),
      opportunitiesSaleStage: List<String>.from(json['opportunitiesSaleStage'] ?? []),
      taskPriority: List<String>.from(json['taskPriority'] ?? []),
      opportunitiesLeadSource: List<String>.from(json['opportunitiesLeadSource'] ?? []),
      customerType: List<String>.from(json['customerType'] ?? []),
      callsCommunicationType: List<String>.from(json['callsCommunicationType'] ?? []),
      taskStatus: List<String>.from(json['taskStatus'] ?? []),
      ticketStatus: List<String>.from(json['ticketStatus'] ?? []),
      ticketCategory: List<String>.from(json['ticketCategory'] ?? []),
      ticketPriority: List<String>.from(json['ticketPriority'] ?? []),
    );
  }

  // You might also want to add a method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'customerCreditLimit': customerCreditLimit,
      'employeeDesignation': employeeDesignation,
      'opportunitiesType': opportunitiesType,
      'opportunitiesSaleStage': opportunitiesSaleStage,
      'taskPriority': taskPriority,
      'opportunitiesLeadSource': opportunitiesLeadSource,
      'customerType': customerType,
      'callsCommunicationType': callsCommunicationType,
      'taskStatus': taskStatus,
      'ticketStatus': ticketStatus,
      'ticketCategory': ticketCategory,
      'ticketPriority': ticketPriority,
    };
  }
}
