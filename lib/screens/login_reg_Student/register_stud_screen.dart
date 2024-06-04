import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:internshipgate/buttons/submit_button.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/login_stud_screen.dart';
import 'package:internshipgate/widgets/input_field.dart';
import '../../buttons/google_button.dart';
import '../../controllers/registration_stud_controller.dart';
import '../../google/google_sign_in_service.dart';
import '../../utils/api_endpoints.dart';
import '../navPages/dash_student.dart';


class StudentRegisterPage extends StatefulWidget {
  const StudentRegisterPage({Key? key}) : super(key: key);

  @override
  State<StudentRegisterPage> createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Studentgooglelogin(String email, name) async {
    try{
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}googleLogin'),
          body: {
            'email' : email,
            'name' : name,
          }
      );
      if(response.statusCode == 200 | 201) {
        var data = jsonDecode(response.body.toString());
        print(data);
        int id = data['id'];
        String token = data['token'];
        int applicantId = data['applicant_id'];
        Get.to(() => StudentDashboard(
          recId: id,
          tempEmail: email,
          fullname: name,
          stutoken: token,
          applicantId: applicantId,
        ));
        Get.snackbar(
          'Success',
          'Google signin Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    GoogleSignInAccount? googleUser = await _googleSignInService.signInWithGoogle();
    if (googleUser != null) {

      String name = googleUser.displayName ?? '';
      String email = googleUser.email;

      print('Name: $name');
      print('Email: $email');
      Studentgooglelogin(email, name);
    }
  }

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
                // const SizedBox(height: 40),
                // const RectangleTile(imagePath: 'lib/icons/logo.png'),

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
          'One Click Sign-up with google id',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(43, 43, 42, 0.766),
          ),
        ),
        const SizedBox(height: 10,),
        GoogleLoginButton(
          onPressed: () {
            _handleGoogleSignIn(context);// Handle Google login logic here
          },
        ),
        const SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[400],
              ),
            ),
            Text(
              ' Or ',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
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
          registrationController.nameController,
          'Full Name',
          Icons.person,
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          registrationController.emailController,
          'Email Address',
          Icons.email,
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          registrationController.mobileController,
          'Mobile Number',
          Icons.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          registrationController.passwordController,
          'Password',
          Icons.lock,
        ),
        const SizedBox(height: 20),
        
        // const Row(
        //   children: [
        //     Text(
        //       'By registering, you agree to our',
        //       style: TextStyle(
        //         fontSize: 13.0,
        //         fontWeight: FontWeight.normal,
        //         color: Color.fromRGBO(43, 43, 42, 0.766),
        //       ),
        //     ),
        //     Text(
        //       ' Terms and Conditions.',
        //       style: TextStyle(
        //         fontSize: 12.0,
        //         fontWeight: FontWeight.normal,
        //         color: Color.fromRGBO(44, 56, 149, 1),
        //       ),
        //     ),
        //   ],
        // ),
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
          onPressed: () => registrationController.registerWithEmail(),
          title: 'Register',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already a member?',
              style: TextStyle(color: Color.fromRGBO(43, 43, 42, 0.766)),
            ),
            // const SizedBox(width:2),
            TextButton(
              onPressed: () {
                Get.to( const StudentLoginScreen());
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color.fromRGBO(44, 56, 149, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
