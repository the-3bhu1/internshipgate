import 'package:flutter/material.dart';

class StudentDialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const StudentDialogButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return IntrinsicHeight(
      child: Container(
        width: width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.25),
              offset: const Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 1,
            )
          ],
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide.none,
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(44, 56, 149, 1),
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(31, 40, 109, 1), // Change to the color you desire when pressed
            ),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              Icon(
                Icons.school,
                size: width * 0.045,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
