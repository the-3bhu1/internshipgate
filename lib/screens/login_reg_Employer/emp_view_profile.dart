import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internshipgate/screens/auth_screen.dart';
import '../../utils/api_endpoints.dart';

class ViewProfilePage extends StatefulWidget {
  final String studentId, intshipId;
  final String currentStat;

  const ViewProfilePage({
    Key? key,
    required this.studentId, required this.currentStat, required this.intshipId,
  }) : super(key: key);

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final loadingIndicatorKey = const ValueKey('loading');
  String _savedLocation = "";
  String _savedAddress = "";
  String _savedExperience = "";
  String? _mobile1Controller = "";
  final List<String> _savedSkills = [];
  String _pic = "";
  // List<Map<String, dynamic>> _educationDetails = [];
   final List<dynamic> _internshipDetails = [];
     final List<dynamic> _projectDetails = [];
     final List<dynamic> _trainingDetails = [];
     final List<dynamic> _educationDetails = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchStudentProfile(widget.studentId.toString());
    //  fetchEducation(widget.studentId.toString());
    // fetchInternship(widget.studentId.toString());
    // fetchProjects(widget.studentId.toString());
    //fetchTraining(widget.studentId.toString());
    // fetchMobile(widget.applicantId.toString());
    //  fetchSkill(widget.studentId.toString());
     loadData();
     //print("Checkkkkkkkkkkkk saved skillsssssssssssssssssssssssss");
    //print(_savedSkills);
  }

  Future<void> fetchStudentProfile(String studentId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/0/0/$studentId',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.isNotEmpty) {
          final Map<String, dynamic> basicDetail =
              data['applicant_basic_detail'] ?? {};
          //var mobileno = data['applicant_mobileno'] ?? {};
          // final List<Map<String, dynamic>> softwareSkillList =
          //     (data['applicant_software_skill'] as List<dynamic>?)
          //         ?.cast<Map<String, dynamic>>()
          //         .toList() ?? [];
          // final List<Map<String, dynamic>> educationList =
          //     (data['applicant_education'] as List<dynamic>?)
          //         ?.cast<Map<String, dynamic>>()
          //         .toList() ?? [];

          setState(() {
            _titleController.text = basicDetail['title'] ?? '';
            _nameController.text = basicDetail['name'] ?? '';
            _emailController.text = basicDetail['email'] ?? '';
            if (data['applicant_mobileno'] == 'not-found') {
              _mobile1Controller = 'not-found';
            } else {
              _mobileController.text = data['applicant_mobileno']['mobileno'];
            }
            _savedLocation = basicDetail['location'] ?? '';
            _savedAddress = basicDetail['address'] ?? '';
            _savedExperience = '${basicDetail['exp_year'] ?? 'NA'} years ${basicDetail['exp_month'] ?? 'NA'} months';
            _pic = basicDetail['pic'] ?? '';
            // _savedSkills = softwareSkillList
            //     .map((skill) => skill['software_skill'].toString())
            //     .toList();
            // _educationDetails = educationList;
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Error1: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error1: $error");
    }
  }

  Future<void> fetchProjects(String studentId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/0/0/$studentId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['applicant_project'] != "not-found") {
          final List<dynamic> projectList =
              data['applicant_project'] as List<dynamic>? ?? [];

          // String? applicantBasicDetailId = basicDetail['id']?.toString();

          setState(() {
            _projectDetails.clear();
            _projectDetails.addAll(projectList);
            //print("Check projectlist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
            //print(_projectDetails);
          });
        }
      } else {
        print("Error2: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error2: $error");
    }
  }

  Future<void> fetchInternship(String studentId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/0/0/$studentId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['applicant_intership'] != "not-found") {
          final List<dynamic> internshipList =
              data['applicant_intership'] as List<dynamic>? ?? [];

          setState(() {
           
            _internshipDetails.clear();
            _internshipDetails.addAll(internshipList);
            //print("Check internshiplist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
            //print(_internshipDetails);
          });
        }
      } else {
        print("failed3: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error3: $error");
    }
  }

  Future<void> fetchTraining(String studentId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/0/0/$studentId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['applicant_training'] != "not-found") {
          final List<dynamic> trainingList =
              data['applicant_training'] as List<dynamic>? ?? [];

          setState(() {
            _trainingDetails.clear();
            _trainingDetails.addAll(trainingList);
            //print("Check traininglist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
            //print(_trainingDetails);
          });
        }
      } else {
        print("failed4: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error4: $error");
    }
  }


  Future<void> fetchSkill(String studentId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/0/0/$studentId'));

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
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Error5: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error5: $error");
    }
  }

  Future<void> fetchEducation(String studentId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/0/0/$studentId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final List<dynamic> educationList =
              data['applicant_education'] as List<dynamic>? ?? [];
          // String? applicantBasicDetailId = basicDetail['id']?.toString();

          setState(() {
            
            _educationDetails.clear();
            _educationDetails.addAll(educationList);
            //print("Check educationlist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
            //print(_educationDetails);
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Error6: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error6: $error");
    }
  }

  shortcand(String internshipId, studentId) async {
    try{
      final response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}shortlistApplicant'),
          body: {
            'internshipId' : internshipId,
            'studentId' : studentId,
          }
      );
      if(response.statusCode == 200 | 201) {
        //var data = jsonDecode(response.body.toString());
        //print(data);
        Get.snackbar(
          'Success',
          'Applicant Shortlisted Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadData();
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  hirerejcand(String internshipId, int appstat) async {
    try{
      final response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}updateInternshipApplicantStatus'),
          body: {
            'internshipId' : internshipId,
            'appstat' : appstat,
          }
      );
      if(response.statusCode == 200 | 201) {
        //var data = jsonDecode(response.body.toString());
        //print(data);
        if (appstat == 2) {
          Get.snackbar(
            'Success',
            'Applicant Hired Successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          loadData();
        } else {
          Get.snackbar(
            'Success',
            'Applicant Rejected Successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
          loadData();
        }
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> loadData() async {
    try {
      await fetchStudentProfile(widget.studentId.toString());
      await fetchEducation(widget.studentId.toString());
      await fetchInternship(widget.studentId.toString());
      await fetchProjects(widget.studentId.toString());
      await fetchTraining(widget.studentId.toString());
      await fetchSkill(widget.studentId.toString());
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

  String maskEmail(String email) {
    if (email.contains('@')) {
      final List<String> parts = email.split('@');
      final String maskedPart = 'x' * (parts[0].length >= 7 ? 7 : parts[0].length);
      return '$maskedPart${parts[0].substring(maskedPart.length)}@${parts[1]}';
    }
    return email;
  }

  String maskMobileNumber(String mobileNumber) {
    final String maskedPart = 'x' * (mobileNumber.length >= 7 ? 7 : mobileNumber.length);
    return '$maskedPart${mobileNumber.substring(maskedPart.length)}';
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.offAll(() => const AuthPage());
          },
          child: Image.asset(
            'lib/icons/logo.png',
            height: 120.0,
            width: 180.0,
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: SingleChildScrollView(
           scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                color: Colors.white,
            //   decoration: BoxDecoration(
            //    color: Colors.white,
            //   borderRadius: BorderRadius.circular(10.0),
            //   boxShadow: const [
            //     BoxShadow(
            //       color: Colors.grey,
            //       blurRadius: 10.0,
            //     ),
            //   ],
            // ),


              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text('Fields marked with * are mandatory to apply for internships', style: TextStyle(fontSize: width * 0.045, color: Colors.blueGrey, fontWeight: FontWeight.w600),),
                        SizedBox(height: height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget.currentStat != 'Shortlisted' && widget.currentStat != 'Hired/Offer Sent',
                              child: OutlinedButton(
                                onPressed: () {
                                  shortcand(widget.intshipId, widget.studentId);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green.shade600,
                                  side: BorderSide(color: Colors.green.shade600,),
                                  padding: EdgeInsets.symmetric(vertical: height * 0.01,horizontal: width * 0.03),
                                ),
                                child: Text('Shortlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04),),
                              ),
                            ),
                            Visibility(
                              visible: widget.currentStat == 'Hired/Offer Sent',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green[800], size: width * 0.045,),
                                  SizedBox(width: width * 0.01,),
                                  Text('HIRED', style: TextStyle(color: Colors.green[800], fontSize: width * 0.04),),
                                ],
                              )
                            ),
                            Visibility(
                              visible: widget.currentStat == 'Shortlisted',
                              child: Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      hirerejcand(widget.intshipId, 2);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green.shade600,
                                      side: BorderSide(color: Colors.green.shade600,),
                                      padding: EdgeInsets.symmetric(vertical: height * 0.01,horizontal: width * 0.03),
                                    ),
                                    child: Text('Hire', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04),),
                                  ),
                                  SizedBox(width: width * 0.02,),
                                  OutlinedButton(
                                    onPressed: () {
                                      hirerejcand(widget.intshipId, 4);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7)
                                      ),
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red,),
                                      padding: EdgeInsets.symmetric(vertical: height * 0.01,horizontal: width * 0.03),
                                    ),
                                    child: Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04),),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: width * 0.02,),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                                side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1),),
                                padding: EdgeInsets.symmetric(vertical: height * 0.01,horizontal: width * 0.03),
                              ),
                              child: Text('Back to Internships', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04)),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                               radius: 50,
                                  backgroundColor: Colors.transparent,

                              child: ClipOval(
                                child: Image.network(
                                  'https://internshipgates3.s3.ap-south-1.amazonaws.com/stuprofilepicupload/$_pic',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Color.fromRGBO(44, 56, 149, 1),
                                        ),
                                        Icon(
                                          Icons.person,
                                          size: 70,
                                          color: Colors.white,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _titleController.text,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          _nameController.text,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.currentStat != 'Shortlisted' && widget.currentStat != 'Hired/Offer Sent' ? maskEmail(_emailController.text) : _emailController.text,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    widget.currentStat != 'Shortlisted' && widget.currentStat != 'Hired/Offer Sent' ? maskMobileNumber(_mobileController.text) : _mobileController.text,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.currentStat != 'Shortlisted' && widget.currentStat != 'Hired/Offer Sent',
                    child: Column(
                      children: [
                        Text(" - Shortlist the student to view the email and mobile number", style: TextStyle(color: const Color.fromRGBO(44, 56, 149, 1), fontStyle: FontStyle.italic, fontSize: width * 0.032),),
                        SizedBox(height: height * 0.01,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],

                    ),
                  ),
                  // ... existing code ...

                  // Ensure that values are set for other UI elements
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // Add spacing between sections
                     SizedBox(
                        height: height * 0.01,
                      ),
                     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            const Text(
                              "*Location:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _savedLocation,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),


                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "*Address: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                _savedAddress,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                   Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            const Text(
                              "*Experience:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _savedExperience,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                     if (_mobile1Controller == 'not-found') ...[
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                         child: Column(
                           children: [
                             SizedBox(height: height * 0.01,),
                             Text('Phone Number, Required!', style: TextStyle(color: Colors.red, fontSize: width * 0.04, fontWeight: FontWeight.bold),),
                           ],
                         ),
                       ),
                     ],
                   ],
                 ),


                  // ... existing code ...
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                  width: double.infinity,
                  height: 10,
                  color: const Color.fromARGB(255, 241, 245, 249),
                ),
                 const SizedBox(
                  height: 20,
                ),
                  // Ensure that values are set for other UI elements
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        "Basic Details"),
                  ),
                  const SizedBox(
                  height: 10,
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_educationDetails.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "*Education:",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      for (var education in _educationDetails)
                        EducationWidget(
                          education: education,
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "*Key Skills:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        ..._savedSkills.join(',').split(',').map((skill) {
                          skill = skill
                              .trim(); // Remove leading and trailing whitespaces
                          skill = skill.replaceAll('[', '').replaceAll(']', '');
                          if (skill.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 0), // Decreased top padding
                              child: ListTile(
                                dense: true, // Reduces the height of the ListTile
                                contentPadding: EdgeInsets
                                    .zero, // Remove default ListTile padding
                                leading: const Icon(
                                  Icons.fiber_manual_record,
                                  size: 14,
                                  color: Colors
                                      .black, // Set the color of the bullet point
                                ),
                                title: Text(
                                  skill,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container for empty sub-skills
                          }
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: const Color.fromARGB(255, 241, 245, 249),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        "Other Details"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         "Internships:",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 24,
                  //         ),
                  //       ),
                  //       for (var internship in _internships)
                  //         InternshipWidget(internship),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           AddEducationButton(
                  //               onPressed: () {
                  //                 Get.to(InternshipForm(
                  //                   applicantId: widget.applicantId,
                  //                   emai: widget.emai,
                  //                   studentId: widget.studentId,
                  //                 ));
                  //               },
                  //               title: 'Add Internship'),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Internships:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_internshipDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "No internship details.....",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      if (_internshipDetails.isNotEmpty)
                        for (var internship in _internshipDetails)
                          InternshipWidget(
                            internship: internship,
                          ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Projects:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_projectDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "No project details.....",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      if (_projectDetails.isNotEmpty)
                        for (var project in _projectDetails)
                          ProjectWidget(
                            project: project,
                          ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Trainings:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_trainingDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "No training details.....",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      if (_trainingDetails.isNotEmpty)
                        for (var training in _trainingDetails)
                          TrainingWidget(
                            training: training,
                          ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ), child: Center(
        child: CircularProgressIndicator(key: loadingIndicatorKey),
      ),
      ),
    );
  }
}

class EducationWidget extends StatelessWidget {
  final Map<String, dynamic> education;


  const EducationWidget({super.key,
    required this.education,
  });

  @override
  Widget build(BuildContext context) {
    String eduTypeText;
    switch (education['edu_type']) {
      case 'pgraduation':
        eduTypeText = 'Post Graduation';
        break;
      case 'graduation':
        eduTypeText = 'Graduation';
        break;
      case 'hsecondary':
        eduTypeText = 'Senior Secondary';
        break;
      case 'secondary':
        eduTypeText = 'Secondary';
        break;
      default:
        eduTypeText = education['edu_type'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "$eduTypeText${education['edu_type'] == 'hsecondary' || education['edu_type'] == 'secondary' ? '' : ' - ${education['degree']}'}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
            ],
          ),
          Text(
            "${education['institute_name']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            education['edu_status'].toLowerCase().contains('completed') &&
                (education['edu_type'] == 'hsecondary' ||
                    education['edu_type'] == 'secondary')
                ? 'Year of completion: ${education['end_date']}'
                : education['edu_status'].toLowerCase().contains('pursuing') &&
                (education['edu_type'] == 'hsecondary' ||
                    education['edu_type'] == 'secondary')
                ? 'Expected Year of completion: ${education['end_date']}'
                : 'From ${education['start_date']} to ${education['end_date'] ?? 'Present'}',
            style: const TextStyle(fontSize: 18),
          ),
          Visibility(
            visible: education['edu_type'] != 'secondary',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Specialization: ",
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(child: Text(education['specialization'] ?? 'N/A',style: const TextStyle(fontSize: 18)))
              ],
            ),
          ),
          Text(
            "Performance: ${education['performance_scale']} - ${education['cgpa'] ??
                'N/A'}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class InternshipWidget extends StatelessWidget {
  final Map<String, dynamic> internship;


  const InternshipWidget({super.key,
    required this.internship,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${internship['int_profile']} ",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              
            ],
          ),
          Text(
            "${internship['int_org_name']}, ${internship['int_location']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "From ${internship['int_start_date']} to ${internship['int_end_date'] ?? 'Present'}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${internship['int_description']}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ProjectWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  

  const ProjectWidget({super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${project['prj_profile']} ",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              
            ],
          ),
          Text(
            "${project['prj_org_name']}, ${project['prj_location']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "From ${project['prj_start_date']} to ${project['prj_end_date'] ?? 'Present'}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${project['prj_description']}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TrainingWidget extends StatelessWidget {
  final Map<String, dynamic> training;
  

  const TrainingWidget({super.key,
    required this.training,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${training['tra_profile']} ",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              
            ],
          ),
          Text(
            "${training['tra_org_name']}, ${training['tra_location']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "From ${training['tra_start_date']} to ${training['tra_end_date'] ?? 'Present'}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${training['tra_description']}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
