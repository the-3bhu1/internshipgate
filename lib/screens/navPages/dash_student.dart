import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import 'package:internshipgate/screens/dashPages/application_list_stud.dart';
import 'package:internshipgate/screens/dashPages/favorite_list_stud.dart';
import 'package:internshipgate/screens/dashPages/hired_list_stud.dart';
import 'package:internshipgate/screens/dashPages/shortlisted_appln_stud.dart';
import 'package:internshipgate/screens/dashPages/stud_chat_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/forgot_stud_screen.dart';
import 'package:internshipgate/screens/navPages/search_internship_stud.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/stud_profile_screen.dart';
import 'package:internshipgate/screens/navPages/virtual_internship.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/api_endpoints.dart';

class StudentDashboard extends StatefulWidget {
  final int recId, applicantId;
  final String tempEmail, fullname, stutoken;

  const StudentDashboard(
      {super.key,
      required this.recId,
      required this.tempEmail,
      required this.fullname,
      required this.stutoken,
      required this.applicantId});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final loadingIndicatorKey = const ValueKey('loading');
  bool isOpen = false;
  int totalApplication = 0;
  int receive = 0;
  int shortlist = 0;
  int rejected = 0;
  int offersent = 0;
  int favorite = 0;
  String name = '';
  int chatcount = 0;
  String resumecount = 'No Subscriptions';
  String email = '';
  bool isLoading = true;
  String _pic = '';
  bool complete_profile = false;
  int _selectedIndex = 0;
  final List<dynamic> _savedSkills = [];
  late Future<SharedPreferences> prefs;
  bool edu = false;
  bool sku = false;
  bool locu = false;
  bool adu = false;
  final List<dynamic> _educationDetails = [];
  String savedLocation = "";
  String savedAddress = "";

