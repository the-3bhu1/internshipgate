import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/utils/api_endpoints.dart';
import '../screens/auth_screen.dart';

class RegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();

  
  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('${ApiEndPoints.baseUrl}studentReg'); // Replace with your API endpoint
      Map body = {
        'fullname': nameController.text,
        'email': emailController.text.trim(),
        'mobileno': mobileController.text,
        'password': passwordController.text,
        'coupon_code': couponCodeController.text,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('Response Body: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Student_Registration_created') {
          // Handle successful registration
          Get.to(() => const AuthPage());
          Get.snackbar(
            'Success',
            'Email sent, please verify your account',
            snackPosition: SnackPosition.BOTTOM,
          );

          nameController.clear();
          emailController.clear();
          mobileController.clear();
          passwordController.clear();
          couponCodeController.clear();

          // Get.off(const StudHomeScreen());
        } else {
          // Handle other successful responses if needed
          // You can add specific logic here for different success responses
        }
      } else if (response.statusCode == 404) {
        // Handle validation errors
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          final message = responseData['message'];

          // Handle validation errors here
          // You can display validation error messages to the user.
          Get.snackbar(
            'Validation Error',
            'Registration failed: $message',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Handle other errors
        Get.snackbar(
          'Error',
          'Registration failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Network Error: $e');
      Get.back();
      Get.snackbar(
        'Error',
        'An unknown error occurred. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
