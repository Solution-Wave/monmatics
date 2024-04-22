import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/colors.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class OpportunityExtendedScreen extends StatelessWidget {
  const OpportunityExtendedScreen(this.object,{Key? key}) : super(key: key);
  final  object;
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
                  maxHeight: MediaQuery.of(context).size.height
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Id:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object.id,
                                  style: normalStyle),
                            ),
                          ],
                        ),
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
                              child: Text(object.name,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lead:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object.lead,
                                  style: normalStyle),
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
                              child: Text("${object.currency} ${object.amount}",
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
                                child: Text(object.closeDate, style: normalStyle,)),
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
                              child: Text(object.type,
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
                              child: Text(object.stage,
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
                              child: Text(object.source,
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
                              child: Text(object.campaign,
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
                              child: Text(object.nextStep,
                                  style: normalStyle),
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
                                child: Text(object.assignTo, style: normalStyle,)),
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
                                child: Text(object.description, style: normalStyle,)),
                          ],
                        ),
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
