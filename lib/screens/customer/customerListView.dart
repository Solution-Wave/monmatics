import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Functions/importFunctions.dart';
import '../../models/customerItem.dart';
import '../../searchScreens/customerSearch.dart';
import '../../utils/colors.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import 'customerExtendedView.dart';
import 'customerForm.dart';

List customerList = [];

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  Box? customer;

  Future<bool> getCustomers() async {
    customer = await Hive.openBox('customers');
    setState(() {});
    return Future.value(true);
  }


  Future<bool> getList() async {
    customerList.clear();
    List tempList = customer!.values.toList();
    setState(() {
      for (var i in tempList) {
        customerList.add(i);
      }
    });
    return Future.value(true);
  }

  void openSearch() async {
    await getList();
    showSearch(
      context: context,
      delegate: SearchCustomer(),
    );
  }

  ImportFunctions importFunctions = ImportFunctions();

  @override
  void initState() {
    importFunctions.fetchCustomersFromApi();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Customers', style: headerTextStyle),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () => openSearch(),
              )
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: FutureBuilder(
                  future: getCustomers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (customer!.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: customer?.length,
                          itemBuilder: (BuildContext context, index) {
                            return CustomerListTile(obj: customer?.getAt(index));
                          },
                        );
                      } else {
                        return const Center(child: Text('No Data Found'));
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    }
                  })
              // loading ?
              //     Center(
              //       child: CircularProgressIndicator(
              //         color: primaryColor,
              //       ),
              //     )
              // :
              // ListView.builder(
              //   itemCount: customerList.length,
              //     itemBuilder: (BuildContext, index){
              //     return CustomerListTile(obj: customerList[index]);
              // },
              // ),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? popupmenuButtonCol
              : null,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCustomer()));
          },
          child: const Icon(Icons.add,
            size: 40.0),
        ),
      ),
    );
  }
}

class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    Key? key,
    required this.obj,
  }) : super(key: key);

  final CustomerHive obj;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext) => CustomerView(obj)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  obj.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                iconSize: 20.0,
                onPressed: () async {
                  Uri phoneno = Uri.parse('tel:${obj.phone}');
                  if (obj.phone.isEmpty) {
                    showSnackMessage(context, 'Phone number not provided');
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
                iconSize: 20.0,
                onPressed: () async {
                  Uri mail = Uri(
                    scheme: 'mailto',
                    path: obj.email,
                    query: 'subject=emails&body=',
                  );
                  if (obj.email.isEmpty) {
                    showSnackMessage(context, 'Email not provided');
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
                iconSize: 20.0,
                onPressed: () async {
                  String phoneNumber = obj.phone;
                  String message = "Hello, this is a test message.";
                  String url = "https://wa.me/+92$phoneNumber/?text=${Uri.parse(message)}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: const Icon(Icons.phone_android_sharp),
              )
            ],
          ),
        ),
      ),
    );
  }
}
