
import 'package:flutter/material.dart';

import 'colors.dart';

AppBarTheme monmaticsAppBar = AppBarTheme(
    //color: primaryColor,
  elevation: 0.8,
    centerTitle: true,
    iconTheme: IconThemeData(
        color: primaryColor
    ),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      color: Colors.white,
        overflow: TextOverflow.ellipsis
    )
);


InputDecoration formTextBoxStyle = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  errorStyle: const TextStyle(height: 0.0, fontSize: 7),
  hintStyle: const TextStyle(
    fontSize: 15,
    fontStyle: FontStyle.italic,
    color: Color(0xFF90A17D),
      overflow: TextOverflow.ellipsis
  ),
  hoverColor: Colors.grey[350],
  focusColor: Colors.grey[350],
  filled: true,
  fillColor: Colors.grey[200],
  constraints: const BoxConstraints(maxHeight: 60.0),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
    borderSide:
    BorderSide(style: BorderStyle.none, width: 0.0),
  ),
);

 TextStyle titleStyle  = TextStyle(
fontSize: 16.0,
fontWeight: FontWeight.w700,
     overflow: TextOverflow.ellipsis,
color: primaryColor
);
TextStyle normalStyle = const TextStyle(
fontSize: 16.0,
overflow: TextOverflow.ellipsis
);

TextStyle normalStyle1 = const TextStyle(
    fontSize: 16.0,
);

TextStyle headerTextStyle  = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: primaryColor
);

TextStyle listViewTextStyle = const TextStyle(
    fontSize: 15,
    overflow: TextOverflow.ellipsis,
    fontWeight: FontWeight.bold);

BoxDecoration ExpandedViewDecor = BoxDecoration(
  borderRadius: BorderRadius.circular(20.0),
  color:  Colors.lightBlue[100]?.withOpacity(0.3),
);