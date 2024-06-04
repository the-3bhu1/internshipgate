import 'package:flutter/material.dart';

class EditTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? label;
  final String? Function(String?)? validator;

  const EditTextFieldWidget(TextEditingController titleController, {
    required this.textEditingController,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.label,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.only(top: 12.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 160, 159, 159)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(44, 56, 149, 1)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            icon,
            color: const Color.fromRGBO(79, 88, 153, 1),
          ),
        ),
      ),
    );
  }
}
