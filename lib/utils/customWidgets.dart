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
    this.onTap,
  });

  final TextEditingController nameController;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final FormFieldValidator validator;
  final Icon prefixIcon;
  final int? maxLines;
  final int? minLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      onTap: onTap,
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
    required this.onPressed,
    required this.padding,
    required this.child,
  });

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: padding,
        ),
        child: child,
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


// AsyncDropdownButton
class AsyncDropdownButton extends StatelessWidget {
  final Future<List<String>> futureItems;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String hintText;
  final String labelText;
  final Widget prefixIcon;
  final FormFieldValidator<String>? validator;

  AsyncDropdownButton({
    required this.futureItems,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the options to load
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Return an error message if an error occurred while loading options
          return const Text('Failed to load options');
        } else if (snapshot.hasData) {
          // When data is available, use it to populate the dropdown
          final options = snapshot.data!;
          return DropdownButtonFormField<String>(
            value: selectedValue,
            onChanged: onChanged,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text(hintText),
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
            validator: validator,
          );
        }
        return Container();
      },
    );
  }
}

