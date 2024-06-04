import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/widgets/splash_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpHomeScreen extends StatefulWidget {
  const EmpHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmpHomeScreen> createState() => _EmpHomeScreenState();
}

class _EmpHomeScreenState extends State<EmpHomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? userToken; // Store the user's token

  @override
  void initState() {
    super.initState();
    _loadUserToken(); // Load the user's token when the screen initializes
  }

  Future<void> _loadUserToken() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      userToken = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 5.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            final SharedPreferences prefs = await _prefs;
            prefs.clear();
            Get.offAll(() =>
                const AuthPage()); // Use a callback to instantiate AuthScreen
          },
          child: Image.asset(
            'lib/icons/logo.png',
            height: 120.0,
            width: 180.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(width: 40,),
                    Text(
                      'Hi, Welcome back!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 0.76),
                      ),
                    ),
                    Text(
                      ' ISAN DATA ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(249, 143, 67, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  'SYSTEMS PVT LTD',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(249, 143, 67, 1),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.25),
                      offset: const Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide.none,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(249, 143, 67, 1),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(196, 112, 51,
                          1), // Change to the color you desire when pressed
                    ),
                  ),
                  onPressed: () {},
                  child: const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Post Internship',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // EmpHomeButton(
              //  number: 24,
              // title: 'Posted',
              //   icon: Icons.file_open,
              // ),

              const SplashTile(imagePath: 'lib/images/home_pic.png'),
            ],
          ),
        ),
      ),
    );
  }
}
