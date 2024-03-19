import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/themes.dart';




class inputCard extends StatelessWidget {
  inputCard(this.hint, this.ICON, this.Validate, this.conTroller);
  final String hint;
  final Icon ICON;

  final String? Function(String?) Validate;
  final conTroller;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextFormField(
        style: TextStyle(decoration: TextDecoration.none, color: primaryColor),
        controller: conTroller,
        decoration: formTextBoxStyle.copyWith(
          suffixIcon: ICON,
          hintText: hint,
        ),
        cursorColor: primaryColor,
        focusNode: _focusNode,
        //onChanged: onChange,
        validator: (value) {
          if (_focusNode.hasFocus) {
            return null;
          } else {
            return Validate.call(value);
          }
        },
      ),
    );
  }
}
