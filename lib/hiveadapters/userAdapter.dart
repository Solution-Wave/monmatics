import 'package:hive/hive.dart';
import '../models/userItem.dart';

class UserAdapter extends TypeAdapter<UsersHive>{
  @override
  final int typeId = 6;

  @override
  UsersHive read(BinaryReader reader) {
    return UsersHive()
        ..id = reader.readString()
        ..fName = reader.readString()
        ..lName = reader.readString()
        ..email = reader.readString()
        ..role = reader.readString();
  }

  @override
  void write(BinaryWriter writer, UsersHive obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.fName);
    writer.writeString(obj.lName);
    writer.writeString(obj.email);
    writer.writeString(obj.role);
  }

}