  void _onTabChange(int index) {
    setState(() {
      if(complete_profile && index == 1) {
        profileData();
      }
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    /*print(widget.stutoken.toString());
    print(widget.recId.toString());*/
    prefs = _initPrefs();
    loadData();
    incompleteProfileData();
    dash(widget.recId.toString());
    chat(widget.stutoken.toString(), widget.recId.toString());
    resume(widget.applicantId.toString(), widget.stutoken.toString());
    fetchStudentEmail(widget.applicantId.toString());
  }

  Future<void> incompleteProfileData() async {
    Future.wait([
      fetchSkill(widget.applicantId.toString()),
      fetchStudentProfile(widget.applicantId.toString()),
      fetchEducation(widget.applicantId.toString()),
    ]).then((_) {
      //print('$locu $adu $edu $sku');
      complete_profile = locu || adu || edu || sku;
      if (complete_profile && _selectedIndex != 3) {
        profileData();
      }
    });
  }

  Future<SharedPreferences> _initPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('recId', widget.recId);
    prefs.setInt('applicantId', widget.applicantId);
    prefs.setString('email', widget.tempEmail);
    prefs.setString('name', widget.fullname);
    prefs.setString('token', widget.stutoken);
    return prefs;
  }

  Future<void> fetchStudentProfile(String applicantId) async {
    try {
      final response = await get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final Map<String, dynamic> basicDetail =
              data['applicant_basic_detail'] ?? {};

          setState(() {
            _pic = basicDetail['pic'] ?? "";
            //print("check dashboard pic");
            //print(_pic);
            savedLocation = basicDetail['location'] ?? ' ';
            if (basicDetail['location'] == null) {
              locu = true;
            } else {
              locu = false;
            }
            savedAddress = basicDetail['address'] ?? ' ';
            if (basicDetail['address'] == null) {
              adu = true;
            } else {
              adu = false;
            }
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student stu profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student stu profile: $error");
    }
  }

  Future<void> loadData() async {
    try {
      await dash(widget.recId.toString());
      await chat(widget.stutoken.toString(), widget.recId.toString());
      await fetchStudentEmail(widget.applicantId.toString());
      setState(() {
        isLoading = false; // Data is loaded, set isLoading to false
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false; // Set isLoading to false in case of an error
      });
    }
  }

  void refreshData() {
    dash(widget.recId.toString());
    chat(widget.stutoken.toString(), widget.recId.toString());
  }

  void profileData() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                automaticallyImplyLeading: false,
                elevation: 1,
                title: Center(child: Text('Incomplete Profile', style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold))),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ), // 'x' mark
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.05),
                  child: Text('Complete your profile to apply for internships', style: TextStyle(fontSize: width * 0.05, color: Colors.black), textAlign: TextAlign.center,)
              ),
              SizedBox(
                height: height * 0.043,
                child: IntrinsicWidth(
                  child: ElevatedButton(
                    onPressed: () {
                      _onTabChange(3);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Go To Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> dash(String id) async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getStudentDashboardStats/$id'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          var data = jsonDecode(response.body.toString());
          //print(data);

          //name = data['fullname'] ?? '';
          totalApplication = data['total_application'] ?? 0;
          //receive = data['applied'] ?? 0;
          shortlist = data['shortlist'] ?? 0;
          //rejected = data['Rejected'];
          offersent = data['offersent'] ?? 0;
          favorite = data['total_favorite'] ?? 0;
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print('error1: ${e.toString()}');
    }
  }

  Future<void> fetchStudentEmail(String applicantId) async {
    try {
      final response = await get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.isNotEmpty) {
          final Map<String, dynamic> basicDetail =
              data['applicant_basic_detail'] ?? {};
          email = basicDetail['email'] ?? "N/A";
        } else {
          print("Empty response for email or unexpected data format");
        }
      } else {
        print("Failed to fetch student email: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student email: $error");
    }
  }

  Future<void> chat(String token, id) async {
    try {
      Response response = await get(
        Uri.parse(
            '${ApiEndPoints.baseUrl}getNewChatCounterForStudent/$id/S$token'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        chatcount = data['newChatMessageCount']['totalUnreadCount'];
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print('error-chat: ${e.toString()}');
    }
  }

  Future<void> resume(String id, stutoken) async {
    try {
      //print(stutoken);
      Response response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getResumeSubscriptions/$id'),
        headers: {
          'Authorization': 'Bearer $stutoken',
        },
      );
      //print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        if (data.containsKey('resumeSubscription')) {
          List resumeSubscription = data['resumeSubscription'];
          resumecount = resumeSubscription.isNotEmpty? resumeSubscription.length.toString() : 'No Subscriptions';
        } else {
          resumecount = 'No Subscriptions';
        }
      } else {
        var data = jsonDecode(response.body.toString());
        //print('else data: $data');
      }
    } catch (e) {
      print('error-chat: ${e.toString()}');
    }
  }

  /*Future<void> fetchSkill(String applicantId) async {
    try {
      final response = await get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<String> skillList = (data['applicant_software_skill']
                      as List<dynamic>?)
                  ?.map((entry) => (entry['software_skill'] as String?) ?? '')
                  .toList() ??
              [];
          // String? applicantBasicDetailId = basicDetail['id']?.toString();

          setState(() {
            _savedSkills.clear();
            _savedSkills.addAll(skillList);
            //print("check saved skills in dash board");
            //print(_savedSkills);
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student stu skill: $error");
    }
  }*/

  Future<void> fetchSkill(String applicantId) async {
    try {
      final response = await get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.isNotEmpty) {
          final dynamic applicantSkill = data['applicant_software_skill'];
          if (applicantSkill is List<dynamic>) {
            final List<String> skillList = (applicantSkill
            as List<dynamic>?)
                ?.map((entry) => (entry['software_skill'] as String?) ?? '')
                .toList() ??
                [];
            setState(() {
              _savedSkills.clear();
              _savedSkills.addAll(skillList);
              /*selectedSkills.clear();
              selectedSkills.addAll(individualSkills);*/
            });
            sku = skillList.isEmpty || skillList.any((element) => element.isEmpty);
            if (!sku) {
              sku = false;
            }
          } else {
            sku = true;
            //print('skills: ${sku.toString()}');
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student skillsssssss: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student skill: $error");
    }
  }

  Future<void> fetchEducation(String applicantId) async {
    try {
      final response = await get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.isNotEmpty) {
          final dynamic applicantEducation = data['applicant_education'];
          if (applicantEducation is List<dynamic>) {
            final List<dynamic> educationList = applicantEducation;
            setState(() {
              for (var education in educationList) {
                if (education['applicant_basic_detail_id'] != null) {
                  break;
                }
              }
              _educationDetails.clear();
              _educationDetails.addAll(educationList);
              //print("Check educationlist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              //print("education: $_educationDetails");
            });
            edu = false;
          } else {
            edu = true;
            //print('education: ${edu.toString()}');
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student education: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student education: $error");
    }
  }

  Widget buildBottomNavBar() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.033),
        ),
        iconTheme: MaterialStateProperty.all(
          IconThemeData(
            size: width * 0.048,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabChange,
        elevation: 2,
        height: height * 0.07,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Home',
            selectedIcon:
                Icon(Iconsax.home_15, color: Color.fromRGBO(44, 56, 149, 1)),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.task_square),
            label: 'Internships',
            selectedIcon: Icon(Iconsax.task_square5,
                color: Color.fromRGBO(44, 56, 149, 1)),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.global_search),
            label: 'Explore',
            selectedIcon: Icon(Iconsax.global_search5,
                color: Color.fromRGBO(44, 56, 149, 1)),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.profile_circle4),
            label: 'Profile',
            selectedIcon: Icon(Iconsax.profile_circle5,
                color: Color.fromRGBO(44, 56, 149, 1)),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you want to quit?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
      return confirm;
    } else {
      _onTabChange(0);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          elevation: 2,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () async {
                if (_selectedIndex == 0) {
                  bool confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you want to quit?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    SystemNavigator.pop();
                  }
                } else {
                  _onTabChange(0);
                }
              },
              child: const Icon(Icons.arrow_back)),
          leadingWidth: width * 0.1,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: GestureDetector(
            onTap: () async {
              Get.offAll(() => const AuthPage()); // Use a callback to instantiate AuthScreen
            },
            child: Image.asset(
              'lib/icons/logo.png',
              width: width * 0.47,
            ),
          ),
          actions: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: PopupMenuButton<String>(
                    position: PopupMenuPosition.under,
                    onSelected: (value) async {
                      if (value == "item1") {
                        _onTabChange(3);
                      }
                      if (value == "item2") {
                        Get.to(() => StudForgotPasswordScreen());
                      }
                      if (value == "item3") {
                        // Clear saved login details
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove('recId');
                        prefs.remove('applicantId');
                        prefs.remove('email');
                        prefs.remove('name');
                        prefs.remove('token');
                        prefs.remove('googleId');
                        prefs.remove('googleEmail');
                        prefs.remove('googleName');
                        prefs.remove('googleApplicantId');
                        prefs.remove('googleToken');
                        prefs.remove('isLoggedIn');
                        // Navigate to the login/sign-up screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const AuthPage()),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'item1',
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: width * 0.045,
                                backgroundColor: Colors.white, // Set background color if needed
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey, // Set border color
                                      width: 1, // Set border thickness
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://internshipgates3.s3.ap-south-1.amazonaws.com/stuprofilepicupload/$_pic',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color.fromRGBO(44, 56, 149, 1),
                                          ),
                                          Icon(
                                            Icons.person,
                                            size: width * 0.045,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.015,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.fullname,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(fontSize: width * 0.03, color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'item2',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline_outlined,
                                color: Colors.indigo,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'item3',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.power_settings_new_outlined,
                                color: Colors.indigo,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: GestureDetector(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white, // Set background color if needed
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Set border color
                              width: 1, // Set border thickness
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://internshipgates3.s3.ap-south-1.amazonaws.com/stuprofilepicupload/$_pic',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Color.fromRGBO(44, 56, 149, 1),
                                  ),
                                  Icon(
                                    Icons.person,
                                    size: width * 0.045,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03,)
              ],
            ),
          ],
        ),
        bottomNavigationBar: buildBottomNavBar(),
        body: Visibility(
          visible: isLoading,
          replacement: IndexedStack(
              index: _selectedIndex,
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.045, vertical: width * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Welcome back!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.07),
                        ),
                        Text(
                          widget.fullname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.07,
                            color: const Color.fromRGBO(249, 143, 67, 1),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        IntrinsicHeight(
                          child: IntrinsicWidth(
                            child: ElevatedButton(
                              onPressed: () {
                                _onTabChange(3);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color.fromRGBO(249, 143, 67, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: Text(
                                'View Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => StudApplicationList(studentId: widget.recId));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                              width: double.infinity,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400, width: 1,),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          totalApplication.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.07,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          'All Applications',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                            fontSize: width * 0.04,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'lib/images/posted.png',
                                    width: width * 0.125,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.035,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => StudShortlisted(studentId: widget.recId));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                              width: double.infinity,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          shortlist.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.07
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          'Shortlisted',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'lib/images/hired.png',
                                    width: width * 0.125,
                                  )

                            //       Expanded(
                            //         child: SvgPicture.string(
                            //           '''
                            // <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="1em" height="1em" fill="currentColor"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z"></path><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5L9.5 0zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5z"></path></svg>
                            // ''',
                            //           height: 25,
                            //           color: Colors.green,
                            //         ),
                            //       )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                        SizedBox(
                          height: height * 0.017,
                        ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(()=> StudHiredList(studentId: widget.recId));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.03,),
                              width: double.infinity,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 189, 189, 189),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          offersent.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.07
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          'Offer Received',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'lib/images/rec.png',
                                    width: width * 0.125,
                                  )
                            //       Expanded(
                            //         child: SvgPicture.string(
                            //           '''
                            // <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="1em" height="1em" fill="currentColor"><path d="M8 11a.5.5 0 0 0 .5-.5V6.707l1.146 1.147a.5.5 0 0 0 .708-.708l-2-2a.5.5 0 0 0-.708 0l-2 2a.5.5 0 1 0 .708.708L7.5 6.707V10.5a.5.5 0 0 0 .5.5z"></path><path d="M4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H4zm0 1h8a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1z"></path></svg>
                            // ''',
                            //           height: 25,
                            //           color: Colors.blue,
                            //         ),
                            //       )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.035,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(()=> StudFavoritesList(studentId: widget.recId));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                              width: double.infinity,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 189, 189, 189),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          favorite.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.07
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          'Favorites',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'lib/images/short.png',
                                    width: width * 0.125,
                                  )
                                  // Expanded(
                                  //   child: SvgPicture.string(
                                  //     '''<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 1024 1024" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg"><path d="M908.1 353.1l-253.9-36.9L540.7 86.1c-3.1-6.3-8.2-11.4-14.5-14.5-15.8-7.8-35-1.3-42.9 14.5L369.8 316.2l-253.9 36.9c-7 1-13.4 4.3-18.3 9.3a32.05 32.05 0 0 0 .6 45.3l183.7 179.1-43.4 252.9a31.95 31.95 0 0 0 46.4 33.7L512 754l227.1 119.4c6.2 3.3 13.4 4.4 20.3 3.2 17.4-3 29.1-19.5 26.1-36.9l-43.4-252.9 183.7-179.1c5-4.9 8.3-11.3 9.3-18.3 2.7-17.5-9.5-33.7-27-36.3zM664.8 561.6l36.1 210.3L512 672.7 323.1 772l36.1-210.3-152.8-149L417.6 382 512 190.7 606.4 382l211.2 30.7-152.8 148.9z"></path></svg>''',
                                  //     height: 25,
                                  //     color: Colors.red,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                        SizedBox(
                          height: height * 0.017,
                        ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final Uri uri = Uri.parse('https://internshipgate.com/ResumeBuilder');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                throw 'Could not launch $uri';
                              }
                            },
                            /*onTap: () {
                              Get.to(()=> StudRejected(studentId: widget.recId));
                            },*/
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                              width: double.infinity,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Resume Builder",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.045
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          resumecount,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.035
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'lib/images/reject.png',
                                    width: width * 0.125,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.035,
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Container(
                        //       width:
                        //           double.infinity, // Adjust the width as needed
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(12),
                        //         border: Border.all(
                        //           color: const Color.fromARGB(255, 189, 189, 189),
                        //           width: 1.5,
                        //         ),
                        //       ),
                        //       child: StudChatButton(
                        //         number: chatcount,
                        //         title: 'Chat',
                        //         icon: Iconsax.message,
                        //         iconColor: Colors.purple,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => ChatScreenStu(
                                id: widget.recId,
                                stutoken: widget.stutoken,
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                              width: double.infinity,
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Chat',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.07
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          '$chatcount messages',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'lib/images/chat.png',
                                    width: width * 0.1205,
                                  )
                           //        Expanded(
                           //          child: SvgPicture.string(
                           //            '''
                           // <svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 16 16" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg"><path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"></path><path d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2z"></path></svg>
                           //  ''',
                           //            height: 25,
                           //            color: Colors.blue.shade900,
                           //          ),
                           //        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 20),
                    // Container(
                    //   color: const Color.fromARGB(255, 255, 255, 255),
                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: const Text(
                    //     'Build Your Resume',
                    //     style: TextStyle(
                    //       fontSize: 23,
                    //       fontWeight: FontWeight.bold,
                    //       color: Color.fromRGBO(0, 0, 0, 0.76),
                    //     ),
                    //     textAlign: TextAlign.left, // Align the text to the left
                    //   ),
                    // ),

                        SizedBox(
                          height: height * 0.02,
                        )

                    // const SizedBox(height: 5),

                    // Row(
                    //   children: [
                    //     const Image(
                    //       image:
                    //           AssetImage('lib/images/resume_build_dashboard.png'),
                    //       width: 200,
                    //       height: 140,
                    //       fit: BoxFit.cover,
                    //     ),
                    //     Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Container(
                    //         width: 140,
                    //         height: 40,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(8),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.white.withOpacity(0.25),
                    //               offset: const Offset(0, 0),
                    //               blurRadius: 2,
                    //               spreadRadius: 1,
                    //             ),
                    //           ],
                    //         ),
                    //         child: TextButton(
                    //           style: ButtonStyle(
                    //             shape: MaterialStateProperty.all<
                    //                 RoundedRectangleBorder>(
                    //               RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(8),
                    //                 side: BorderSide.none,
                    //               ),
                    //             ),
                    //             backgroundColor: MaterialStateProperty.all<Color>(
                    //               const Color.fromRGBO(249, 143, 67, 1),
                    //             ),
                    //             overlayColor: MaterialStateProperty.all<Color>(
                    //               const Color.fromRGBO(196, 112, 51,
                    //                   1), // Change to the color you desire when pressed
                    //             ),
                    //           ),
                    //           onPressed: () async {
                    //             final url = Uri.parse(
                    //                 'https://internshipgate.com/ResumeBuilder');
                    //             if (await canLaunchUrl(url)) {
                    //               await launchUrl(url);
                    //             } else {
                    //               throw 'Could not launch $url';
                    //             }
                    //           },
                    //           child: const Center(
                    //             // Use the Center widget to center the text
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize
                    //                   .min, // To make the Row take the minimum space needed
                    //               children: [
                    //                 Text(
                    //                   'Resume Builder',
                    //                   style: TextStyle(
                    //                     fontSize: 14,
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // _pages[_selectedIndex],
                    //  StudentProfilePage(),
                    // VirtualInternshipPage(),
                    // InternshipListPage(),
                  ],
                ),
              ),
            ),
            InternshipPage(
              studentId: widget.recId,
              emai: email,
              fullname: widget.fullname,
              emptoken: widget.stutoken,
              applicantId: widget.applicantId,
              refreshCallback: refreshData,
              onTabChange: _onTabChange,
              complete_profile: complete_profile,
            ),
            VirtualInternshipPage(
              studentId: widget.recId,
              emai: email,
              fullname: widget.fullname,
              emptoken: widget.stutoken,
              applicantId: widget.applicantId,
            ),
            StudentProfilePage(
              studentId: widget.recId,
              emai: email,
              applicantId: widget.applicantId,
              fullname: widget.fullname,
              emptoken: widget.stutoken,
              refreshCallback: incompleteProfileData,
            ),
          ]),
          child: Center(
            child: CircularProgressIndicator(key: loadingIndicatorKey),
          ),
        ),
      ),
    );
  }
}
