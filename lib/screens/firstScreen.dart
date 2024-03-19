import 'package:flutter/material.dart';
import 'package:monmatics/models/tabItem.dart';
import '../components/bottomNavigationBar.dart';
import 'additionalOptionsScreen.dart';
import 'contactsScreen.dart';
import 'homeScreen.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Home",
      icon: Icons.home,
      page: Home(),
    ),
    TabItem(
      tabName: "Contacts",
      icon: Icons.phone_enabled_outlined,
      page: contactScreen(),
    ),
    TabItem(
      tabName: "More",
      icon: Icons.menu,
      page: AdditionalInfoScreen(),
    ),
  ];

  AppState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState?.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        // final isFirstRouteInCurrentTab =
        // !await tabs[currentTab].key.currentState!.maybePop();
        // if (isFirstRouteInCurrentTab) {
        //   // if not on the 'main' tab
        //   if (currentTab != 0) {
        //     // select 'main' tab
        //     _selectTab(0);
        //     // back button handled by app
        //     return false;
        //   }
        // }
        return await showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Are You Sure?'),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.of(context).pop(true);
                  }, child: Text('Yes')),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop(false);
                    // Navigator.pop(context);
                    }, child: Text('No'))
                ],
              );
            });
      },

      child: SafeArea(
        child: Scaffold(
          // indexed stack shows only one child
          body: IndexedStack(
            index: currentTab,
            children: tabs.map((e) => e.page).toList(),
          ),
          // Bottom navigation
          bottomNavigationBar: BottomNavigation(
            onSelectTab: _selectTab,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}