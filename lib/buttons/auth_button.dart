// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const AuthButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return IntrinsicHeight(
      child: Container(
        width: width * 0.35,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.25),
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 1)
        ]),
        child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none)),
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                    (states) {
                  if (states.contains(MaterialState.pressed)) {
                    // Color when button is pressed
                    return BorderSide(color: const Color.fromRGBO(249, 143, 67, 1), width: 2);
                  }
                  // Default color when button is not pressed
                  return BorderSide(color: const Color.fromRGBO(249, 143, 67, 1), width: 2);
                },
              ),
                ),
            onPressed: onPressed,
            child: Text(title,
                style: TextStyle(
                  fontSize: width * 0.05,
                  color: Color.fromRGBO(249, 143, 67, 1),
                  fontWeight: FontWeight.w600,
                ))),
      ),
    );
  }
}