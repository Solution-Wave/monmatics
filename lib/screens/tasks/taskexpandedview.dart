import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../utils/themes.dart';

class TaskExpandedView extends StatefulWidget {
  const TaskExpandedView(this.task_item,{super.key});
  final task_item;

  @override
  State<TaskExpandedView> createState() => _TaskExpandedViewState();
}

class _TaskExpandedViewState extends State<TaskExpandedView> {

  String relatedName = "";

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


  void fetchName()async {
    await fetchRelatedNames(widget.task_item.relatedId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Text('Task',
            style:  headerTextStyle ,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: ExpandedViewDecor,
            margin: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0,bottom: 25.0, left: 12.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subject:', style: titleStyle),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(widget.task_item.subject, style: normalStyle)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start Date:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(widget.task_item.startDate, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Due Date:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(widget.task_item.dueDate, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(widget.task_item.status, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Priority:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(widget.task_item.priority, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Related To:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(relatedName, style: normalStyle,)
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10.0,),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('Contact:',style: titleStyle,),
                    //     Container(
                    //         width: MediaQuery.of(context).size.width*0.5,
                    //         child: Text(task_item.contact, style: normalStyle,)),
                    //   ],
                    // ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Description:', style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(widget.task_item.description, style: normalStyle,)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}