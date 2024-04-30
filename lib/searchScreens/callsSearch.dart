import 'package:flutter/material.dart';
import '../screens/calls/callsListView.dart';
import '../screens/calls/callsScreen.dart';


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
      if (callsData[i].subject.toLowerCase().contains(query.toLowerCase())
          || callsData[i].status.toLowerCase().contains(query.toLowerCase())
          || callsData[i].startDate.contains(query)
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
      if (callsData[i].subject.toLowerCase().contains(query.toLowerCase())
          || callsData[i].status.toLowerCase().contains(query.toLowerCase())
          || callsData[i].startDate.contains(query)
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