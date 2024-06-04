import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/emp_dash.dart';
import 'package:internshipgate/screens/login_reg_Employer/forgot_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/home_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/register_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/login_stud_screen.dart';
import 'package:internshipgate/screens/navPages/dash_student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_reg_Student/register_stud_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetching data from SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int recId = prefs.getInt('recId') ?? 0;
  int applicantId = prefs.getInt('applicantId') ?? 0;
  String email = prefs.getString('email') ?? '';
  String name = prefs.getString('name') ?? '';
  String token = prefs.getString('token') ?? '';
  int erecId = prefs.getInt('erecId') ?? 0;
  String eemail = prefs.getString('eemail') ?? '';
  String ename = prefs.getString('ename') ?? '';
  String etoken = prefs.getString('etoken') ?? '';

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/auth', page: () => const AuthPage()),
        GetPage(name: '/register', page: () => const StudentRegisterPage()),
        GetPage(name: '/login', page: () => const StudentLoginScreen()),
        GetPage(name: '/empforgot', page: () => EmpForgotPasswordScreen()),
        GetPage(name: '/emphome', page: () => const EmpHomeScreen()),
        GetPage(name: '/empregister', page: () => const EmployerRegisterPage()),
        GetPage(
          name: '/dashboard',
          page: () => StudentDashboard(
            recId: recId,
            tempEmail: email,
            fullname: name,
            stutoken: token,
            applicantId: applicantId,
          ),
        ),
        GetPage(
          name: '/empdashboard',
          page: () => EmployeeDashboard(
            erecId: erecId,
            eemail: eemail,
            efullname: ename,
            eemptoken: etoken,
          ),
        ),
      ],
    ),
  );

  Future.delayed(const Duration(seconds: 2), () async {
    await checkLoginStatus();
  });
}

Future<void> checkLoginStatus() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  int recId = prefs.getInt('recId') ?? 0;
  int applicantId = prefs.getInt('applicantId') ?? 0;
  String email = prefs.getString('email') ?? '';
  String name = prefs.getString('name') ?? '';
  String token = prefs.getString('token') ?? '';
  int erecId = prefs.getInt('erecId') ?? 0;
  String eemail = prefs.getString('eemail') ?? '';
  String ename = prefs.getString('ename') ?? '';
  String etoken = prefs.getString('etoken') ?? '';

  if (recId != 0 && applicantId != 0 && email.isNotEmpty && name.isNotEmpty && token.isNotEmpty) {
    Get.offAllNamed('/dashboard', arguments: {
      'recId': recId,
      'tempEmail': email,
      'fullname': name,
      'emptoken': token,
      'applicantId': applicantId,
    });
  } else if (erecId != 0 && eemail.isNotEmpty && ename.isNotEmpty && etoken.isNotEmpty) {
    Get.offAllNamed('/empdashboard', arguments: {
      'erecId': erecId,
      'eemail': eemail,
      'efullname': ename,
      'eemptoken': etoken,
    });
  } else {
    Get.offAllNamed('/auth');
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'lib/images/logo_new.png',
          // height: height * 0.5,
          width: width * 1,
        ),
      ),
    );
  }
}
