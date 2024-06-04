import 'package:flutter/material.dart';

class DateTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
   final Widget? suffixIcon;
  

  final String? label;

  const DateTextFieldWidget({
    required this.textEditingController,
    required this.hintText,
    this.suffixIcon,
    this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: textEditingController,
       
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
            suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}