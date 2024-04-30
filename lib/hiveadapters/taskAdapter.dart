import 'package:hive/hive.dart';
import '../models/taskItem.dart';

class TaskAdapter extends TypeAdapter<TaskHive> {
  @override
  final int typeId = 2;

  @override
  TaskHive read(BinaryReader reader) {
    // Initialize TaskHive object
    TaskHive task = TaskHive();

    // Read each field in the same order as they are written
    task.subject = reader.readString();
    task.status = reader.readString();
    task.type = reader.readString();
    task.relatedTo = reader.readString();
    task.startDate = reader.readString();
    task.dueDate = reader.readString();
    task.priority = reader.readString();
    task.assignTo = reader.readString();
    task.description = reader.readString();
    task.id = reader.readString();
    task.relatedId = reader.readString();
    task.assignId = reader.readString();
    task.contact = reader.readString();
    task.companyId = reader.readString();

    return task;
  }

  @override
  void write(BinaryWriter writer, TaskHive obj) {
    // Write each field in the same order as they are read
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
