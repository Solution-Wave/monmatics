import 'package:hive/hive.dart';
import '../models/callItem.dart';

class CallsAdapter extends TypeAdapter<CallHive>{
  @override
  final int typeId = 5;

  @override
  CallHive read(BinaryReader reader){
    return CallHive()
        ..id = reader.readString()
        ..subject = reader.readString()
        ..status = reader.readString()
        ..relatedTo = reader.readString()
        ..relatedId = reader.readString()
        ..contactName = reader.readString()
        ..startDate = reader.readString()
        ..startTime = reader.readString()
        ..endDate = reader.readString()
        ..endTime = reader.readString()
        ..communicationType = reader.readString()
        ..assignTo = reader.readString()
        ..description = reader.readString()
        ..assignId = reader.readString();
  }

  @override
  void write(BinaryWriter writer, CallHive obj){
    writer.writeString(obj.id);
    writer.writeString(obj.subject);
    writer.writeString(obj.status);
    writer.writeString(obj.relatedTo);
    writer.writeString(obj.relatedId);
    writer.writeString(obj.contactName);
    writer.writeString(obj.startDate);
    writer.writeString(obj.startTime);
    writer.writeString(obj.endDate);
    writer.writeString(obj.endTime);
    writer.writeString(obj.communicationType);
    writer.writeString(obj.assignTo);
    writer.writeString(obj.description);
    writer.writeString(obj.assignId);
  }
}