import 'package:flutter/material.dart';

class EntityNameTextInput extends StatelessWidget {
  const EntityNameTextInput({
    super.key,
    required TextEditingController nameInput,
    required this.isValid, required this.isValidMessage,
  }) : _nameInput = nameInput;

  final TextEditingController _nameInput;
  final bool Function(String) isValid;
  final String isValidMessage;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameInput,
      decoration: const InputDecoration(
        hintText: 'Name',
      ),
      style: const TextStyle(color: Colors.white),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (!isValid(value)) {
          return isValidMessage;
        }

        return null;
      },
    );
  }
}
