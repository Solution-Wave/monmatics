import 'package:flutter/material.dart';
import '../screens/contacts/contactsScreen.dart';

class SearchContacts extends SearchDelegate{

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
    int len = contactList .length;

    for (i; i < len; i++) {
      if (contactList[i].fName.toLowerCase().contains(query.toLowerCase())

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
      if (contactList[i].fName.toLowerCase().contains(query.toLowerCase())

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
          return ContactTileFormat(results[index]);
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder:(context, index){
          return ContactTileFormat(suggestions[index]);
        }
    );
  }

}