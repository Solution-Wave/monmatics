import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/callItem.dart';
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/userItem.dart';
import '../../utils/colors.dart';
import '../../utils/themes.dart';
import 'callsForm.dart';

class CallsListTile extends StatefulWidget {
  const CallsListTile({
    required this.obj,
    super.key,
    this.onDelete
  });
  final CallHive obj;
  final Function(CallHive)? onDelete;

  @override
  State<CallsListTile> createState() => _CallsListTileState();
}

class _CallsListTileState extends State<CallsListTile> {
  bool _isExpanded = false;

  void navigateToEditScreen(BuildContext context, CallHive obj) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCalls(existingCall: obj),
      ),
    );
  }

  String relatedName = "";
  String assignName = "";
  String contactName = "";

  Future<void> fetchRelatedNames(String? relatedId) async {
    print("Fetching name for relatedId: $relatedId");
    if (relatedId != null && relatedId.isNotEmpty) {
      String? fetchedName;

      try {
        // Initialize variables for the Hive boxes
        var leadBox = await Hive.openBox<LeadHive>('leads');
        var customerBox = await Hive.openBox<CustomerHive>('customers');
        var contactsBox = await Hive.openBox<ContactHive>('contacts');

        // Check for a match in each box
        bool matchFound = false;

        // Check the Lead box
        for (var lead in leadBox.values) {
          if (lead.id == relatedId) {
            fetchedName = lead.name;
            matchFound = true;
            print("Found lead with name: $fetchedName");
            break;
          }
        }

        // If no match was found in the Lead box, check the Customer box
        if (!matchFound) {
          for (var customer in customerBox.values) {
            if (customer.id == relatedId) {
              fetchedName = customer.name;
              matchFound = true;
              print("Found customer with name: $fetchedName");
              break;
            }
          }
        }

        // If no match was found in the Lead or Customer box, check the Contacts box
        if (!matchFound) {
          for (var contact in contactsBox.values) {
            if (contact.id == relatedId) {
              String fullName = "${contact.fName} ${contact.lName}";
              fetchedName = fullName;
              matchFound = true;
              print("Found contact with name: $fetchedName");
              break;
            }
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Update the relatedName state variable
      setState(() {
        relatedName = fetchedName ?? '';
        print("Updated relatedName to: $relatedName");
      });

    } else {
      // Handle case where relatedId is null or empty
      print("relatedId is null or empty.");
    }
  }
  Future<void> fetchAssignNames(String? assignId) async {
    print("Fetching name for assignId: $assignId");
    if (assignId != null && assignId.isNotEmpty) {
      String? fetchedName;
      try {
        // Initialize variables for the Hive boxes
        var userBox = await Hive.openBox<UsersHive>('users');
        bool matchFound = false;

        // Check the Name box
        for (var name in userBox.values) {
          if (name.id == assignId) {
            String fullName = "${name.fName} ${name.lName}";
            fetchedName = fullName;
            matchFound = true;
            print("Found User with name: $fetchedName");
            break;
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Set the fetched name to the searchController
      setState(() {
        assignName = fetchedName ?? '';

      });
    } else {
      // Handle case where relatedId is null or empty
      print("assignId is null or empty.");
    }
  }
  Future<void> fetchContactNames(String? contactId) async {
    print("Fetching name for contactId: $contactId");
    if (contactId != null && contactId.isNotEmpty) {
      String? fetchedName;
      try {
        // Initialize variables for the Hive boxes
        var contactBox = await Hive.openBox<ContactHive>('contacts');
        bool matchFound = false;

        // Check the Name box
        for (var contact in contactBox.values) {
          if (contact.id == contactId) {
            String fullName = "${contact.fName} ${contact.lName}";
            fetchedName = fullName;
            matchFound = true;
            print("Found contact with name: $fetchedName");
            break;
          }
        }
      } catch (e) {
        print("Error fetching name: $e");
        fetchedName = 'Error';
      }

      // Set the fetched name to the searchController
      setState(() {
        contactName = fetchedName ?? '';
      });

    } else {
      // Handle case where relatedId is null or empty
      print("contactId is null or empty.");
    }
  }

  void fetchName()async {
    await fetchAssignNames(widget.obj.assignId);
    await fetchRelatedNames(widget.obj.relatedId);
    await fetchContactNames(widget.obj.contactId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchName();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryColor,
          expandedAlignment: Alignment.centerRight,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.obj.subject, style: listViewTextStyle),
                    Text("${widget.obj.startDate} ${widget.obj.startTime}"),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => navigateToEditScreen(context, widget.obj),
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
              ),
              IconButton(
                onPressed: (){
                    widget.onDelete!(widget.obj);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 15.0,
            right: 15.0,
          ),
          trailing: Icon(
            _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          ),
          onExpansionChanged: (bool val) {
            setState(() {
              _isExpanded = val;
            });
          },
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name',style: titleStyle,),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Text(contactName, style: normalStyle1,)),
                  ],
                ),
                // Row for Name
                const SizedBox(height: 10.0),

                // Row for Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start Date:', style: titleStyle),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Text("${widget.obj.startDate} ${widget.obj.startTime}",
                            style: normalStyle)),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Row for Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('End Date:', style: titleStyle),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Text("${widget.obj.startDate} ${widget.obj.startTime}",
                            style: normalStyle)),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Row for Subject
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subject:', style: titleStyle),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Text(widget.obj.subject, style: normalStyle)),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Row for Related To
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Related To:', style: titleStyle),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Text(relatedName, style: normalStyle1)),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Row for Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type:', style: titleStyle),
                    Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Text(widget.obj.communicationType, style: normalStyle)),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Row for Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Description:', style: titleStyle),
                    // Container for the description
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Text(
                        widget.obj.description,
                        style: normalStyle1,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
