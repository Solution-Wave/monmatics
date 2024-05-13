import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Functions/importFunctions.dart';
import '../../components/navDrawer.dart';
import '../../models/contactItem.dart';
import '../../searchScreens/contactsSearch.dart';
import '../../utils/colors.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import 'contactsForm.dart';

List contactList = [];

class contactScreen extends StatefulWidget {
  const contactScreen({Key? key}) : super(key: key);

  @override
  State<contactScreen> createState() => _contactScreenState();
}

class _contactScreenState extends State<contactScreen>
    with TickerProviderStateMixin {
  Box? contactsBox;


  Future<bool> GetContacts() async {
    contactsBox = await Hive.openBox<ContactHive>('contacts');
    setState(() {});
    return Future.value(true);
  }


  Future<bool> getList(){
    contactList.clear();
    List tempList = contactsBox!.values.toList();
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

  ImportFunctions importFunctions = ImportFunctions();

  @override
  void initState() {
    super.initState();
    // importFunctions.fetchContactsFromApi();
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
              if (contactsBox!.isNotEmpty) {
                return ListView.builder(
                  itemCount: contactsBox!.length,
                  itemBuilder: (BuildContext, index) {
                    return ContactTileFormat(contactsBox!.get(index));
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
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? popupmenuButtonCol
            : null,
        onPressed: () async{
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddContact()));
        },
        child: const Icon(Icons.add,
          size: 40.0,),
      ),
    );
  }
}

class ContactTileFormat extends StatefulWidget {
  const ContactTileFormat(
      this.obj, {
        Key? key,
      }) : super(key: key);

  final ContactHive obj;

  @override
  State<ContactTileFormat> createState() => _ContactTileFormatState();
}

class _ContactTileFormatState extends State<ContactTileFormat> {
  void navigateToEditScreen(BuildContext context, ContactHive obj) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContact(existingContact: obj),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add null check to handle null objects
    if (widget.obj == null) {
      return SizedBox(); // Return an empty widget if obj is null
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        // margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.obj.fName} ${widget.obj.lName}" ?? "",
                      style: listViewTextStyle,
                  ),
                  Text(
                    widget.obj.phone ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    widget.obj.email ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 20.0,
                    onPressed: () async {
                      Uri phoneno = Uri.parse('tel:${widget.obj.phone}');
                      if (widget.obj.phone == null || widget.obj.phone.isEmpty) {
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
                      String phoneNumber = widget.obj.phone ?? '';
                      String message = "Hello, this is a test message.";
                      String url = "https://wa.me/+92$phoneNumber/?text=${Uri.parse(message)}";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    icon: const Icon(Icons.phone_android_sharp),
                  ),
                  IconButton(
                    iconSize: 20.0,
                    color: Colors.blueAccent,
                    onPressed: ()=> navigateToEditScreen(context, widget.obj),
                    icon: const Icon(Icons.edit),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}