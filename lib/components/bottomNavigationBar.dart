// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
//
// class BottomNavigation extends StatefulWidget {
//   BottomNavigation({
//    required this.onSelectTab,
//    required this.tabs,
//   });
//   final ValueChanged<int> onSelectTab;
//   final List<TabItem> tabs;
//
//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }
//
// class _BottomNavigationState extends State<BottomNavigation> {
//   int selectedIndex =0;
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: selectedIndex,
//       backgroundColor: Theme.of(context).brightness == Brightness.dark
//           ? darkThemeDrawerColor
//           : null,
//       selectedItemColor: Color(0xFF0C76FF),
//       // Theme.of(context).brightness == Brightness.light
//       //     ?
//       //     : null,
//       type: BottomNavigationBarType.fixed,
//       items: widget.tabs
//           .map(
//             (e) => _buildItem(
//           index: e.getIndex(),
//           icon: e.icon,
//           tabName: e.tabName,
//         ),
//       )
//           .toList(),
//       onTap: (index){
//         setState(() {
//           selectedIndex = index;
//           widget.onSelectTab(
//               index
//           );
//         });
//       }
//           ,
//     );
//   }
//
//   BottomNavigationBarItem _buildItem(
//       {required int index,required IconData icon,required String tabName}) {
//     return BottomNavigationBarItem(
//       icon: Icon(
//         icon,
//         //color: _tabColor(index: index),
//       ),
//        label: tabName
//     //Text(
//       //   tabName,
//       //   style: TextStyle(
//       //     color: _tabColor(index: index),
//       //     fontSize: 12,
//       //   ),
//       // ),
//     );
//   }
// }