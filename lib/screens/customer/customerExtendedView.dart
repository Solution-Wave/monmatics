import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';

class CustomerView extends StatelessWidget {
  const CustomerView(this.customer, {Key? key}) : super(key: key);
  final customer;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Customer Details',
              style: headerTextStyle,
            ),
          ),
          body: Container(
            decoration: ExpandedViewDecor,
            margin: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height),
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
                        children: [
                          Text('Name:', style: titleStyle),
                          const SizedBox(
                            width: 80.0,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child:
                                  Text(customer['Name'], style: normalStyle)),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Name:',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                customer['CompanyName'],
                                style: normalStyle,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category:',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            width: 60.0,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                customer['Category'],
                                style: normalStyle,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            width: 70.0,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                customer['Address'],
                                style: normalStyle,
                              )),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light
                            ? primaryColor
                            : null,
                        iconSize: 25.0,
                        onPressed: () async {
                          Uri phoneno = Uri.parse('tel:${customer['Phone']}');
                          if (customer['Phone'] == '') {
                            showSnackMessage(
                                context, 'Phone number not provided');
                          } else {
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? primaryColor
                            : null,
                        iconSize: 25.0,
                        onPressed: () async {
                          Uri mail = Uri(
                            scheme: 'mailto',
                            path: customer['Email'],
                            query: 'subject=emails&body=',
                          );
                          if (customer['Email'] == '') {
                            showSnackMessage(
                                context, 'Email not provided');
                          } else {
                            try {
                              await launchUrl(mail);
                            } catch (_e) {
                              print(_e);
                            }
                          }

                        },
                        icon: Icon(Icons.mail),
                      ),
                      IconButton(
                        color: Theme.of(context).brightness == Brightness.light
                            ? primaryColor
                            : null,
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
