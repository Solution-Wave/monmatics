
import 'package:flutter/material.dart';

import 'colors.dart';

AppBarTheme monmaticsAppBar = AppBarTheme(
    //color: primaryColor,
  elevation: 0.8,
    centerTitle: true,
    iconTheme: IconThemeData(
        color: primaryColor
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      color: Colors.white,
    )
);


InputDecoration formTextBoxStyle = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  errorStyle: TextStyle(height: 0.0, fontSize: 7),
  hintStyle: TextStyle(
    fontSize: 15,
    fontStyle: FontStyle.italic,
    color: Color(0xFF90A17D)
  ),
  hoverColor: Colors.grey[350],
  focusColor: Colors.grey[350],
  filled: true,
  fillColor: Colors.grey[200],
  constraints: BoxConstraints(maxHeight: 60.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
    borderSide:
    BorderSide(style: BorderStyle.none, width: 0.0),
  ),
);

 TextStyle titleStyle  = TextStyle(
fontSize: 16.0,
fontWeight: FontWeight.w700,
color: primaryColor
);
TextStyle normalStyle = TextStyle(
fontSize: 16.0,

);

TextStyle headerTextStyle  = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: primaryColor
);

TextStyle listViewTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400);

BoxDecoration ExpandedViewDecor = BoxDecoration(
  borderRadius: BorderRadius.circular(20.0),
  color:  Colors.lightBlue[100]?.withOpacity(0.3),
);