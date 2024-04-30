import 'package:hive/hive.dart';
import '../models/userItem.dart';

class UserAdapter extends TypeAdapter<UsersHive> {
  @override
  final int typeId = 6;

  @override
  UsersHive read(BinaryReader reader) {
    // Initialize UsersHive object
    UsersHive user = UsersHive();

    // Read each field in the same order as they are written
    user.id = reader.readString();
    user.fName = reader.readString();
    user.lName = reader.readString();
    user.email = reader.readString();
    user.role = reader.readString();

    return user;
  }

  @override
  void write(BinaryWriter writer, UsersHive obj) {
    // Write each field in the same order as they are read
    writer.writeString(obj.id);
    writer.writeString(obj.fName);
    writer.writeString(obj.lName);
    writer.writeString(obj.email);
    writer.writeString(obj.role);
  }
}