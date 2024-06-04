import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internshipgate/buttons/submit_button.dart';
import 'package:internshipgate/controllers/forgot_student_controller.dart';
import 'package:internshipgate/widgets/input_field.dart';
import 'package:internshipgate/widgets/splash_tile.dart';

class StudForgotPasswordScreen extends StatelessWidget {
  final StudForgotPasswordController forgotPasswordController =
      Get.put(StudForgotPasswordController());

  StudForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const SizedBox(
                    width: 250,
                    height: 250,
                    child: SplashTile(imagePath: 'lib/images/forgot_pic.png')),
                const Text(
                  'Enter your email to reset your password',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(43, 43, 42, 0.766)),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 330,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InputTextFieldWidget(
                      forgotPasswordController.emailController,
                      'Email',
                      Icons.email),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: SubmitButton(
                    onPressed: () {
                      forgotPasswordController.sendPasswordResetEmail();
                    },
                    title: 'Reset Password',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
