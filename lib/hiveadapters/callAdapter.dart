import 'package:hive/hive.dart';
import '../models/callItem.dart';

class CallsAdapter extends TypeAdapter<CallHive> {
  @override
  final int typeId = 5;

  @override
  CallHive read(BinaryReader reader) {
    // Initialize a CallHive instance
    CallHive callHive = CallHive();

    // Read each field in the same order as they are written
    callHive.subject = reader.readString();
    callHive.status = reader.readString();
    callHive.relatedType = reader.readString();
    callHive.relatedTo = reader.readString();
    callHive.contactName = reader.readString();
    callHive.startDate = reader.readString();
    callHive.startTime = reader.readString();
    callHive.endDate = reader.readString();
    callHive.endTime = reader.readString();
    callHive.communicationType = reader.readString();
    callHive.assignTo = reader.readString();
    callHive.description = reader.readString();
    callHive.id = reader.readString();
    callHive.assignId = reader.readString();
    callHive.contactId = reader.readString();
    callHive.relatedId = reader.readString();
    // callHive.addedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return callHive;
  }

  @override
  void write(BinaryWriter writer, CallHive obj) {
    // Write each field in the same order as they are read
    writer.writeString(obj.subject);
    writer.writeString(obj.status);
    writer.writeString(obj.relatedType);
    writer.writeString(obj.relatedTo);
    writer.writeString(obj.contactName);
    writer.writeString(obj.startDate);
    writer.writeString(obj.startTime);
    writer.writeString(obj.endDate);
    writer.writeString(obj.endTime);
    writer.writeString(obj.communicationType);
    writer.writeString(obj.assignTo);
    writer.writeString(obj.description);
    writer.writeString(obj.id);
    writer.writeString(obj.assignId);
    writer.writeString(obj.contactId);
    writer.writeString(obj.relatedId);
    // writer.writeInt(obj.addedAt!.millisecondsSinceEpoch);
  }
}

