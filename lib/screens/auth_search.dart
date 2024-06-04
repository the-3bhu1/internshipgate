import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/buttons/button_employer.dart';
import 'package:internshipgate/buttons/button_student.dart';
import 'package:internshipgate/screens/login_reg_Employer/login_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/login_stud_screen.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/auth_moredetailspage.dart';
import 'package:internshipgate/utils/api_endpoints.dart';
import 'auth_screen.dart';
import 'navPages/search_internship_stud.dart';

class AuthSearch extends StatefulWidget {
  final String searchText;
  const AuthSearch({Key? key, required this.searchText}) : super(key: key);

  @override
  State<AuthSearch> createState() => _AuthSearchState();
}

class _AuthSearchState extends State<AuthSearch> {
  List<Internship> internships = [];
  List<Internship> filteredInternships = [];
  int _currentPage = 1;
  int _totalPages = 0;
  int _totalInternships = 0;
  String message = '';

  void loginAsStudent(BuildContext context) {
    Get.to(() => const StudentLoginScreen());
  }


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    fetchData();
  }

  void _prevPage() {
    setState(() {
      _currentPage--;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl}search-internships/all-internships/all-duration/starting-immediately/all/all/all/stipend-any/all/all/${widget.searchText}/all?page=$_currentPage'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      _totalInternships = jsonDecode(response.body)['total'];
      _totalPages = jsonDecode(response.body)['last_page'];
      List<Internship> fetchedInternships =
      data.map((item) => Internship.fromJson(item)).toList();

      setState(() {
        internships = fetchedInternships;
      });
    } else {
      throw Exception('Failed to load data');
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.offAll(() => const AuthPage()); // Use a callback to instantiate AuthScreen
          },
          child: Image.asset(
            'lib/icons/logo.png',
            height: 120.0,
            width: 180.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Internship List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Text('Showing $_totalInternships Internships', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
          SizedBox(height: height * 0.01,),
          Expanded(
            child: ListView.builder(
              itemCount: internships.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(8),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.network(
                            'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/${internships[index].orgLogo}',
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.work);
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        internships[index].companyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Internship Details: ${internships[index].internshipDetails}'),
                          Text('Location: ${internships[index].location}'),
                          Text('Type: ${internships[index].type}'),
                          Text('Duration: ${internships[index].duration1} ${internships[index].duration2}'),
                          Row(
                            children: [
                              Flexible(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                      const Color.fromRGBO(249, 143, 67, 1),
                                    ),
                                    minimumSize:
                                    MaterialStateProperty.all<Size>(
                                      const Size(50, 35),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (internships.isNotEmpty && index < internships.length) {
                                      int internshipId = internships [index].id; // Assuming 'id' is the key for internship ID
                                      Get.to(() => AuthInternshipDetails(internshipId: internshipId));
                                    } else {
                                      print('Invalid index or empty internships list.');
                                    }
                                  },
                                  child: const Text(
                                    'More Details',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                      const Color.fromRGBO(44, 56, 149, 1),
                                    ),
                                    minimumSize:
                                    MaterialStateProperty.all<Size>(
                                      const Size(50, 35),
                                    ),
                                  ),
                                  onPressed: () {
                                    showLoginOptionsDialog(context);
                                  },    child: const Text(
                                  'Apply Now',
                                  style: TextStyle(
                                      color:
                                      Color.fromRGBO(255, 255, 255, 1)),
                                ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 1 ? _prevPage : null,
                child: const Text('Prev'),
              ),
              Text('Page $_currentPage of $_totalPages'),
              ElevatedButton(
                onPressed: _currentPage < _totalPages ? _nextPage : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
