import 'package:hive/hive.dart';
import '../models/contactItem.dart';

class ContactAdapter extends TypeAdapter<ContactHive> {
  @override
  final int typeId = 4;

  @override
  ContactHive read(BinaryReader reader) {
    ContactHive contact = ContactHive();

    // Read each field in the same order as they are written
    contact.id = reader.readString();
    contact.type = reader.readString();
    contact.fName = reader.readString();
    contact.lName = reader.readString();
    contact.title = reader.readString();
    contact.relatedTo = reader.readString();
    contact.search = reader.readString();
    contact.assignTo = reader.readString();
    contact.phone = reader.readString();
    contact.email = reader.readString();
    contact.officePhone = reader.readString();
    contact.address = reader.readString();
    contact.city = reader.readString();
    contact.state = reader.readString();
    contact.postalCode = reader.readString();
    contact.country = reader.readString();
    contact.description = reader.readString();

    // Add read for addedAt field
    // contact.addedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return contact;
  }

  @override
  void write(BinaryWriter writer, ContactHive obj) {
    // Write each field in the same order as they are read
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

    // Add write for addedAt field
    // writer.writeInt(obj.addedAt!.millisecondsSinceEpoch);
  }
}
