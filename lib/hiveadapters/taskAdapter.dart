import 'package:hive/hive.dart';
import '../models/taskItem.dart';

class TaskAdapter extends TypeAdapter<TaskHive>{
  @override
  final int typeId = 2;

  @override
  TaskHive read(BinaryReader reader) {
    return TaskHive()
        ..subject  = reader.readString()
        ..status = reader.readString()
        ..type = reader.readString()
        ..relatedTo = reader.readString()
        ..startDate = reader.readString()
        ..dueDate = reader.readString()
        ..priority = reader.readString()
        ..assignTo = reader.readString()
        ..description = reader.readString()
        ..id = reader.readString()
        ..relatedId = reader.readString()
        ..assignId = reader.readString()
        ..contact = reader.readString()
        ..companyId = reader.readString();
  }

  @override
  void write(BinaryWriter writer, TaskHive obj) {
    writer.writeString(obj.subject);
    writer.writeString(obj.status);
    writer.writeString(obj.type);
    writer.writeString(obj.relatedTo);
    writer.writeString(obj.startDate);
    writer.writeString(obj.dueDate);
    writer.writeString(obj.priority);
    writer.writeString(obj.assignTo);
    writer.writeString(obj.description);
    writer.writeString(obj.id);
    writer.writeString(obj.relatedId);
    writer.writeString(obj.assignId);
    writer.writeString(obj.contact);
    writer.writeString(obj.companyId);
  }

}