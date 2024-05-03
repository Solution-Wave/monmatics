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
                        //         width: MediaQuery.of(context).size.width * 0.4,
                        //         child:
                        //         Text(customer.id, style: normalStyle)),
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
                                width: MediaQuery.of(context).size.width * 0.4,
                                child:
                                    Text(customer.name,
                                        style: normalStyle1
                                    )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.email,
                                  style: normalStyle1,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phone No.:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.phone,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.category,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Account No: ',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.account,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Account Code:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.accountCode,
                                  style: normalStyle1,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Credit Limit:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.limit,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Credit Amount:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.amount,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tax No.:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.taxNumber,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.status,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Type:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.type,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Margin %:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.margin,
                                  style: normalStyle,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Note:',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.note,
                                  style: normalStyle1,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Address',
                              style: titleStyle,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  customer.address,
                                  style: normalStyle1,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          color: Theme.of(context).brightness == Brightness.light
                              ? primaryColor
                              : null,
                          iconSize: 25.0,
                          onPressed: () async {
                            Uri phoneno = Uri.parse('tel:${customer.phone}');
                            if (customer.phone == '') {
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
                          icon: const Icon(Icons.phone),
                        ),
                        IconButton(
                          color: Theme.of(context).brightness == Brightness.light
                              ? primaryColor
                              : null,
                          iconSize: 25.0,
                          onPressed: () async {
                            Uri mail = Uri(
                              scheme: 'mailto',
                              path: customer.email,
                              query: 'subject=emails&body=',
                            );
                            if (customer.email == '') {
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
                          icon: const Icon(Icons.mail),
                        ),
                        IconButton(
                          color: Theme.of(context).brightness == Brightness.light
                              ? primaryColor
                              : null,
                          iconSize: 25.0,
                          onPressed: () {},
                          icon: const Icon(Icons.location_on),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
