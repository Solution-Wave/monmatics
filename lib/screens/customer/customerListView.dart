import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/utils/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/colors.dart';
import '../../utils/messages.dart';
import 'customerExtendedView.dart';

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

  // void GetData()async{
  //   await GetToken();
  //   customerList.clear();
  //   setState(() {
  //     loading=true;
  //   });
  //   var result = await controller.getCustomer(token!);
  //   setState(() {
  //     if (result == 'Some error occured') {
  //       showSnackMessage(context, result);
  //     } else {
  //       print("result variable: $result");
  //       for (int i = 0; i < result.length; i++) {
  //         // Map<String, dynamic> obj = result[i];
  //         customer item = customer();
  //         item = customer.fromJson(result[i]);
  //         customerList.add(item);
  //       }
  //       loading = false;
  //     }
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
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
                            return CustomerListTile(obj: customer?.get(index));
                          },
                        );
                      } else {
                        return Center(child: Text('No Data Found'));
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
              )),
    );
  }
}

class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    super.key,
    required this.obj,
  });

  final obj;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext) => CustomerView(obj)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 7),
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: primaryColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: OverflowBar(
                  spacing: 20.0,
                  overflowSpacing: 10.0,
                  children: [
                    Text(obj['Name']),
                    Text(obj['Category']),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                      iconSize: 20.0,
                      onPressed: () async {
                        Uri phoneno = Uri.parse('tel:${obj['Phone']}');
                        if (obj['Phone'] == '') {
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
                      icon: Icon(Icons.phone)),
                  IconButton(
                      iconSize: 20.0,
                      onPressed: () async {
                        Uri mail = Uri(
                          scheme: 'mailto',
                          path: obj['Email'],
                          query: 'subject=emails&body=',
                        );
                        if (obj['Email'] == '') {
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
                      icon: Icon(Icons.mail)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchCustomer extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query.isEmpty ? close(context, null) : query = '';
          },
        )
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));

  List getResults(String query) {
    List results = [];
    int i = 0;
    //List tempList = model.data!;
    int len = customerList.length;

    for (i; i < len; i++) {
      if (customerList[i]['Name'].toLowerCase().contains(query.toLowerCase()) ||
          customerList[i]['Category']
              .toLowerCase()
              .contains(query.toLowerCase())) {
        results.add(customerList[i]);
      }
    }
    return results;
  }

  List getSuggestions(String query) {
    List suggestions = [];
    int i = 0;
    //List tempList = model.data!;
    int len = customerList.length;

    for (i; i < len; i++) {
      if (customerList[i]['Name'].toLowerCase().contains(query.toLowerCase()) ||
          customerList[i]['Category']
              .toLowerCase()
              .contains(query.toLowerCase())) {
        suggestions.add(customerList[i]);
      }
    }
    return suggestions;
  }

  @override
  Widget buildResults(BuildContext context) {
    List results = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return CustomerListTile(obj: results[index]);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return CustomerListTile(obj: suggestions[index]);
        });
  }
}
