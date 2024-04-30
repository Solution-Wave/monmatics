import 'package:hive/hive.dart';
import '../models/noteItem.dart';

class NoteAdapter extends TypeAdapter<NoteHive> {
  @override
  final int typeId = 0;

  @override
  NoteHive read(BinaryReader reader) {
    // Initialize a new instance of NoteHive
    NoteHive note = NoteHive();

    // Read each field in the same order as they are written
    note.subject = reader.readString();
    note.relatedTo = reader.readString();
    note.search = reader.readString();
    note.assignTo = reader.readString();
    note.description = reader.readString();
    note.id = reader.readString();
    note.relatedId = reader.readString();
    note.assignId = reader.readString();

    return note;
  }

  @override
  void write(BinaryWriter writer, NoteHive obj) {
    // Write each field in the same order as they are read
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

// Don't forget to register the adapter
// Hive.registerAdapter(NoteAdapter());
