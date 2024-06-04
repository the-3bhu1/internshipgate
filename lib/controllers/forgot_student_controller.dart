import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import '../utils/api_endpoints.dart';

class StudForgotPasswordController extends GetxController {
    TextEditingController emailController = TextEditingController();
  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text;
    const apiUrl = '${ApiEndPoints.baseUrl}studentFpass/https,staging-dev.internshipgate.com,public,api';

    final requestBody = jsonEncode({'email': email});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200|| response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        
        if (message == 'Mail Sent') {
          Get.snackbar(
          'Sent Successfully',
          'Check your Registered Email',
          snackPosition: SnackPosition.BOTTOM,
          );
         
          print('Password reset email sent successfully');
        } if(message== "Email not registered") {
          Get.snackbar(
          'Error',
          'Email not registered',
          snackPosition: SnackPosition.BOTTOM,
        );
         
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed',
          snackPosition: SnackPosition.BOTTOM,
        );
       
        // print('Failed to send password reset email');
      }
    } catch (error) {
      print('Error: $error');
      Get.back();
      Get.snackbar(
        'Error',
        'An unknown error occurred. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
