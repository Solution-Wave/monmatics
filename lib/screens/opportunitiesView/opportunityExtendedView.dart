import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/userItem.dart';
import '../../utils/themes.dart';

class OpportunityExtendedScreen extends StatefulWidget {
  const OpportunityExtendedScreen(this.object,{Key? key}) : super(key: key);
  final  object;

  @override
  State<OpportunityExtendedScreen> createState() => _OpportunityExtendedScreenState();
}

class _OpportunityExtendedScreenState extends State<OpportunityExtendedScreen> {


  String assignName = "";

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

  void fetchNames() async {
    fetchAssignNames(widget.object.assignId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNames();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Opportunity Details',style:  headerTextStyle ,),
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: ExpandedViewDecor,
              margin: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  // maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Id:', style: titleStyle),
                        //     Container(
                        //       width: MediaQuery.of(context).size.width*0.4,
                        //       child: Text(widget.object.id,
                        //           style: normalStyle),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Name:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(widget.object.name,
                                  style: normalStyle1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text("${widget.object.currency} ${widget.object.amount}",
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Close Date:',style: titleStyle,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(widget.object.closeDate, style: normalStyle,)),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Type', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(widget.object.type,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sale Stage', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(widget.object.stage,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lead Source:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(widget.object.source,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Campaign', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(widget.object.campaign,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Next Step', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(widget.object.nextStep,
                                  style: normalStyle1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Assign To',style: titleStyle,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(assignName, style: normalStyle,)),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Description',style: titleStyle,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(widget.object.description, style: normalStyle1,)),
                          ],
                        ),
                        const SizedBox(height: 20.0,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
