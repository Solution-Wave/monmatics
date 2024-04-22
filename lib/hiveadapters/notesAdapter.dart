import 'package:hive/hive.dart';
import '../models/noteItem.dart';

class NoteAdapter extends TypeAdapter<NoteHive> {
  @override
  final int typeId = 0;

  @override
  NoteHive read(BinaryReader reader) {
    return NoteHive()
      ..subject = reader.readString()
      ..relatedTo = reader.readString()
      ..search = reader.readString()
      ..assignTo = reader.readString()
      ..description = reader.readString()
      ..id = reader.readString()
      ..relatedId = reader.readString()
      ..assignId = reader.readString();
  }

  @override
  void write(BinaryWriter writer, NoteHive obj) {
    writer.writeString(obj.subject);
    writer.writeString(obj.relatedTo);
    writer.writeString(obj.search);
    writer.writeString(obj.assignTo);
    writer.writeString(obj.description);
    writer.writeString(obj.id);
    writer.writeString(obj.relatedId);
    writer.writeString(obj.assignId);
  }
}