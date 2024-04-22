import 'package:hive/hive.dart';

import '../models/opportunityItem.dart';

class OpportunityAdapter extends TypeAdapter<OpportunityHive>{
  @override
  final int typeId = 7;

  @override
  OpportunityHive read(BinaryReader reader){
    return OpportunityHive()
      ..id = reader.readString()
      ..name = reader.readString()
      ..lead = reader.readString()
      ..currency = reader.readString()
      ..amount = reader.readString()
      ..closeDate = reader.readString()
      ..type = reader.readString()
      ..stage = reader.readString()
      ..source = reader.readString()
      ..campaign = reader.readString()
      ..nextStep = reader.readString()
      ..assignTo = reader.readString()
      ..description = reader.readString();
  }

  @override
  void write(BinaryWriter writer, OpportunityHive obj){
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.lead);
    writer.writeString(obj.currency);
    writer.writeString(obj.amount);
    writer.writeString(obj.closeDate);
    writer.writeString(obj.type);
    writer.writeString(obj.stage);
    writer.writeString(obj.source);
    writer.writeString(obj.campaign);
    writer.writeString(obj.nextStep);
    writer.writeString(obj.assignTo);
    writer.writeString(obj.description);
  }
}