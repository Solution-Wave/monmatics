import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/leadItem.dart';
import '../../utils/colors.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class LeadsScreen extends StatelessWidget {
  const LeadsScreen(this.object,{Key? key}) : super(key: key);
 final  object;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Lead Details',style:  headerTextStyle ,),
          ),
          body: Container(
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
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name', style: titleStyle),
                          const SizedBox(width: 50.0,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            child: Text(object['Name'],
                                style: normalStyle),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category',style: titleStyle,),
                          const SizedBox(width: 30.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object['Category'], style: normalStyle,)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address',style: titleStyle,),
                          const SizedBox(width: 30.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object['Address'], style: normalStyle,)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Note',style: titleStyle,),
                          const SizedBox(width: 50.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object['Note'], style: normalStyle,)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light? primaryColor: null,
                        iconSize: 25.0,
                        onPressed: () async {
                          Uri phoneno = Uri.parse('tel:${object['phone']}');
                          if(object['phone'] == '')
                          {
                            showSnackMessage(context, 'Phone number not provided');
                          }
                          else
                          {
                            try {
                              await launchUrl(phoneno);
                            } catch (_e) {
                              print(_e);
                            }
                          }
                        },
                        icon: Icon(Icons.phone),
                      ),
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light?primaryColor: null,
                        iconSize: 25.0,
                        onPressed: () async{
                          String email = object['Email'];
                          Uri mail = Uri(
                            scheme: 'mailto',
                            path: email,
                            query: 'subject=emails&body=',);
                          if(email=='')
                          {
                            showSnackMessage(context,'Email not provided');
                          }
                          else
                          {
                            try {
                              await launchUrl(mail);
                            } catch (_e) {
                              showSnackMessage(context, 'Something went wrong');
                            }
                          }
                        },
                        icon: Icon(Icons.mail),
                      ),
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light? primaryColor: null,
                        iconSize: 25.0,
                        onPressed: () {},
                        icon: Icon(Icons.location_on),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
