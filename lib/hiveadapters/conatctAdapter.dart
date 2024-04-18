import 'package:hive/hive.dart';
import '../models/contactItem.dart';

class ContactAdapter extends TypeAdapter<ContactHive>{
  @override
  final int typeId = 4;

  @override
  ContactHive read(BinaryReader reader){
    return ContactHive()
        ..id = reader.readString()
        ..type = reader.readString()
        ..fName = reader.readString()
        ..lName = reader.readString()
        ..title = reader.readString()
        ..relatedTo = reader.readString()
        ..search = reader.readString()
        ..assignTo = reader.readString()
        ..phone = reader.readString()
        ..email = reader.readString()
        ..officePhone = reader.readString()
        ..address = reader.readString()
        ..city = reader.readString()
        ..state = reader.readString()
        ..postalCode = reader.readString()
        ..country = reader.readString()
        ..description = reader.readString();
  }

  @override
  void write(BinaryWriter writer, ContactHive obj){
    writer.writeString(obj.id);
    writer.writeString(obj.type);
    writer.writeString(obj.fName);
    writer.writeString(obj.lName);
    writer.writeString(obj.title);
    writer.writeString(obj.relatedTo);
    writer.writeString(obj.search);
    writer.writeString(obj.assignTo);
    writer.writeString(obj.phone);
    writer.writeString(obj.email);
    writer.writeString(obj.officePhone);
    writer.writeString(obj.address);
    writer.writeString(obj.city);
    writer.writeString(obj.state);
    writer.writeString(obj.postalCode);
    writer.writeString(obj.country);
    writer.writeString(obj.description);
  }
}