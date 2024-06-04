import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/utils/api_endpoints.dart';

class EmployerRegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerEmployerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmployerWithEmail);
      Map body = {
        'fullname': nameController.text,
        'email': emailController.text.trim(),
        'mobileno': mobileController.text,
        'password': passwordController.text,
      };

      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      print('Response Body: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Employer Registration created') {
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
        } else {
          // Handle other successful responses if needed
          // You can add specific logic here for different success responses
        }
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        if (responseData['success'] == false) {
          if (responseData['message']['email'] != null) {
            // Handle the email field validation error
            Get.snackbar(
              'Validation Error',
              '${responseData['message']['email'][0]}',
              snackPosition: SnackPosition.BOTTOM,
            );
          }

          if (responseData['message']['password'] != null) {
            // Handle the password field validation error
            Get.snackbar(
              'Validation Error',
              'Password is required: ${responseData['message']['password'][0]}',
              snackPosition: SnackPosition.BOTTOM,
            );
          }

          // Handle other possible validation errors for different fields here
        } else {
          // Handle other validation errors or general 404 errors
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
