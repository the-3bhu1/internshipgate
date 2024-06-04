import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internshipgate/buttons/submit_button.dart';
import 'package:internshipgate/controllers/registration_emp_controller.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/login_emp_screen.dart';
import 'package:internshipgate/widgets/input_field.dart';


class EmployerRegisterPage extends StatefulWidget {
  const EmployerRegisterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EmployerRegisterPageState createState() => _EmployerRegisterPageState();
}

class _EmployerRegisterPageState extends State<EmployerRegisterPage> {
  final EmployerRegistrationController employerRegistrationController =
      Get.put(EmployerRegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 5.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.offAll(
                () => const AuthPage()); // Use a callback to instantiate AuthScreen
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
                registerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const Text(
          'Create an account to continue ',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(43, 43, 42, 0.766),
          ),
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          employerRegistrationController.nameController,
          'Full Name',
          Icons.person,
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          employerRegistrationController.emailController,
          'Official Email Id',
          Icons.email,
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          employerRegistrationController.mobileController,
          'Mobile Number',
          Icons.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          employerRegistrationController.passwordController,
          'Password',
          Icons.lock,
        ),
       // const SizedBox(height: 20),
        // InputTextFieldWidget(
        //   employerRegistrationController.couponCodeController,
        //   'Coupon Code',
        //   Icons.confirmation_number,
      //  ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'By registering, you agree to our ',
                        style: TextStyle(color: const Color.fromRGBO(43, 43, 42, 0.766), fontSize: width * 0.032)
                    ),
                    TextSpan(
                        text: 'Terms and Conditions.',
                        style: TextStyle(color: const Color.fromRGBO(44, 56, 149, 1), fontSize: width * 0.032)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SubmitButton(
          onPressed: () => employerRegistrationController.registerEmployerWithEmail(),
          title: 'Register',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already a member?',
              style: TextStyle(color: Color.fromRGBO(43, 43, 42, 0.766)),
            ),
            TextButton(
              onPressed: () {
                Get.to(const EmployerLoginScreen());
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color.fromRGBO(44, 56, 149, 1),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

