import 'package:hive/hive.dart';
import '../models/customerItem.dart';

class CustomerAdapter extends TypeAdapter<CustomerHive> {
  @override
  final int typeId = 1;

  @override
  CustomerHive read(BinaryReader reader) {
    return CustomerHive()
      ..id = reader.readString()
      ..name = reader.readString()
      ..email = reader.readString()
      ..phone = reader.readString()
      ..category = reader.readString()
      ..account = reader.readString()
      ..accountCode = reader.readString()
      ..limit = reader.readString()
      ..amount = reader.readString()
      ..taxNumber = reader.readString()
      ..status = reader.readString()
      ..type = reader.readString()
      ..margin = reader.readString()
      ..note = reader.readString()
      ..address = reader.readString();
  }

  @override
  void write(BinaryWriter writer, CustomerHive obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.phone);
    writer.writeString(obj.category);
    writer.writeString(obj.account);
    writer.writeString(obj.accountCode);
    writer.writeString(obj.limit);
    writer.writeString(obj.amount);
    writer.writeString(obj.taxNumber);
    writer.writeString(obj.status);
    writer.writeString(obj.type);
    writer.writeString(obj.margin);
    writer.writeString(obj.note);
    writer.writeString(obj.address);
  }
}