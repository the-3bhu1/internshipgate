import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internshipgate/screens/login_reg_Employer/forgot_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Employer/listings/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api_endpoints.dart';
import '../auth_screen.dart';
import 'listings/emp_intern.dart';
import 'listings/emp_list.dart';
import 'emp_prof.dart';

class EmployeeDashboard extends StatefulWidget {
  final int erecId;
  final String eemail, efullname, eemptoken;

  const EmployeeDashboard({
    super.key,
    required this.erecId,
    required this.eemail,
    required this.efullname,
    required this.eemptoken,
  });

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  final loadingIndicatorKey = const ValueKey('loading');
  int postintern = 0;
  int receive = 0;
  int shortlist = 0;
  int hired = 0;
  int rejected = 0;
  String name = "";
  int chatcount = 0;
  var csvString = '';
  int _selectedIndex = 0;
  String _pic = "";
  bool isLoading = true;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void refreshData() {
    dash(widget.erecId.toString());
    chat(widget.eemptoken.toString(), widget.erecId.toString());
  }

  Future<void> loadData() async {
    try {
      await chat(widget.eemptoken.toString(), widget.erecId.toString());
      await dash(widget.erecId.toString());
      await fetchEmployeeProfile(widget.erecId.toString());
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

  Future<void> fetchEmployeeProfile(String id) async {
    try {
      final response = await get(
        Uri.parse(
          '${ApiEndPoints.baseUrl}getEmployerProfileById/$id',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          String pic = data['org_logo'];
          setState(() {
            _pic = pic;
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student profile: $error");
    }
  }

  Future<void> dash(String id) async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getEmployerDashboardStats/$id;'),
      );
      if (response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body.toString());
          //print(data);
          name = data['fullname'];
          postintern = data['intership_post'];
          receive = data['applied'];
          shortlist = data['shortlist'];
          hired = data['hire'];
          rejected = data['rejected'];
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> chat(String emptoken, id) async {
    try {
      Response response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getNewChatCounterForEmployer/$id/E$emptoken'),);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        chatcount = data['newChatMessageCount']['totalUnreadCount'];
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> downloadCSV(String id) async {
  //   try {
  //     Response response = await get(
  //       Uri.parse('${ApiEndPoints.baseUrl}getEmployerInternshipByEmployerId/$id'),);
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body) as List;
  //       List<List<dynamic>> csvData = [];
  //       csvData.add([
  //         'Organization Name',
  //         'Email',
  //         'Internship Industry',
  //         'Internship Details',
  //         'Location',
  //         'Total Openings',
  //         'Internship Type',
  //         'Duration',
  //         'Start Date',
  //         'Job Description',
  //         'Stipend Type',
  //         'Compensation',
  //         'Perks',
  //         'Skills Required',
  //         'Internship Creation Date',
  //         'Internship Posting Date',
  //         'Internship Status',
  //       ]);
  //       for (final item in data) {
  //         String duration = item['duration1'].toString();
  //         String compensation = item['compensation1'].toString();
  //         csvData.add([
  //           item['companyname'],
  //           item['email'],
  //           item['industry_type'],
  //           item['internship_details'],
  //           item['location'],
  //           item['total_opening'],
  //           item['type'],
  //           '$duration ${item['duration2']}',
  //           item['startdate'],
  //           item['job_description'],
  //           item['stipend_type'],
  //           '$compensation ${item['compensation2']}',
  //           item['perks'],
  //           item['skill'],
  //           item['created_at'],
  //           item['posting_date'],
  //           item['internship_status'],
  //         ]);
  //       }
  //       String csv = const ListToCsvConverter().convert(csvData);
  //
  //       // Save the CSV content to a file
  //       final directory = await getTemporaryDirectory();
  //       final path = '${directory.path}/data.csv';
  //       final file = File(path);
  //       await file.writeAsString(csv);
  //
  //       // Open the CSV file in the device's default browser
  //       await launch(path);
  //       //print(data);
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     throw Exception('Failed to load data');
  //   }
  // }

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
            selectedIcon: Icon(Iconsax.home_15, color: Color.fromRGBO(44, 56, 149, 1)),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.add_square),
            label: 'Post',
            selectedIcon: Icon(Iconsax.add_square5, color: Color.fromRGBO(44, 56, 149, 1)),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.task_square),
            label: 'Listings',
            selectedIcon: Icon(Iconsax.task_square5, color: Color.fromRGBO(44, 56, 149, 1)),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.profile_circle4),
            label: 'Profile',
            selectedIcon: Icon(Iconsax.profile_circle5, color: Color.fromRGBO(44, 56, 149, 1)),
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
              child: const Icon(Icons.arrow_back)
          ),
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
                      if (value == "item3") {
                        Get.to(() => EmpForgotPasswordScreen());
                      }
                      if (value == "item4") {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove('erecId');
                        prefs.remove('eemail');
                        prefs.remove('ename');
                        prefs.remove('etoken');
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
                                     'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/$_pic',
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
                                    widget.efullname,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.eemail,
                                    style: TextStyle(fontSize: width * 0.03, color: Colors.grey[800]),
                                  ),
                                ],
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
                          value: 'item4',
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
                              'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/$_pic',
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.07,),
                      ),
                      Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.07,
                              color: const Color.fromRGBO(249, 143, 67, 1))),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      IntrinsicHeight(
                        child: IntrinsicWidth(
                          child: ElevatedButton(
                            onPressed: () {
                              _onTabChange(1);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(249, 143, 67, 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            child: Text(
                              'Post Internship',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
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
                                                      topRight: Radius.circular(10)
                                                  )
                                              ),
                                              automaticallyImplyLeading: false,
                                              backgroundColor: Colors.white,
                                              elevation: 1,
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
                                              padding: const EdgeInsets.all(16),
                                              child: Image.asset(
                                                  'lib/images/excel.png'),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  //await downloadExcel(widget.erecId.toString());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.indigo,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8)
                                                    )
                                                ),
                                                child: const Text(
                                                    'Download Excelsheet', style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                            const SizedBox(height: 10,)
                                          ],
                                        ),
                                      );
                                    }
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                width: double.infinity,
                                height: height * 0.17,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          postintern.toString(),
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
                                          'Posted',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04,
                                          ),
                                        )
                                      ],
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
                                                      topRight:
                                                          Radius.circular(10))),
                                              automaticallyImplyLeading: false,
                                              backgroundColor: Colors.white,
                                              elevation: 1,
                                              actions: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ), // 'x' mark
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Image.asset(
                                                  'lib/images/excel.png'),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.indigo,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8))),
                                                child: const Text(
                                                    'Download Excelsheet',style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                width: double.infinity,
                                height: height * 0.17,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          receive.toString(),
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
                                          'Received',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                      'lib/images/rec.png',
                                      width: width * 0.125,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
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
                                                      topRight:
                                                          Radius.circular(10))),
                                              automaticallyImplyLeading: false,
                                              backgroundColor: Colors.white,
                                              elevation: 1,
                                              actions: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ), // 'x' mark
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Image.asset(
                                                  'lib/images/excel.png'),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.indigo,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8))),
                                                child: const Text(
                                                    'Download Excelsheet',style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                width: double.infinity,
                                height: height * 0.17,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
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
                                    Image.asset(
                                      'lib/images/short.png',
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
                                                      topRight:
                                                          Radius.circular(10))),
                                              automaticallyImplyLeading: false,
                                              backgroundColor: Colors.white,
                                              elevation: 1,
                                              actions: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ), // 'x' mark
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Image.asset(
                                                  'lib/images/excel.png'),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.indigo,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8))),
                                                child: const Text(
                                                    'Download Excelsheet', style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                width: double.infinity,
                                height: height * 0.17,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          hired.toString(),
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
                                          'Hired',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                      'lib/images/hired.png',
                                      width: width * 0.125,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
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
                                                      topRight: Radius.circular(10)
                                                  )
                                              ),
                                              automaticallyImplyLeading: false,
                                              backgroundColor: Colors.white,
                                              elevation: 1,
                                              actions: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ), // 'x' mark
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Image.asset(
                                                  'lib/images/excel.png'),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.indigo,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8))),
                                                child: const Text(
                                                    'Download Excelsheet', style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                width: double.infinity,
                                height: height * 0.17,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          rejected.toString(),
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
                                          'Rejected',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.04
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                      'lib/images/reject.png',
                                      width: width * 0.125,
                                      //height: height * 0.055,
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
                                Get.to(() => ChatScreenEmp(id: widget.erecId, emptoken: widget.eemptoken));
                                },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                width: double.infinity,
                                height: height * 0.17,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
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
                                          '$chatcount Messages',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: width * 0.035
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                      'lib/images/chat.png',
                                      width: width * 0.1205,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      )
                    ],
                  ),
                ),
              ),
              EmployeeIntern(
                name: name,
                email: widget.eemail,
                recId: widget.erecId,
                emptoken: widget.eemptoken,
                refreshCallback: refreshData,
                onTabChange: _onTabChange,
              ),
              EmployeeList(
                recId: widget.erecId,
                name: name,
                email: widget.eemail,
                emptoken: widget.eemptoken,
              ),
              EmployeeProfile(
                name: name,
                email: widget.eemail,
                id: widget.erecId,
                emptoken: widget.eemptoken,
              ),
            ]
          ),
          child: Center(
            child: CircularProgressIndicator(key: loadingIndicatorKey),
          ),
        ),
      ),
    );
  }
}