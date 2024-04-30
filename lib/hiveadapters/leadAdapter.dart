import 'package:hive/hive.dart';
import '../models/leadItem.dart';

class LeadAdapter extends TypeAdapter<LeadHive> {
  @override
  final int typeId = 3;

  @override
  LeadHive read(BinaryReader reader) {
    // Initialize a new instance of LeadHive
    LeadHive lead = LeadHive();

    // Read each field in the same order as they are written
    lead.id = reader.readString();
    lead.name = reader.readString();
    lead.email = reader.readString();
    lead.phone = reader.readString();
    lead.category = reader.readString();
    lead.leadSource = reader.readString();
    lead.status = reader.readString();
    lead.type = reader.readString();
    lead.note = reader.readString();
    lead.address = reader.readString();

    return lead;
  }

  @override
  void write(BinaryWriter writer, LeadHive obj) {
    // Write each field in the same order as they are read
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.phone);
    writer.writeString(obj.category);
    writer.writeString(obj.leadSource);
    writer.writeString(obj.status);
    writer.writeString(obj.type);
    writer.writeString(obj.note);
    writer.writeString(obj.address);
  }
}
