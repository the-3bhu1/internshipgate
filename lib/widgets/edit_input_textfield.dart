import 'package:flutter/material.dart';

class EditInputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;

  final String? label;

  const EditInputTextFieldWidget({
    required this.textEditingController,
    required this.hintText,
    required this.icon,
 
    this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.06,
      child: TextFormField(
        controller: textEditingController,
       
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
