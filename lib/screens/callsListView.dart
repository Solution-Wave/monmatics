import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/models/callItem.dart';
import 'package:monmatics/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monmatics/utils/themes.dart';
import '../controllers/crmControllers.dart';
import '../utils/themes.dart';


List callsData= [];
class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
   String? token;
   Box? call;
   CallsRecord controller = CallsRecord();

   bool loading = false;


  Future getToken()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }
   Future<bool> getCallsRecord() async {
     call = await Hive.openBox<CallHive>('calls');
     setState(() {
     });
     return Future.value(true);
   }
   Future<bool> getList(){
     callsData.clear();
     List tempList = call!.values.toList();
     setState(() {
       for(var i in tempList)
       {
         callsData.add(i);
       }
     });
  return Future.value(true);
   }

  void openSearch()async{
  await getList();
  showSearch(
    context: context,
    delegate: SearchCalls(),
  );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Calls', style: headerTextStyle,),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                openSearch();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child:
          FutureBuilder(
              future: getCallsRecord(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (call!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: call!.length,
                      itemBuilder: (BuildContext, index) {
                        return CallsListTile(obj:call!.get(index));
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

          // loading ?
          //     Center(child: CircularProgressIndicator(color: primaryColor,))
          // :
          // ListView.builder(
          //     itemCount: callsData.length,
          //     itemBuilder: (BuildContext context, index){
          //      return CallsListTile(obj: callsData[index]);
          // }),
        )
      ),
    );
  }
}

class CallsListTile extends StatefulWidget {
  const CallsListTile({required this.obj,super.key});
  final  obj;

  @override
  State<CallsListTile> createState() => _CallsListTileState();
}

class _CallsListTileState extends State<CallsListTile> {
  bool _isExpanded=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryColor,
          expandedAlignment: Alignment.centerRight,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ) ,
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(widget.obj['Subject'], style: listViewTextStyle ,),
              ),
              Row(
                children: [
                  const Icon(Icons.av_timer),
                  Text(widget.obj['Date'], style: listViewTextStyle ,),

                ],
              )

            ],
          ),
          childrenPadding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 15.0,
            right: 15.0 ,
          ),
          trailing: Icon(
              _isExpanded?
              Icons.arrow_drop_up :
              Icons.arrow_drop_down
          ),
          onExpansionChanged: (bool val){
            setState(() {
              _isExpanded = val;
            });
          },
          children: [
            Row(
              children: [
                //Title's column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name', style: titleStyle,),
                    const SizedBox(height: 10.0,),

                    Text('Date',style: titleStyle,),
                    const SizedBox(height: 10.0,),
                    Text('Time',style: titleStyle,),
                    const SizedBox(height: 10.0,),
                    Text('Related To',style: titleStyle,),
                    const SizedBox(height: 10.0,),
                    Text('Status',style: titleStyle,),
                    const SizedBox(height: 10.0,),
                    Text('Description',style: titleStyle,),

                  ],
                ),
                const SizedBox(width: 15.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // callsData[index].ContactName
                    Text(widget.obj['ContactName'], style: normalStyle,),
                    const SizedBox(height: 10.0,),

                    Text(widget.obj['Date'], style: normalStyle,),
                    const SizedBox(height: 10.0,),
                    Text(widget.obj['Time'], style: normalStyle,),
                    const SizedBox(height: 10.0,),
                    Text(widget.obj['RelatedTo'], style: normalStyle,),
                    const SizedBox(height: 10.0,),
                    Text(widget.obj['Status'], style: normalStyle,),
                    const SizedBox(height: 10.0,),
                    Text(widget.obj['Description'],style: normalStyle,),


                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class SearchCalls extends SearchDelegate{
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
    int len = callsData.length;

    for (i; i < len; i++) {
      if (callsData[i]['Subject'].toLowerCase().contains(query.toLowerCase())
          || callsData[i]['Status'].toLowerCase().contains(query.toLowerCase())
          || callsData[i]['Date'].contains(query)
      ) {
        results.add(callsData[i]);
      }
    }
    return results;
  }

  List getSuggestions(String query) {
    List suggestions = [];
    int i = 0;
    //List tempList = model.data!;
    int len = callsData.length;

    for (i; i < len; i++) {
      if (callsData[i]['Subject'].toLowerCase().contains(query.toLowerCase())
          || callsData[i]['Status'].toLowerCase().contains(query.toLowerCase())
          || callsData[i]['Date'].contains(query)
      ) {
        suggestions.add(callsData[i]);
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
          return CallsListTile(obj:results[index]);
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder:(context, index){
          return CallsListTile(obj:suggestions[index]);
        }
    );
  }

}
