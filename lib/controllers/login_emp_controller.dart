import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/screens/login_reg_Employer/emp_dash.dart';
import 'package:internshipgate/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmpLoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

RxString successMessage = ''.obs;
RxString errorMessage = ''.obs;

  static Future<void> saveUserLoggedInStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

Future<void> emploginWithEmail(BuildContext context) async {
  var headers = {'Content-Type': 'application/json'};
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.empLogin);

    Map body = {
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);

    //print('Response status code: ${response.statusCode}');
    //print('Response body: ${response.body}');

    final Map<String, dynamic> json = jsonDecode(response.body);

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   if (json['success'] == true) {
    //     // Handle successful login
    //     var token = json['token'];

    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
    //     await prefs.setString('token', token);
    Navigator.pop(context);
 if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        int text = data['id'];
        String fname = data['fullname'];
        String emai = data['email'];
        String tokenemp = data['token'];
          Get.snackbar(
            'Success',
            'Logged in successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        emailController.clear();
        passwordController.clear();

        // Use RxString variables to update successMessage
        successMessage.value = 'Logged in successfully';

        // Clear any previous error message
        errorMessage.value = '';

        // Use Get.off to navigate to the HomeScreen
        // Get.to(const HomeScreen());
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmployeeDashboard(recId: text,email: emai,fullname: fname,emptoken: tokenemp,)));
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('erecId', text);
          prefs.setString('eemail', emai);
          prefs.setString('ename', fname);
          prefs.setString('etoken', tokenemp);
          await EmpLoginController.saveUserLoggedInStatus(true);
          Get.to(() => EmployeeDashboard(erecId: text, eemail: emai, efullname: fname, eemptoken: tokenemp));
      } else {
          errorMessage.value = json['message'] ?? 'Unknown Error Occurred';
          Get.snackbar(
            'Failed',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
          );
          // Clear any previous success message
          successMessage.value = '';
      }
  } catch (error) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Error'),
          contentPadding: const EdgeInsets.all(20),
          children: [Text(error.toString())],
        );
      },
    );
  }
}
}
