import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/navDrawer.dart';
import '../utils/colors.dart';
import '../utils/messages.dart';

List contactList = [];

class contactScreen extends StatefulWidget {
  const contactScreen({Key? key}) : super(key: key);

  @override
  State<contactScreen> createState() => _contactScreenState();
}

class _contactScreenState extends State<contactScreen>
    with TickerProviderStateMixin {
  Box? contacts;
  // void GetData() async {
  //   loading = true;
  //   contactList.clear();
  //   await GetToken();
  //   var result = await  controller.getData(token!);
  //   // print('contacts page: $result ');
  //   setState(() {
  //     if (result == 'Some error occured') {
  //       showSnackMessage(context, result);
  //     } else {
  //       for (int i = 0; i < result.length; i++) {
  //         Map<String, dynamic> obj = result[i];
  //         Contact item = Contact();
  //         item = Contact.fromJson(obj);
  //         contactList.add(item);
  //       }
  //       loading = false;
  //     }
  //   });
  // }

  Future<bool> GetContacts() async {
    contacts = await Hive.openBox('contacts');
    setState(() {

    });
    return Future.value(true);
  }
  Future<bool> getList(){
    contactList.clear();
    List tempList = contacts!.values.toList();
    setState((){
      for(var i in tempList)
      {
        contactList.add(i);
      }
    });
    // print(contactList);
    return Future.value(true);
  }
  void openSearch()async{
    await getList();
    showSearch(
      context: context,
      delegate: SearchContacts(),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
            Theme.of(context).brightness == Brightness.dark?'assets/White.jpeg':'assets/_Logo.png',
            height: MediaQuery.of(context).size.height*0.05
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: (){
              openSearch();
            },
          )
        ],
      ),
      drawer: navigationdrawer(),
      body: FutureBuilder(
          future: GetContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (contacts!.isNotEmpty) {
                return ListView.builder(
                  itemCount: contacts!.length,
                  itemBuilder: (BuildContext, index) {
                    return contactTileFormat(contacts!.get(index));
                  },
                );
              } else
                return Center(child: Text('No Data Found'));
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
          })

      // ListView.builder(
      //   shrinkWrap: true,
      //   itemCount: contactList.length,
      //   itemBuilder: (BuildContext, index) {
      //     return contactTileFormat(contactList[index]);
      //   },
      // ),
    );
  }
}

class contactTileFormat extends StatelessWidget {
  const contactTileFormat(
      this.obj,
  {
    super.key,
  });
final obj;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 05),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      obj['Name'],
                      style:
                          TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color:Theme.of(context).brightness == Brightness.light
                              ? socialIconColorLight
                              : socialIconColorDark,),
                    ),
                    Text(obj['phone'],
                        style: TextStyle(fontWeight: FontWeight.w300,),
                    ),
                    Text(
                      obj['Email'],
                      style: TextStyle(fontWeight: FontWeight.w300,),
                    )
                  ],
                ),
                Row(
                  children: [
                    //phone
                    GestureDetector(
                      onTap: () async {
                        Uri phoneno = Uri.parse('tel:${obj['phone']}');
                        if(obj['phone'] == '')
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
                      child: Icon(
                          Icons.phone,
                          size: MediaQuery.of(context).size.height * 0.02,
                          color:Theme.of(context).brightness == Brightness.light
                              ? socialIconColorLight
                              : socialIconColorDark
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    //mail
                    GestureDetector(
                      onTap: () async {
                        String email = obj['Email'];
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
                      child: Icon(
                          Icons.email_outlined,
                          size: MediaQuery.of(context).size.height * 0.02,
                          color:Theme.of(context).brightness == Brightness.light
                              ? socialIconColorLight
                              : socialIconColorDark
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        var contact = obj['phone'];
                        var url = 'sms:$contact';
                        // var androidUrl = "whatsapp://send?phone=$contact";
                        // var iosUrl ="https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";
                        if(contact == '')
                          {
                            showSnackMessage(context, 'No phone number found');
                          }
                        else
                          {
                            try
                            {
                              await launchUrl(
                                Uri.parse(url),
                                // mode: LaunchMode.externalApplication,
                              );
                            }on Exception{
                              showSnackMessage(context, 'Something went wrong');
                            }
                          }

                      },
                      child: Icon(
                        Icons.message,
                        size: MediaQuery.of(context).size.height * 0.02,
                          color:Theme.of(context).brightness == Brightness.light
                              ? socialIconColorLight
                              : socialIconColorDark
                      ),
                    ),




                  ],
                )

              ],
            ),
          ),

        ],
      ),
    );
  }
}

class SearchContacts extends SearchDelegate{

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
    int len = contactList .length;

    for (i; i < len; i++) {
      if (contactList[i]['Name'].toLowerCase().contains(query.toLowerCase())

      ) {
        results.add(contactList [i]);
      }
    }
    return results;
  }

  List getSuggestions(String query) {
    List suggestions = [];
    int i = 0;
    int len = contactList .length;

    for (i; i < len; i++) {
      if (contactList[i]['Name'].toLowerCase().contains(query.toLowerCase())

      ) {
        suggestions.add(contactList [i]);
      }
    }
    return suggestions;
  }

  @override
  Widget buildResults(BuildContext context) {
    List results = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: results.length,
        itemBuilder:(context, index){
          return contactTileFormat(results[index]);
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder:(context, index){
          return contactTileFormat(suggestions[index]);
        }
    );
  }

}
