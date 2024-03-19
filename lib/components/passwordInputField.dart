import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/themes.dart';



class passwordInputCard extends StatelessWidget {
  passwordInputCard(this.showpassword, this.hint, this.IconChange,
      this.Validate, this.conTroller);
  final bool showpassword;
  final String hint;
  final Function() IconChange;

  final String? Function(String?) Validate;
  final conTroller;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextFormField(
        style: TextStyle(color: primaryColor),
        obscureText: showpassword,
        decoration: formTextBoxStyle.copyWith(
          suffixIcon: IconButton(
            icon: showpassword?Icon(Icons.visibility_off, color: primaryColor,):Icon(Icons.visibility, color: primaryColor,),
            onPressed: IconChange,
          ),
          hintText: hint,
        ),
        cursorColor: primaryColor,
        focusNode: _focusNode,
       controller: conTroller,
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
