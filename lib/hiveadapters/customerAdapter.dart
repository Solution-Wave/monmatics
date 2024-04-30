import 'package:hive/hive.dart';
import '../models/customerItem.dart';

class CustomerAdapter extends TypeAdapter<CustomerHive> {
  @override
  final int typeId = 1;

  @override
  CustomerHive read(BinaryReader reader) {
    // Initialize a new instance of CustomerHive
    CustomerHive customer = CustomerHive();

    // Read each field in the same order as they are written
    customer.id = reader.readString();
    customer.name = reader.readString();
    customer.email = reader.readString();
    customer.phone = reader.readString();
    customer.category = reader.readString();
    customer.account = reader.readString();
    customer.accountCode = reader.readString();
    customer.limit = reader.readString();
    customer.amount = reader.readString();
    customer.taxNumber = reader.readString();
    customer.status = reader.readString();
    customer.type = reader.readString();
    customer.margin = reader.readString();
    customer.note = reader.readString();
    customer.address = reader.readString();

    return customer;
  }

  @override
  void write(BinaryWriter writer, CustomerHive obj) {
    // Write each field in the same order as they are read
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
