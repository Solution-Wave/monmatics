import 'package:hive/hive.dart';
import '../models/opportunityItem.dart';

class OpportunityAdapter extends TypeAdapter<OpportunityHive> {
  @override
  final int typeId = 7;

  @override
  OpportunityHive read(BinaryReader reader) {
    // Initialize a new instance of OpportunityHive
    OpportunityHive opportunity = OpportunityHive();

    // Read each field in the same order as they are written
    opportunity.id = reader.readString();
    opportunity.name = reader.readString();
    opportunity.leadName = reader.readString();
    opportunity.currency = reader.readString();
    opportunity.amount = reader.readString();
    opportunity.closeDate = reader.readString();
    opportunity.type = reader.readString();
    opportunity.stage = reader.readString();
    opportunity.source = reader.readString();
    opportunity.campaign = reader.readString();
    opportunity.nextStep = reader.readString();
    opportunity.assignTo = reader.readString();
    opportunity.description = reader.readString();
    opportunity.leadId = reader.readString();
    opportunity.assignId = reader.readString();

    return opportunity;
  }

  @override
  void write(BinaryWriter writer, OpportunityHive obj) {
    // Write each field in the same order as they are read
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.leadName);
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
    writer.writeString(obj.leadId);
    writer.writeString(obj.assignId);
  }
}
