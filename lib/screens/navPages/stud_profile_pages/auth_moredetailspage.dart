import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/buttons/button_employer.dart';
import 'package:internshipgate/buttons/button_student.dart';
import 'package:internshipgate/screens/login_reg_Employer/login_emp_screen.dart';
import 'package:internshipgate/screens/login_reg_Student/login_stud_screen.dart';
import '../../../utils/api_endpoints.dart';

class InternshipDetail {
  final String orgLogo;
  final String orgName;
  final int id;
  final int employerId;
  final String companyName;
  final String industryType;
  final String internshipDetails;
  final String location;
  final int totalOpening;
  final String type;
  final int duration1;
  final String duration2;
  final String startDate;
  final String jobDescription;
  final String stipendType;
  final int compensation1;
  final String compensation2;
  final String perks;
  final String skill;
  final int active;
  final String postingDate;

  InternshipDetail({
    required this.orgLogo,
    required this.orgName,
    required this.id,
    required this.employerId,
    required this.companyName,
    required this.industryType,
    required this.internshipDetails,
    required this.location,
    required this.totalOpening,
    required this.type,
    required this.duration1,
    required this.duration2,
    required this.startDate,
    required this.jobDescription,
    required this.stipendType,
    required this.compensation1,
    required this.compensation2,
    required this.perks,
    required this.skill,
    required this.active,
    required this.postingDate,
  });

  factory InternshipDetail.fromJson(Map<String, dynamic> json) {
    return InternshipDetail(
      orgLogo: json['org_logo'] ?? '',
      orgName: json['org_name'] ?? '',
      id: json['id'] ?? 0,
      employerId: json['employer_id'] ?? 0,
      companyName: json['companyname'] ?? '',
      industryType: json['industry_type'] ?? '',
      internshipDetails: json['internship_details'] ?? '',
      location: json['location'] ?? '',
      totalOpening: json['total_opening'] ?? 0,
      type: json['type'] ?? '',
      duration1: json['duration1'] ?? 0,
      duration2: json['duration2'] ?? '',
      startDate: json['startdate'] ?? '',
      jobDescription: json['job_description'] ?? '',
      stipendType: json['stipend_type'] ?? '',
      compensation1: json['compensation1'] ?? 0,
      compensation2: json['compensation2'] ?? '',
      perks: json['perks'] ?? '',
      skill: json['skill'] ?? '',
      active: json['active'] ?? 0,
      postingDate: json['posting_date'] ?? '',
    );
  }
}

class AuthInternshipDetails extends StatefulWidget {
  final int internshipId;
 

  const AuthInternshipDetails({Key? key, required this.internshipId}) : super(key: key);

  @override
  State<AuthInternshipDetails> createState() => _AuthInternshipDetailsState();
}

class _AuthInternshipDetailsState extends State<AuthInternshipDetails> {
  late Future<InternshipDetail> futureInternshipDetail;
   void loginAsStudent(BuildContext context) {
    Get.to(() => const StudentLoginScreen());
  }

  @override
  void initState() {
    super.initState();
    futureInternshipDetail = fetchInternshipDetail();
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


 Future<InternshipDetail> fetchInternshipDetail() async {
    final response = await http.get(
      Uri.parse('${ApiEndPoints.baseUrl}getEmployerInternshipDetailsById/${widget.internshipId}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      InternshipDetail internshipDetail = InternshipDetail.fromJson(data[0]);
      return internshipDetail;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Detail'),
      ),
      body: FutureBuilder<InternshipDetail>(
        future: futureInternshipDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            InternshipDetail data = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.companyName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Industry Type: ${data.industryType}'),
                    Text('Location: ${data.location}'),
                    Text('Type: ${data.type}'),
                    Text('Duration: ${data.duration1} ${data.duration2}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Internship Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(data.internshipDetails),
                    const SizedBox(height: 16),
                    const Text(
                      'Job Description:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(data.jobDescription),
                    const SizedBox(height: 16),
                    const Text(
                      'Start Date:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.startDate,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Stipend Type:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.stipendType,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Compensation:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${data.compensation1} ${data.compensation2}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Perks:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.perks,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Skill:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.skill,
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 16),
                    Center(
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
                            }, 
                        child: const Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
