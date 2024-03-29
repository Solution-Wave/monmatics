import 'package:flutter/material.dart';

import 'colors.dart';

// Custom TextFormField
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.nameController,
    required this.hintText,
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    required this.prefixIcon,
    this.maxLines,
    this.minLines,
  });

  final TextEditingController nameController;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final FormFieldValidator validator;
  final Icon prefixIcon;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// Custom Elevated Button
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.loading,
    required this.onPressed,
    required this.text,
  });

  final bool loading;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: popupmenuButtonCol,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 50.0)
        ),
        child: loading ? const SizedBox(
            height: 18.0,
            width: 18.0,
            child: CircularProgressIndicator()
        )
            : Text(text, style: const TextStyle(fontSize: 18.0),)
    );
  }
}

// Custom Custom Dropdown Button Form Field
class CustomDropdownButtonFormField extends StatelessWidget {
  const CustomDropdownButtonFormField({
    Key? key,
    required this.value,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.onChanged,
    required this.items,
    this.validator,
  }) : super(key: key);

  final String? value;
  final String hintText;
  final String labelText;
  final Icon prefixIcon;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: Text(hintText),
      borderRadius: BorderRadius.circular(20.0),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
