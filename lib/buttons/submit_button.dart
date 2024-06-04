// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const SubmitButton( {Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return IntrinsicHeight(
      child: IntrinsicWidth(
        child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(44, 56, 149, 1),
                )),
            onPressed: onPressed,
            child: Text(title,
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ))),
      ),
    );
  }
}