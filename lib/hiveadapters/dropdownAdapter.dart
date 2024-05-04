import 'package:hive/hive.dart';
import '../models/dropdownItem.dart';

class DropdownOptionsAdapter extends TypeAdapter<DropdownOptions> {
  @override
  final int typeId = 8;

  @override
  DropdownOptions read(BinaryReader reader) {
    return DropdownOptions(
      customerCreditLimit: reader.readList().cast<String>(),
      employeeDesignation: reader.readList().cast<String>(),
      opportunitiesType: reader.readList().cast<String>(),
      opportunitiesSaleStage: reader.readList().cast<String>(),
      taskPriority: reader.readList().cast<String>(),
      opportunitiesLeadSource: reader.readList().cast<String>(),
      customerType: reader.readList().cast<String>(),
      callsCommunicationType: reader.readList().cast<String>(),
      taskStatus: reader.readList().cast<String>(),
      ticketStatus: reader.readList().cast<String>(),
      ticketCategory: reader.readList().cast<String>(),
      ticketPriority: reader.readList().cast<String>(),
      customerCategory: reader.readList().cast<String>(),
      customerStatus: reader.readList().cast<String>(),
      callStatus: reader.readList().cast<String>(),
      opportunityCurrency: reader.readList().cast<String>(),
      opportunityCampaign: reader.readList().cast<String>(),
      leadStatus: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DropdownOptions obj) {
    // Write data in the same order as the fields are declared in the class
    writer.writeList(obj.customerCreditLimit);
    writer.writeList(obj.employeeDesignation);
    writer.writeList(obj.opportunitiesType);
    writer.writeList(obj.opportunitiesSaleStage);
    writer.writeList(obj.taskPriority);
    writer.writeList(obj.opportunitiesLeadSource);
    writer.writeList(obj.customerType);
    writer.writeList(obj.callsCommunicationType);
    writer.writeList(obj.taskStatus);
    writer.writeList(obj.ticketStatus);
    writer.writeList(obj.ticketCategory);
    writer.writeList(obj.ticketPriority);
    writer.writeList(obj.customerCategory);
    writer.writeList(obj.customerStatus);
    writer.writeList(obj.callStatus);
    writer.writeList(obj.opportunityCurrency);
    writer.writeList(obj.opportunityCampaign);
    writer.writeList(obj.leadStatus);
  }
}
