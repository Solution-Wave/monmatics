import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/crmControllers.dart';
import '../../models/opportunityItem.dart';
import '../../utils/colors.dart';
import '../../utils/themes.dart';
import 'opportunityExtendedView.dart';
import 'opportunityForm.dart';

List opportunityList = [];
class opporScreen extends StatefulWidget {
  const opporScreen({super.key});

  @override
  State<opporScreen> createState() => _opporScreenState();
}

class _opporScreenState extends State<opporScreen> {

  LeadController controller = LeadController();
  bool loading = false;
  String? token;
  Box? opportunityBox;
  Future GetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<bool> GetDataFromBox()async{
    opportunityBox = await Hive.openBox<OpportunityHive>('opportunity');
    setState(() {

    });
    return Future.value(true);
  }
  Future<bool> getList(){
    opportunityList.clear();
    List tempList = opportunityBox!.values.toList();
    setState(() {
      for(var i in tempList)
      {
        opportunityList.add(i);
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

  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('Opportunity', style: headerTextStyle,),
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
                  if(opportunityBox!.isNotEmpty)
                  {
                    return ListView.builder(
                      itemCount: opportunityBox!.length,
                      // shrinkWrap: true,
                      itemBuilder: (BuildContext, index){
                        return OpportunityListTile( opportunityBox!.get(index));
                      },
                    );
                  }
                  else {
                    return const Center(child: Text('No Data Found'));
                  }
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddOpportunity()));
        },
        child: const Icon(Icons.add,
          size: 40.0,),
      ),
    )
    );
  }
}

class OpportunityListTile extends StatelessWidget {
  OpportunityListTile(
      this.obj,
      {super.key});
  final OpportunityHive obj;

  void navigateToEditScreen(BuildContext context, OpportunityHive obj) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOpportunity(existingOpportunity: obj),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext) =>
            OpportunityExtendedScreen(obj)));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      obj.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      obj.stage,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      obj.closeDate,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => navigateToEditScreen(context, obj),
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SearchLeads  extends SearchDelegate{

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query.isEmpty ? close(context, null) : query = '';
      },
    )
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  List getResults(String query) {
    List results = [];
    int i = 0;
    //List tempList = model.data!;
    int len = opportunityList.length;

    for (i; i < len; i++) {
      if (opportunityList[i].name.toLowerCase().contains(query.toLowerCase()) ||
          opportunityList[i].category.toLowerCase().contains(query.toLowerCase())) {
        results.add(opportunityList[i]);
      }
    }
    return results;
  }

  List getSuggestions(String query) {
    List suggestions = [];
    int i = 0;
    //List tempList = model.data!;
    int len = opportunityList.length;

    for (i; i < len; i++) {
      if (opportunityList[i].name.toLowerCase().contains(query.toLowerCase()) ||
          opportunityList[i].category.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(opportunityList[i]);
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
          return OpportunityListTile(results[index]);
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder:(context, index){
          return OpportunityListTile(suggestions[index]);
        }
    );
  }

}