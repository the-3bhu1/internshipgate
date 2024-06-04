import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internshipgate/buttons/submit_button.dart';
import 'package:internshipgate/controllers/login_emp_controller.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/forgot_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/register_emp_screen.dart';
import 'package:internshipgate/widgets/input_field.dart';
import 'package:internshipgate/widgets/splash_tile.dart';



class EmployerLoginScreen extends StatefulWidget {
  const EmployerLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmployerLoginScreen> createState() => _EmployerLoginScreenState();
}

class _EmployerLoginScreenState extends State<EmployerLoginScreen> {
  final EmpLoginController empLoginController = Get.put(EmpLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 5.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.offAll(() =>
                const AuthPage()); // Use a callback to instantiate AuthScreen
          },
          child: Image.asset(
            'lib/icons/logo.png',
            height: 120.0,
            width: 180.0,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                loginWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          width: 259,
          height: 200,
          child: SplashTile(imagePath: 'lib/images/emplogin.png'),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Step into Your Account !',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(43, 43, 42, 0.766)),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: 330,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InputTextFieldWidget(
            empLoginController.emailController,
            'Official Email Id',
            Icons.email,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: 330,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InputTextFieldWidget(
            empLoginController.passwordController,
            'Password',
            Icons.lock,
            obscureText: true,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.to(EmpForgotPasswordScreen());
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(44, 56, 149, 1)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SubmitButton(
          onPressed: () => empLoginController.emploginWithEmail(context),
          title: 'Login',
        ),
        const SizedBox(height: 13),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Not a member?',
              style: TextStyle(color: Color.fromRGBO(43, 43, 42, 0.766)),
            ),
            MaterialButton(
              onPressed: () {
                Get.to(const EmployerRegisterPage());
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Color.fromRGBO(44, 56, 149, 1)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
