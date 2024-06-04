import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/forgot_stud_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/register_stud_screen.dart';
import 'package:internshipgate/widgets/splash_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../buttons/google_button.dart';
import '../../controllers/login_student_controller.dart';
import '../../google/google_sign_in_service.dart';
import '../../utils/api_endpoints.dart';
import '../../widgets/input_field.dart';
import '../../buttons/submit_button.dart';
import '../navPages/dash_student.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final StudentLoginController loginController = Get.put(StudentLoginController());
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Future<void> Studentgooglelogin(String email, name) async {
    try{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Retrieve user details from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String name = prefs.getString('name') ?? '';
      String email = prefs.getString('email') ?? '';
      int id = prefs.getInt('id') ?? 0;
      int applicantId = prefs.getInt('applicantId') ?? 0;
      String token = prefs.getString('token') ?? '';

      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}googleLogin'),
          body: {
            'email' : email,
            'name' : name,
          }
      );
      if(response.statusCode == 200 | 201) {
        Navigator.pop(context);
        //var data = jsonDecode(response.body.toString());
        //print(data);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('recId', id);
        prefs.setInt('applicantId', applicantId);
        prefs.setString('email', email);
        prefs.setString('name', name);
        prefs.setString('token', token);
        await StudentLoginController.saveUserLoggedInStatus(true);
        Get.to(() => StudentDashboard(
          recId: id,
          tempEmail: email,
          fullname: name,
          stutoken: token,
          applicantId: applicantId,
        ));
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

      // Save user details in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('email', email);

      // Save additional details in SharedPreferences
      final response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}googleLogin'),
          body: {
            'email' : email,
            'name' : name,
          }
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        int id = data['id'];
        int applicantId = data['applicant_id'];
        String token = data['token'];
        prefs.setInt('id', id);
        prefs.setInt('applicantId', applicantId);
        prefs.setString('token', token);
      }

      // Call the Studentgooglelogin method to navigate to the dashboard
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
                //  const SizedBox(height: 40),
                //  const RectangleTile(imagePath: 'lib/icons/logo.png'),
                const SizedBox(height: 5),
                studentLoginWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget studentLoginWidget() {
    return Column(
      children: [
        // const SizedBox(
        //   height: 20,
        // ),
        // const Row(
        //   // mainAxisAlignment: MainAxisAlignment.center,
        //   children: [

        //   ],
        // ),
        const SizedBox(
          height: 5,
        ),
        const SizedBox(
          width: 180,
          height: 180,
          child: SplashTile(imagePath: 'lib/images/login_pic.png'),
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          'Step into Your Account !',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(43, 43, 42, 0.766)),
        ),
        const SizedBox(height: 15,),
        GoogleLoginButton(
          onPressed: () {
            _handleGoogleSignIn(context);// Handle Google login logic here
          },
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey[400],
              ),
            ),
            Text(
              'Or ',
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
          height: 20,
        ),
        InputTextFieldWidget(
          loginController.emailController,
          'Student Email Id',
          Icons.email,
        ),
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          loginController.passwordController,
          'Password',
          Icons.lock,
          obscureText: true,
        ),
        const SizedBox(
          height: 10,
        ),
        // Forgot password?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.to(StudForgotPasswordScreen());
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
          onPressed: () => loginController.loginWithEmail(context),
          title: 'Login',
        ),
        const SizedBox(height: 10),

        // Not a student? Register now
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New to InternshipGate?',
              style: TextStyle(color: Color.fromRGBO(43, 43, 42, 0.766)),
            ),
            TextButton(
              onPressed: () {
                Get.to(const StudentRegisterPage());
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





