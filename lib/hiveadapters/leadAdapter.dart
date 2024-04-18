import 'package:hive/hive.dart';
import '../models/leadItem.dart';

class LeadAdapter extends TypeAdapter<LeadHive>{
  @override
  final int typeId = 3;

  @override
  LeadHive read(BinaryReader reader){
    return LeadHive()
        ..id = reader.readString()
        ..name = reader.readString()
        ..email = reader.readString()
        ..phone = reader.readString()
        ..category = reader.readString()
        ..leadSource = reader.readString()
        ..status = reader.readString()
        ..type = reader.readString()
        ..note = reader.readString()
        ..address = reader.readString();
  }

  @override
  void write(BinaryWriter writer, LeadHive obj){
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