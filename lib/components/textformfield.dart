import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final dynamic controller;
  final dynamic label;
  final bool obscureText;
  final dynamic prefixIcon;
  //final dynamic validator;
  //final dynamic autovalidateMode;

  const MyTextFormField (
      {
        super.key,
        required this.label,
        required this.controller,
        required this.obscureText,
        required this.prefixIcon,
        //required this.validator,
        //required this.autovalidateMode,
      }
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey.shade600,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey.shade600),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
        //validator: validator,
        //autovalidateMode: autovalidateMode,
      ),
    );
  }
}