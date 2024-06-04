import 'package:flutter/material.dart';


// ignore: must_be_immutable
class ChatTextFieldWidget extends StatelessWidget {
  // final TextEditingController textEditingController;
  //  final String hintText;
  // final IconData icon;
  // bool obscureText;
  

    const ChatTextFieldWidget( {super.key, required String hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 46,
      child: TextField(
        // controller: textEditingController,
        // obscureText: obscureText,
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
          // hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          // prefixIcon: Icon(
          //   icon,
          //   color:const  Color.fromRGBO(79, 88, 153, 1), // Customize the icon color
          // ),
          
        ),
      ),
    );
  }
  
  
}