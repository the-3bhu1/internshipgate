import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  final Function onPressed;

  const GoogleLoginButton({super.key,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.0,
      height: 50.0,
      child: Container(decoration: BoxDecoration(
          border: Border.all(
            color:  const Color.fromARGB(255, 142, 136, 136), // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          onPressed: () {
            onPressed();
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 254), // Background color
            foregroundColor: const Color.fromARGB(255, 75, 74, 74), // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/images/google.jpg', 
                height: 25.0,
                width: 35.0, 
              ),
              
              const Text(
                '  Login with Google',
                style: TextStyle(
                  fontSize: 16.0,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









