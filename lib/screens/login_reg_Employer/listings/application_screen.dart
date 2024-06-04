import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internshipgate/screens/login_reg_Employer/listings/schedule_interview.dart';
import 'package:internshipgate/screens/login_reg_Employer/listings/schedule_interview_update.dart';
import '../../../utils/api_endpoints.dart';
import '../../auth_screen.dart';
import '../emp_view_profile.dart';
import 'message_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  final int id, recId;
  final String email, fullname, emptoken;

  const ApplicationsScreen(
      {super.key,
      required this.id,
      required this.email,
      required this.fullname,
      required this.emptoken,
      required this.recId});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final loadingIndicatorKey = const ValueKey('loading');
  final TextEditingController textEditingController = TextEditingController();
  String internshipDetails = '';
  String location = '';
  int duration1 = 0;
  String duration2 = '';
  String startDate = '';
  int compensation1 = 0;
  String compensation2 = '';
  String internship_status = '';
  int applied = 0;
  int shortlist = 0;
  int hire = 0;
  int reject = 0;
  int totalRecords = 0;
  List<String> selectedSkills = [];
  List<String> selectedCities = [];
  List<Map<String, String>> skills = [];
  List<Map<String, String>> items = [];
  List<Map<String, dynamic>> students = [];
  List<dynamic> decodedData = [];
  String selectedStatus = 'All';
  bool isLoading = true;
  int currentPage = 0;
  int pageSize = 10;
  int lastPage = 0;
  int from = 0;
  int to = 0;
  int total = 0;
  int totalPages = 0;
  String displayCandidates = '';


  @override
  void initState() {
    super.initState();
    skill();
    cities();
    loadData().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        if (internship_status == 'Active') {
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
                      //backgroundColor: Colors.white,
                      elevation: 1,
                      title: Center(child: Icon(Icons.safety_check, size: width * 0.1, color: const Color.fromRGBO(44, 56, 149, 1),)),
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
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Recruit certified interns by', style: TextStyle(fontSize: width * 0.05,)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Internship', style: TextStyle(fontSize: width * 0.05, color: const Color.fromRGBO(44, 56, 149, 1))),
                              Text('gate', style: TextStyle(fontSize: width * 0.05, color: const Color.fromRGBO(249, 143, 67, 1))),
                            ],
                          ),
                        ],
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.043,
                          child: IntrinsicWidth(
                            child: ElevatedButton(
                              onPressed: () {
                                handleStatusTap('Internshipgate Certified Interns');
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'View certified Interns',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.015,),
                        SizedBox(
                          height: height * 0.043,
                          child: IntrinsicWidth(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            },
          );
        }
      });
    });
  }

  app(String id) async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getEmployerInternshipById/$id'),
      );
      if (response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body.toString());
          //print(data);
          internshipDetails = data['internship_details'];
          location = data['location'];
          duration1 = data['duration1'];
          duration2 = data['duration2'] == 'M' ? 'Months' : (data['duration2'] == 'W' ? 'Weeks' : data['duration2']);
          startDate = data['startdate'];
          compensation1 = data['compensation1'] ?? 0;
          compensation2 = data['compensation2'] == 'Months' ? 'Monthly' : (data['compensation2'] == 'Weeks' ? 'Weekly' : data['compensation2']);
          internship_status = data['internship_status'];
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  card(String id) async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getInternshipSummeryCard/$id'),
      );
      if (response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body.toString());
          //print(data);
          applied = int.parse(data['applied'].toString());
          shortlist = int.parse(data['shortlist'].toString());
          hire = int.parse(data['hire'].toString());
          reject = int.parse(data['reject'].toString());
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<dynamic>> stu(String id) async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getApplicantListForInternship/$id'),
      );
      if(response.statusCode == 200) {
        decodedData = jsonDecode(response.body.toString());
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
    return decodedData;
  }

  Future<List<dynamic>> stuShort(String id) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getApplicantListForInternship/$id/1'),
      );
      if(response.statusCode == 200) {
        decodedData = jsonDecode(response.body.toString());
        //print(decodedData);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
    return decodedData;
  }

  Future<List<dynamic>> stuHire(String id) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getApplicantListForInternship/$id/2'),
      );
      if(response.statusCode == 200) {
        decodedData = jsonDecode(response.body.toString());
        //print(decodedData);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
    return decodedData;
  }

  Future<List<dynamic>> stuReject(String id) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getApplicantListForInternship/$id/4'),
      );
      if(response.statusCode == 200) {
        decodedData = jsonDecode(response.body.toString());
        //print(decodedData);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
    return decodedData;
  }

  aiProf(String id, List<String> selectedSkills, List<String> selectedCities, int page) async {
    try {
      String skillsQueryParam = selectedSkills.isNotEmpty ? selectedSkills.join(',') : 'null';
      String citiesQueryParam = selectedCities.isNotEmpty ? selectedCities.join(',') : 'null';

      String url = '${ApiEndPoints.baseUrl}inviteCandidate/$id/$skillsQueryParam/$citiesQueryParam/$page';
      //print('Calling AI recommended profiles API at URL: $url');

      final response = await get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          totalRecords = responseData['totalRecords'];
          List<dynamic> studentListData = responseData['studentList'];
          students = List<Map<String, dynamic>>.from(studentListData.map((data) {
            return data as Map<String, dynamic>? ?? {};
          }));
        });
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  IGcert(String id, List<String> selectedSkills, List<String> selectedCities, int page) async {
    try {
      String skillsQueryParam = selectedSkills.isNotEmpty ? selectedSkills.join(',') : 'null';
      String citiesQueryParam = selectedCities.isNotEmpty ? selectedCities.join(',') : 'null';

      String url = '${ApiEndPoints.baseUrl}getVIStudents/$id/$skillsQueryParam/$citiesQueryParam?page=$page';

      final response = await get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          students = List<Map<String, dynamic>>.from(responseData['studentList']['data']);
          lastPage = responseData['studentList']['last_page'];
          from = responseData['studentList']['from'];
          to = responseData['studentList']['to'];
          total = responseData['studentList']['total'];
        });
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
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
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  skill() async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getSoftwareSkill'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          skills = data.map<Map<String, String>>((item1) => {
            'value' : item1['value'].toString(),
            'label' : item1['label'].toString(),
          }).toList();
        });
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  cities() async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getLocationMasterDetails'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          items = data.map<Map<String, String>>((item) => {
            'value' : item['value'].toString(),
            'label' : item['label'].toString(),
          }).toList();
        });
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  loadData() async {
    try {
      await app(widget.id.toString());
      await card(widget.id.toString());
      final List<dynamic> studentsData = await stu(widget.id.toString());
      setState(() {
        isLoading = false;
      });
      students = studentsData.map((student) => Map<String, dynamic>.from(student)).toList();
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> filterStudents(List<Map<String, dynamic>> students, List<String> selectedCities, List<String> selectedSkills) {
    return students.where((student) {
      bool cityMatch = selectedCities.isEmpty || selectedCities.any((city) => student['student_location'].contains(city));
      bool skillMatch = selectedSkills.isEmpty || selectedSkills.any((skill) => (student['software_skill']?? '').split(',').contains(skill));
      return cityMatch && skillMatch;
    }).toList();
  }

  Future<void> handleStatusTap(String status) async {
    setState(() {
      selectedStatus = status;
      selectedSkills = [];
      selectedCities = [];
      currentPage = 0;
    });
    switch (status) {
      case 'Shortlisted':
        List<dynamic> studentsData = await stuShort(widget.id.toString());
        setState(() {
          students = studentsData.map((student) => Map<String, dynamic>.from(student)).toList();
        });
        break;
      case 'Hired/Offer Sent':
        List<dynamic> studentsData = await stuHire(widget.id.toString());
        setState(() {
          students = studentsData.map((student) => Map<String, dynamic>.from(student)).toList();
        });
        break;
      case 'Rejected':
        List<dynamic> studentsData = await stuReject(widget.id.toString());
        setState(() {
          students = studentsData.map((student) => Map<String, dynamic>.from(student)).toList();
        });
        break;
      case 'AI Recommended Profiles':
        aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
        break;
      case 'Internshipgate Certified Interns':
        IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
        break;
      default:
        loadData();
    }
  }

  void onShortlistPressed(String internshipId, studentId) async {
    await shortcand(internshipId, studentId);
    loadData();
    card(widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<Map<String, dynamic>> filteredStudents = filterStudents(students, selectedCities, selectedSkills);
    if (selectedStatus == 'AI Recommended Profiles') {
      totalPages = (totalRecords / pageSize).ceil();
    } else if (selectedStatus == 'Internshipgate Certified Interns') {
      totalPages = lastPage;
    } else {
      totalPages = (filteredStudents.length / pageSize).ceil();
    }
    if (selectedStatus == 'AI Recommended Profiles') {
      displayCandidates = 'Showing ${(currentPage * pageSize) + 1} - ${((currentPage + 1) * pageSize).clamp(0, totalRecords)} of $totalRecords candidates';
    } else if (selectedStatus == 'Internshipgate Certified Interns') {
      displayCandidates = 'Showing $from - $to of $total candidates';
    } else {
      displayCandidates = 'Showing ${(currentPage * pageSize) + 1} - ${((currentPage + 1) * pageSize).clamp(0, filteredStudents.length)} of ${filteredStudents.length} candidates';
    }
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.to(() => const AuthPage()); // Use a callback to instantiate AuthScreen
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
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Applications for', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.07)),
                SizedBox(height: height * 0.005,),
                Text(internshipDetails, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.07, color: const Color.fromRGBO(249, 143, 67, 1))),
                SizedBox(height: height * 0.01,),
                const Divider(thickness: 1.5,),
                SizedBox(height: height * 0.015,),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade50,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => handleStatusTap('All'),
                        child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: selectedStatus == 'All' ? Colors.blueGrey.shade100 : Colors.transparent,
                            border: Border.all(color: selectedStatus == 'All' ? Colors.grey.shade100 : Colors.transparent),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Students Applied', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'All' ? FontWeight.bold : FontWeight.normal,),),
                              Text(applied.toString(), style: TextStyle(fontSize: width * 0.04, color: Colors.indigo, fontWeight: selectedStatus == 'All' ? FontWeight.bold : FontWeight.normal,),)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleStatusTap('Shortlisted'),
                        child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: selectedStatus == 'Shortlisted' ? Colors.blueGrey.shade100 : Colors.transparent,
                            border: Border.all(color: selectedStatus == 'Shortlisted' ? Colors.blueGrey.shade100 : Colors.transparent),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shortlisted', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'Shortlisted' ? FontWeight.bold : FontWeight.normal,),),
                              Text(shortlist.toString(), style: TextStyle(fontSize: width * 0.04, color: Colors.indigo, fontWeight: selectedStatus == 'Shortlisted' ? FontWeight.bold : FontWeight.normal,),)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleStatusTap('Hired/Offer Sent'),
                        child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: selectedStatus == 'Hired/Offer Sent' ? Colors.blueGrey.shade100 : Colors.transparent,
                            border: Border.all(color: selectedStatus == 'Hired/Offer Sent' ? Colors.blueGrey.shade100 : Colors.transparent),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Hired', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'Hired/Offer Sent' ? FontWeight.bold : FontWeight.normal,),),
                              Text(hire.toString(), style: TextStyle(fontSize: width * 0.04, color: Colors.indigo, fontWeight: selectedStatus == 'Hired/Offer Sent' ? FontWeight.bold : FontWeight.normal,),)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleStatusTap('Rejected'),
                        child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: selectedStatus == 'Rejected' ? Colors.blueGrey.shade100 : Colors.transparent,
                            border: Border.all(color: selectedStatus == 'Rejected' ? Colors.blueGrey.shade100 : Colors.transparent,),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rejected', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'Rejected' ? FontWeight.bold : FontWeight.normal,),),
                              Text(reject.toString(), style: TextStyle(fontSize: width * 0.04, color: Colors.indigo, fontWeight: selectedStatus == 'Rejected' ? FontWeight.bold : FontWeight.normal,),)
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleStatusTap('AI Recommended Profiles'),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: selectedStatus == 'AI Recommended Profiles' ? Colors.blueGrey.shade100 : Colors.transparent,
                            border: Border.all(color: selectedStatus == 'AI Recommended Profiles' ? Colors.blueGrey.shade100 : Colors.transparent,),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text('AI Recommended Profiles', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'AI Recommended Profiles' ? FontWeight.bold : FontWeight.normal,)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => handleStatusTap('Internshipgate Certified Interns'),
                        child: IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: selectedStatus == 'Internshipgate Certified Interns' ? Colors.blueGrey.shade100 : Colors.transparent,
                              border: Border.all(color: selectedStatus == 'Internshipgate Certified Interns' ? Colors.blueGrey.shade100 : Colors.transparent,),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.collections_bookmark_outlined, size: width * 0.06, color: Colors.green,),
                                SizedBox(width: width * 0.02,),
                                Row(
                                  children: [
                                    Text('Internship', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'Internshipgate Certified Interns' ? FontWeight.bold : FontWeight.normal, color: const Color.fromRGBO(44, 56, 149, 1))),
                                    Text('gate', style: TextStyle(fontSize: width * 0.04, fontWeight: selectedStatus == 'Internshipgate Certified Interns' ? FontWeight.bold : FontWeight.normal, color: const Color.fromRGBO(249, 143, 67, 1))),
                                  ],
                                ),
                                Text(' Certified Interns', style: TextStyle(fontWeight: selectedStatus == 'Internshipgate Certified Interns' ? FontWeight.bold : FontWeight.normal, fontSize: width * 0.04)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade50,
                  ),
                  width: double.infinity,
                  child: ExpansionTile(
                    shape: const Border(),
                    initiallyExpanded: false, // Set to true if you want it to be initially expanded
                    title: Text(
                      'Application Details',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('LOCATION:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                            SizedBox(height: height * 0.005),
                            Text(location, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                            SizedBox(height: height * 0.02),
                            Text('STARTS IN:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                            SizedBox(height: height * 0.005),
                            Text(startDate, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                            SizedBox(height: height * 0.02),
                            Text('DURATION:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                            SizedBox(height: height * 0.005),
                            Text('$duration1 $duration2', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                            SizedBox(height: height * 0.02),
                            Text('STIPEND:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                            SizedBox(height: height * 0.005),
                            Text((compensation1 == 0 && compensation2.isEmpty) ? 'Unpaid' : '$compensation1/$compensation2', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade50,
                  ),
                  width: double.infinity,
                  child: ExpansionTile(
                    shape: const Border(),
                    initiallyExpanded: false, // Set to true if you want it to be initially expanded
                    title: Text(
                      'Filters',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Wrap(
                                    runSpacing: -8.0,
                                    children: selectedSkills.map((skill) {
                                      return Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: InputChip(
                                          label: Text(skill),
                                          onDeleted: () {
                                            setState(() {
                                              selectedSkills.remove(skill);
                                              currentPage = 0;
                                              if (selectedStatus == 'AI Recommended Profiles') {
                                                aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                              } else if (selectedStatus == 'Internshipgate Certified Interns') {
                                                IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Text(
                                        'Select Skills',
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                      items: skills.map((item) => DropdownMenuItem(
                                        value: item['value'],
                                        child: Text(
                                          item['label']!,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      )).toList(),
                                      onChanged: (value) {
                                        if (!selectedSkills.contains(value)) {
                                          setState(() {
                                            selectedSkills.add(value!);
                                            print(selectedSkills);
                                            currentPage = 0;
                                            if (selectedStatus == 'AI Recommended Profiles') {
                                              aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                            } else if (selectedStatus == 'Internshipgate Certified Interns') {
                                              IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                            }
                                          });
                                        }
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        height: 58,
                                        width: double.infinity,
                                      ),
                                      dropdownStyleData: const DropdownStyleData(
                                        maxHeight: 500,
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 50,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: textEditingController,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 60,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: textEditingController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText: 'Search...',
                                              hintStyle: const TextStyle(fontSize: 16),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (skill, searchValue) {
                                          return skill.value!
                                              .toLowerCase()
                                              .toString()
                                              .contains(searchValue.toLowerCase());
                                        },
                                      ),
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          textEditingController.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.01,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Wrap(
                                    runSpacing: -8.0, // This will make chips flow to the next line when needed
                                    children: selectedCities.map((city) {
                                      return Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: InputChip(
                                          label: Text(city),
                                          onDeleted: () {
                                            setState(() {
                                              selectedCities.remove(city);
                                              currentPage = 0;
                                              if (selectedStatus == 'AI Recommended Profiles') {
                                                aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                              } else if (selectedStatus == 'Internshipgate Certified Interns') {
                                                IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Text(
                                        'Select City',
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                      items: items.map((item) => DropdownMenuItem(
                                        value: item['value'],
                                        child: Text(
                                          item['label']!,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      )).toList(),
                                      onChanged: (value) {
                                        if (!selectedCities.contains(value)) {
                                          setState(() {
                                            selectedCities.add(value!);
                                            currentPage = 0;
                                            if (selectedStatus == 'AI Recommended Profiles') {
                                              aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                            } else if (selectedStatus == 'Internshipgate Certified Interns') {
                                              IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                                            }
                                          });
                                        }
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        height: 58,
                                        width: double.infinity,
                                      ),
                                      dropdownStyleData: const DropdownStyleData(
                                        maxHeight: 500,
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 50,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: textEditingController,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 60,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: textEditingController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText: 'Search for your city',
                                              hintStyle: const TextStyle(fontSize: 16),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value!
                                              .toLowerCase()
                                              .toString()
                                              .contains(searchValue.toLowerCase());
                                        },
                                      ),
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          textEditingController.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02,),
                Visibility(
                  visible: selectedStatus == 'Internshipgate Certified Interns',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        RichText(
                            textAlign: TextAlign.justify,
                            text: const TextSpan(
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              children: <TextSpan> [
                                TextSpan(text: 'Following students have completed the virtual internship program at ', style: TextStyle(color: Colors.black)),
                                TextSpan(text: 'Internship', style: TextStyle(color: Color.fromRGBO(44, 56, 149, 1))),
                                TextSpan(text: 'gate', style: TextStyle(color: Color.fromRGBO(249, 143, 67, 1))),
                              ]
                            )
                        ),
                        SizedBox(height: height * 0.015,),
                      ],
                    ),
                  ),
                ),
                Center(child: Text(displayCandidates, style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold))),
                SizedBox(height: height * 0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 0
                          ? () {
                        setState(() {
                          currentPage--;
                          if (selectedStatus == 'AI Recommended Profiles') {
                            aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                          } else if (selectedStatus == 'Internshipgate Certified Interns') {
                            IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                          }
                        });
                      } : null,
                      child: const Text('Previous'),
                    ),
                    SizedBox(width: width * 0.01,),
                    Text(
                      "Page ${currentPage + 1} of $totalPages",
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                    SizedBox(width: width * 0.01,),
                    ElevatedButton(
                      onPressed: currentPage < totalPages - 1
                          ? () {
                        setState(() {
                          currentPage++;
                          if (selectedStatus == 'AI Recommended Profiles') {
                            aiProf(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                          } else if (selectedStatus == 'Internshipgate Certified Interns') {
                            IGcert(widget.id.toString(), selectedSkills, selectedCities, currentPage+1);
                          }
                        });
                      } : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02,),
                if (selectedStatus == 'AI Recommended Profiles' || selectedStatus == 'Internshipgate Certified Interns')
                  for (Map<String, dynamic> student in students)
                    StudentCard(student: student, selectedStatus: selectedStatus, internshipId: widget.id, studentId: 0, onShortlistPressed: onShortlistPressed, internship_details: internshipDetails, emptoken: widget.emptoken, intstat: internship_status,)
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (currentPage + 1) * pageSize <= filteredStudents.length
                        ? pageSize
                        : filteredStudents.length % pageSize,
                    itemBuilder: (context, index) {
                      return StudentCard(
                        student: filteredStudents[currentPage * pageSize + index],
                        selectedStatus: selectedStatus, internshipId: widget.id, studentId: 0, onShortlistPressed: onShortlistPressed, internship_details: internshipDetails, emptoken: widget.emptoken, intstat: internship_status,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(key: loadingIndicatorKey),
        ),
      ),
    );
  }
}

class StudentCard extends StatefulWidget {
  final Map<String, dynamic> student;
  final String selectedStatus, internship_details, emptoken, intstat;
  final int internshipId, studentId;
  final Function(String, String) onShortlistPressed;

  const StudentCard({Key? key, required this.student, required this.selectedStatus, required this.internshipId, required this.studentId, required this.onShortlistPressed, required this.internship_details, required this.emptoken, required this.intstat}) : super(key: key);

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  int studentId = 0;
  String studentName = '';
  String loc = '';
  String softwareSkill = '';
  String degree = '';
  String createdAt = '';
  String appStat = '';
  int percentMatches = 0;
  String Stat = '';
  int Active = 0;
  String validity_date = '';
  String all_courses = '';
  String internship_status = '';
  int idd = 0;
  int? interviewId;

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
        } else {
          Get.snackbar(
            'Success',
            'Applicant Rejected Successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
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

  @override
  Widget build(BuildContext context) {
    idd = widget.student['id'];
    int currentId = idd;
    studentId = widget.student['student_id'];
    String currentStudentId = studentId.toString();
    studentName = widget.student['student_name'] as String? ?? 'N/A';
    String currentStudentName = studentName;
    interviewId = widget.student['interview_id'];
    int? currentInterview = interviewId;
    loc = widget.student['student_location'] as String? ?? 'N/A';
    softwareSkill = widget.student['software_skill'] as String? ?? 'N/A';
    degree = widget.student['degree'] as String? ?? 'N/A';
    createdAt = widget.student['profile_creation_date'] as String? ?? 'N/A';
    appStat = widget.student['application_status'] as String? ?? 'N/A';
    String currentStat = appStat.toString();
    bool isHired = appStat == 'Hired/Offer Sent';
    bool isShortlisted = appStat == 'Shortlisted';
    internship_status = widget.intstat;
    percentMatches = widget.student['percentMatch'] ?? 0;
    Stat = widget.student['internship_status'] ?? 'N/A';
    Active = widget.student['activity_rank'] ?? 0;
    all_courses = widget.student['all_courses'] ?? 'N/A';
    validity_date = widget.student['validity_date'] ?? 'N/A';
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(studentName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.06))),
                    if (isHired)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[800], size: width * 0.045,),
                          SizedBox(width: width * 0.01,),
                          Text('HIRED', style: TextStyle(color: Colors.green[800], fontSize: width * 0.04),),
                        ],
                      )
                    else if (isShortlisted)
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.grey[600], size: width * 0.045,),
                          SizedBox(width: width * 0.01,),
                          Text('SHORTLISTED', style: TextStyle(color: Colors.grey[600], fontSize: width * 0.04),),
                        ],
                      ),
                  ],
                ),
                Visibility(
                  visible: widget.selectedStatus == 'AI Recommended Profiles',
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.01,),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
                              decoration: BoxDecoration(
                                color: percentMatches == 100
                                    ? Colors.green.shade700
                                    : percentMatches > 20
                                    ? const Color.fromRGBO(249, 143, 67, 1)
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text('${percentMatches.toString()}% skills match', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.03),)
                          ),
                          SizedBox(width: width * 0.02,),
                          if (Active > 0)
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade100,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Iconsax.user_tick, size: width * 0.04, color: const Color.fromRGBO(44, 56, 149, 1),),
                                    SizedBox(width: width * 0.01,),
                                    Text('Actively looking', style: TextStyle(color: const Color.fromRGBO(44, 56, 149, 1), fontWeight: FontWeight.bold, fontSize: width * 0.03),),
                                  ],
                                )
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.selectedStatus == 'Internshipgate Certified Interns' && Active > 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.01,),
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.user_tick, size: width * 0.04, color: const Color.fromRGBO(44, 56, 149, 1),),
                              SizedBox(width: width * 0.01,),
                              Text('Actively looking', style: TextStyle(color: const Color.fromRGBO(44, 56, 149, 1), fontWeight: FontWeight.bold, fontSize: width * 0.03),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Visibility(
                  visible: widget.selectedStatus == 'Internshipgate Certified Interns',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.settings, size: width * 0.05, color: Colors.blueGrey.shade600,),
                          SizedBox(width: width * 0.01,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SKILLS:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                                SizedBox(height: height * 0.001,),
                                Text(softwareSkill, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.selectedStatus == 'Internshipgate Certified Interns',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.collections_bookmark, size: width * 0.05, color: Colors.blueGrey.shade600,),
                          SizedBox(width: width * 0.01,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CERTIFIED IN:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                                SizedBox(height: height * 0.001,),
                                Text(all_courses, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.selectedStatus != 'Internshipgate Certified Interns',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.settings, size: width * 0.05, color: Colors.blueGrey.shade600,),
                          SizedBox(width: width * 0.01,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SKILLS:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                                SizedBox(height: height * 0.001,),
                                Text(softwareSkill, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_pin, size: width * 0.05, color: Colors.blueGrey.shade600,),
                    SizedBox(width: width * 0.01,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LOCATION:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                          SizedBox(height: height * 0.001,),
                          Text(loc, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.school, size: width * 0.05, color: Colors.blueGrey.shade600,),
                    SizedBox(width: width * 0.01,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EDUCATION:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                          SizedBox(height: height * 0.001,),
                          Text(degree, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Visibility(
                  visible: widget.selectedStatus != 'Internshipgate Certified Interns',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.schedule_outlined, size: width * 0.05, color: Colors.blueGrey.shade600,),
                          SizedBox(width: width * 0.01,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PROFILE CREATED ON:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                                SizedBox(height: height * 0.001,),
                                Text(createdAt, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.selectedStatus == 'Internshipgate Certified Interns',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, size: width * 0.05, color: Colors.blueGrey.shade600,),
                          SizedBox(width: width * 0.01,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('INTERNSHIP STATUS:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                                SizedBox(height: height * 0.001,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
                                  decoration: BoxDecoration(
                                    color: Stat == 'Pursuing' ? Colors.green.shade700 : const Color.fromRGBO(44, 56, 149, 1),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(Stat, style: TextStyle(color: Colors.white, fontSize: width * 0.04),),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.selectedStatus == 'Internshipgate Certified Interns',
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.calendar_month, size: width * 0.05, color: Colors.blueGrey.shade600,),
                          SizedBox(width: width * 0.01,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('INTERNSHIP COMPLETION DATE:', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04)),
                                SizedBox(height: height * 0.001,),
                                Text(validity_date, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: width * 0.04),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: isHired ? width * 0.77 : width * 0.38,
                      height: height * 0.048,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => ViewProfilePage(studentId: currentStudentId, currentStat: currentStat, intshipId: widget.internshipId.toString(),));
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)
                            ),
                            foregroundColor: const Color.fromRGBO(44, 56, 149, 1),
                            side: const BorderSide(color: Color.fromRGBO(249, 143, 67, 1), width: 2),
                          padding: EdgeInsets.symmetric(vertical: height * 0.012,horizontal: width * 0.04),
                        ),
                        child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('View Profile', style: TextStyle(color: Color.fromRGBO(249, 143, 67, 1)),)),
                      ),
                    ),
                    if (!isShortlisted && !isHired)
                      IgnorePointer(
                        ignoring: internship_status != 'Active',
                        child: Opacity(
                          opacity: internship_status != 'Active' ? 0.5 : 1.0,
                          child: SizedBox(
                            width: width * 0.38,
                            height: height * 0.048,
                            child: OutlinedButton(
                              onPressed: () async {
                                widget.onShortlistPressed(widget.internshipId.toString(), currentStudentId);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.grey.shade400,
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('Shortlist')),
                            ),
                          ),
                        ),
                      )
                    else if (isShortlisted)
                      Opacity(
                        opacity: internship_status != 'Active' ? 0.5 : 1.0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.16,
                              height: height * 0.048,
                              child: OutlinedButton(
                                onPressed: () {
                                  hirerejcand(widget.internshipId.toString(), 2);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green.shade600,
                                  side: BorderSide(color: Colors.green.shade600,),
                                ),
                                child: const FittedBox(
                                    fit: BoxFit.none,
                                    child: Text('Hire', style: TextStyle(fontWeight: FontWeight.bold),)
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.015,),
                            SizedBox(
                              width: width * 0.2,
                              height: height * 0.048,
                              child: OutlinedButton(
                                onPressed: () {
                                  hirerejcand(widget.internshipId.toString(), 4);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)
                                  ),
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red,),
                                ),
                                child: const FittedBox(
                                    fit: BoxFit.none,
                                    child: Text('Reject', style: TextStyle(fontWeight: FontWeight.bold),)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: height * 0.008,),
                IgnorePointer(
                  ignoring: internship_status != 'Active',
                  child: Opacity(
                    opacity: internship_status != 'Active' ? 0.5 : 1.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width * 0.38,
                          height: height * 0.048,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.to(() => MessageScreenEmp(fullname: currentStudentName, emptoken: widget.emptoken, id: currentId,));
                            },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)
                                ),
                              foregroundColor: Colors.indigo,
                              side: const BorderSide(color: Colors.green, width: 2),
                              //padding: EdgeInsets.symmetric(vertical: height * 0.012,horizontal: width * 0.04),
                            ),
                            child: const FittedBox(
                                fit: BoxFit.none,
                                child: Text('Chat', style: TextStyle(color: Colors.green),)),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.38,
                          height: height * 0.048,
                          child: OutlinedButton(
                            onPressed: () {
                              if (currentInterview == null) {
                                Get.to(() => ScheduleScreenEmp(id: widget.internshipId, internshipDetails: widget.internship_details, stuname: currentStudentName, emptoken: widget.emptoken, currentId: currentId,));
                              } else {
                                Get.to(() => ScheduleScreenUpEmp(id: widget.internshipId, internshipDetails: widget.internship_details, stuname: currentStudentName, emptoken: widget.emptoken, currentId: currentId, interviewId: currentInterview,));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                              side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1),),
                            ),
                            child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Schedule Interview')
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.005,)
      ],
    );
  }
}
