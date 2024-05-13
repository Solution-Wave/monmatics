import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Functions/importFunctions.dart';
import '../../controllers/crmControllers.dart';
import '../../models/leadItem.dart';
import '../../utils/colors.dart';
import '../../utils/messages.dart';
import '../../utils/themes.dart';
import 'leadExtendedView.dart';
import 'leadForm.dart';

List leadsList = [];
class leadsScreen extends StatefulWidget {
  const leadsScreen({super.key});

  @override
  State<leadsScreen> createState() => _leadsScreenState();
}

class _leadsScreenState extends State<leadsScreen> {

 LeadController controller = LeadController();
 bool loading = false;
 String? token;
 Box? leadsBox;
  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

 Future<bool> GetDataFromBox()async{
   leadsBox = await Hive.openBox<LeadHive>('leads');
   setState(() {

   });
   return Future.value(true);
 }
 Future<bool> getList(){
    leadsList.clear();
    List tempList = leadsBox!.values.toList();
    setState(() {
      for(var i in tempList)
      {
        leadsList.add(i);
      }
    });
    return Future.value(true);
 }
 void openSearch()async{
    await getList();
    showSearch(
      context: context,
      delegate: SearchLeads(),
    );
 }

 ImportFunctions importFunctions = ImportFunctions();


  @override
  void initState() {
    // importFunctions.fetchLeadsFromApi();
    super.initState();
  }
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('Leads', style: headerTextStyle,),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: ()=>openSearch(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 8.0, left: 8.0),
        child:
         loading?
        Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        )
        :
        FutureBuilder(
            future: GetDataFromBox(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(leadsBox!.isNotEmpty)
                  {
                    return ListView.builder(
                      itemCount: leadsBox!.length,
                      // shrinkWrap: true,
                      itemBuilder: (BuildContext, index){
                        return LeadListTile( leadsBox!.get(index));
                      },
                    );
                  }
                else
                  return Center(child: Text('No Data Found'));
              }
              else
                {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
            }
            )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? popupmenuButtonCol
            : null,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddLead()));
        },
        child: const Icon(Icons.add,
        size: 40.0,),
      ),
    )
    );
  }
}

class LeadListTile extends StatelessWidget {
   LeadListTile(
      this.obj,
      {
    super.key,

  });

  var obj;

   void navigateToEditScreen(BuildContext context, LeadHive obj) {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => AddLead(existingLead: obj),
       ),
     );
   }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>LeadsScreen(
           obj
       )));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: primaryColor)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.6
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(obj.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(obj.category,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.all(2.0),
                    iconSize: 20.0,
                    onPressed: () async{
                      Uri phoneno = Uri.parse('tel:${obj.phone}');
                      if(obj.phone == '')
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
                    icon: const Icon(Icons.phone)),
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
                ),
                IconButton(
                  onPressed: () => navigateToEditScreen(context, obj),
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}

class SearchLeads  extends SearchDelegate{

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
    int len = leadsList.length;

    for (i; i < len; i++) {
      if (leadsList[i].name.toLowerCase().contains(query.toLowerCase()) || leadsList[i].category.toLowerCase().contains(query.toLowerCase())) {
        results.add(leadsList[i]);
      }
    }
    return results;
  }

  List getSuggestions(String query) {
    List suggestions = [];
    int i = 0;
    //List tempList = model.data!;
    int len = leadsList.length;

    for (i; i < len; i++) {
      if (leadsList[i].name.toLowerCase().contains(query.toLowerCase()) || leadsList[i].category.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(leadsList[i]);
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
          return LeadListTile(results[index]);
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder:(context, index){
        return LeadListTile(suggestions[index]);
      }
    );
  }

}