

// import 'package:flutter/material.dart';

// class InputTextFieldWidget extends StatelessWidget {
//   final dynamic controller;
//   final String hintText;
//   final IconData icon;
//   final bool obscureText;
//   final dynamic validator;
//   final dynamic autovalidateMode;

//  const InputTextFieldWidget( this.controller, this.hintText,
//   this.validator, this.autovalidateMode,
//  this.icon,{this.obscureText = false, Key? key}) : super(key:key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 46,
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.only(top: 12.0),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Color.fromARGB(255, 160, 159, 159)),
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Color.fromRGBO(44, 56, 149, 1)),
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//           fillColor: const Color.fromARGB(255, 255, 255, 255),
//           filled: true,
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey[500]),
//           prefixIcon: Icon(
//             icon,
//             color: const Color.fromRGBO(
//                 79, 88, 153, 1), // Customize the icon color
//           ),
//           validator: validator,
//         autovalidateMode: autovalidateMode,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;

  const InputTextFieldWidget(this.textEditingController, this.hintText,
      this.icon, {this.obscureText = false, this.inputFormatters = const [], Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: textEditingController,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
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
            color: const Color.fromRGBO(
                79, 88, 153, 1), // Customize the icon color
          ),
        ),
      ),
    );
  }
}