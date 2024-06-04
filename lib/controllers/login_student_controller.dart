import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/screens/navPages/dash_student.dart';
import 'package:internshipgate/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StudentLoginController extends GetxController {
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

  Future<void> loginWithEmail(BuildContext context) async {
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
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      //print('Response status code: ${response.statusCode}');
      //print('Response body: ${response.body}');

      final Map<String, dynamic> json = jsonDecode(response.body);

      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'logged-in') {
          int text = responseData['id'];
          int applicantId = responseData['applicant_id'];
          String name = responseData['fullname'] ?? '';
          String emai = emailController.text.toString();
          String tokenemp = responseData['token'] ?? '';

          // Handle successful registration
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
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentDashboard(recId: text,email: emai,fullname: name,emptoken: tokenemp,)));
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('recId', text);
          prefs.setInt('applicantId', applicantId);
          prefs.setString('email', emai);
          prefs.setString('name', name);
          prefs.setString('token', tokenemp);

          // Save user login status
          await StudentLoginController.saveUserLoggedInStatus(true);

          // Navigate to dashboard
          Get.to(() =>
              StudentDashboard(
                recId: text,
                tempEmail: emai,
                fullname: name,
                stutoken: tokenemp,
                applicantId: applicantId,
              ));
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
