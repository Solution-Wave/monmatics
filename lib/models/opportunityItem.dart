
import 'package:hive/hive.dart';

@HiveType(typeId: 7)
class OpportunityHive extends HiveObject{

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String lead;

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
}