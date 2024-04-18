import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
                            Text('Email:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object.email,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone No.:', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object.phone,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Category:',style: titleStyle,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(object.category, style: normalStyle,)),
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
                              child: Text(object.leadSource,
                                  style: normalStyle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status', style: titleStyle),
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(object.status,
                                  style: normalStyle),
                            ),
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
                            Text('Note',style: titleStyle,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(object.note, style: normalStyle,)),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Address',style: titleStyle,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                child: Text(object.address, style: normalStyle,)),
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
                            Uri phoneno = Uri.parse('tel:${object.phone}');
                            if(object.phone == '')
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
                          icon: const Icon(Icons.phone),
                        ),
                        IconButton(
                          color: Theme.of(context).brightness == Brightness.light?primaryColor: null,
                          iconSize: 25.0,
                          onPressed: () async{
                            String email = object.email;
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
                          icon: const Icon(Icons.mail),
                        ),
                        IconButton(
                          color: Theme.of(context).brightness == Brightness.light? primaryColor: null,
                          iconSize: 25.0,
                          onPressed: () {},
                          icon: const Icon(Icons.location_on),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
