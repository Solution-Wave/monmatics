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
    // Get the theme from the context
    final theme = Theme.of(context);

    // Create a copy of the items list and add an empty option at the beginning
    List<DropdownMenuItem<String>> modifiedItems = [
      const DropdownMenuItem<String>(
        alignment: AlignmentDirectional.center,
        value: '',
        child: Text('Select an option'),
      ),
      ...items,
    ];

    // Check if the provided value matches any of the available items
    final validValue = items.any((item) => item.value == value) ? value : '';

    return DropdownButtonFormField<String>(
      value: validValue,
      hint: Text(hintText),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: theme.inputDecorationTheme.border?.borderSide.color ?? Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: modifiedItems,
      onChanged: onChanged,
      validator: validator,
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
    // Get the theme from the context
    final theme = Theme.of(context);

    return FutureBuilder<List<String>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the options to load
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Return an empty dropdown when there is an error
          return DropdownButtonFormField<String>(
            value: '',
            onChanged: onChanged,
            items: [],
            hint: Text(hintText),
            decoration: InputDecoration(
              labelText: labelText,
              prefixIcon: prefixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                      Colors.grey,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: theme.inputDecorationTheme.border?.borderSide.color ?? Colors.grey,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: validator,
          );
        } else if (snapshot.hasData) {
          // Data is available, use it to populate the dropdown
          final List<String> options = snapshot.data ?? [];
          // Add an empty option (e.g., "Select an option") to the options list
          if (!options.contains("")) {
            options.insert(0, ''); // Add an empty option at the start
          }

          // Check if the selected value matches any option, if not, set it to the empty option
          final validValue = options.contains(selectedValue) ? selectedValue : '';

          return DropdownButtonFormField<String>(
            value: validValue,
            onChanged: onChanged,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: value,
                child: Text(
                  value.isEmpty ? 'Select an option' : value,
                ),
              );
            }).toList(),
            hint: Text(hintText),
            decoration: InputDecoration(
              labelText: labelText,
              prefixIcon: prefixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: theme.inputDecorationTheme.border?.borderSide.color ?? Colors.grey,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            validator: validator,
          );
        }
        // Return an empty container if none of the above conditions are met
        return Container();
      },
    );
  }
}



