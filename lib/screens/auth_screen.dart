import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:internshipgate/buttons/auth_button.dart';
import 'package:internshipgate/buttons/button_employer.dart';
import 'package:internshipgate/buttons/button_student.dart';
import 'package:internshipgate/screens/auth_search.dart';
import 'package:internshipgate/screens/login_reg_Employer/login_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/register_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/login_stud_screen.dart';
import '../utils/api_endpoints.dart';
import 'login_reg_Student/register_stud_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  List<Map<String, String>> items = [];
  String? selectedCities;

  void loginAsStudent(BuildContext context) {
    Get.to(() => const StudentLoginScreen());
  }

  void loginAsEmployer(BuildContext context) {
    // Get.to(const EmployerLoginScreen());
  }

  @override
  void initState() {
    super.initState();
    cities();
  }

  Future<void> cities() async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getLocationMasterDetails'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          items = data.map<Map<String, String>>((item) => {
            'value': item['value'].toString(),
            'label': item['label'].toString(),
          }).toList();
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> showLoginOptionsDialog(BuildContext context) async {
    var height = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.02),
                    StudentDialogButton(
                      title: "Student",
                      onPressed: () {
                        Navigator.of(context).pop();
                        loginAsStudent(context);
                      },
                    ),
                    SizedBox(height: height * 0.015),
                    EmployerDialogButton(
                      title: "Employer",
                      onPressed: () {
                        Get.to(() => const EmployerLoginScreen());
                      },
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showRegisterOptionsDialog(BuildContext context) async {
    var height = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.02),
                    StudentDialogButton(
                      title: "Student",
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.to(() => const StudentRegisterPage());
                      },
                    ),
                    SizedBox(height: height * 0.015),
                    EmployerDialogButton(
                      title: "Employer",
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.to(() => const EmployerRegisterPage());
                      },
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Image.asset(
          'lib/icons/logo.png',
          height: height * 0.5,
          width: width * 0.5,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      body: Stack(
        children: [
          Center(
            child: Image(
              image: const AssetImage('lib/assets/auth_bg2.png'),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.01),
                    const Center(
                      child: Text(
                        'Find dream internship that you love to do. ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    const Center(
                      child: Text(
                        'Join the Virtual Internship Program in Emerging Technologies with our Winter Internship Offer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.4,
                      height: height * 0.455,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 12.0,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(44, 56, 149, 1),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'e.g. Web Development, Mobile...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(44, 56, 149, 1),
                                ),
                                onPressed: () {
                                  if (searchController.text.isNotEmpty) {
                                    //fetchDataWithFilters();
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.85,
                            height: height * 0.05,
                            child: OutlinedButton(
                                onPressed: () {
                                  String searchText = searchController.text.isEmpty ? 'all' : searchController.text;
                                  Get.to(() => AuthSearch(searchText: searchText));
                                },
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                                ),
                                child: const Text("Search", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AuthButton(
                          title: 'Log In',
                          onPressed: () {
                            showLoginOptionsDialog(context);
                          },
                        ),
                        SizedBox(width: width * 0.05),
                        AuthButton(
                          title: 'Register',
                          onPressed: () {
                            showRegisterOptionsDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
