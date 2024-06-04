import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internshipgate/screens/navPages/filters.dart';
import 'package:internshipgate/screens/navPages/stud_moredetails_page.dart';
import '../../utils/api_endpoints.dart';



class Internship {
  String orgLogo;
  String orgName;
  int id;
  int employerId;
  String email;
  String companyName;
  String industryType;
  String internshipDetails;
  String location;
  int totalOpening;
  String type;
  int duration1;
  String duration2;
  String startDate;
  String jobDescription;
  String stipendType;
  int compensation1;
  String compensation2;
  String perks;
  String skill;
  int active;
  String postingDate;

  Internship({
    required this.orgLogo,
    required this.orgName,
    required this.id,
    required this.employerId,
    required this.email,
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

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      orgLogo: json['org_logo'] ?? '',
      orgName: json['org_name'] ?? '',
      id: json['id'] ?? 0,
      employerId: json['employer_id'] ?? 0,
      email: json['email'] ?? '',
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

class InternshipPage extends StatefulWidget {
  final int studentId, applicantId;
  final String emai, fullname, emptoken;
  final VoidCallback refreshCallback;
  final bool complete_profile;
  final Function(int) onTabChange;
  const InternshipPage({
    Key? key,
    required this.studentId,
    required this.emai,
    required this.fullname,
    required this.emptoken,
    required this.applicantId,
    required this.refreshCallback,
    required this.onTabChange,
    required this.complete_profile,
  }) : super(key: key);

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

class _InternshipPageState extends State<InternshipPage> {
  List<Internship> internships = [];
  List<Internship> filteredInternships = [];

  TextEditingController searchController = TextEditingController();
  String _selectedCities = '';
  String _selectedSkills = '';
  String _selectedDuration = 'all-duration';
  String _selectedLastUpdate = 'all';
  String _selectedStipend = 'stipend-any';
  String _wfm = 'all';
  String _ifw = 'all';
  String _ft = 'all';
  String _pt = 'all';
  String _iwjo = 'all';
  String _ofo = 'all';
  int _currentPage = 1;
  int _totalInternships = 0;
  int _totalPages = 0;
  String message = '';
  List<int> favoriteInternships = [];


  @override
  void initState() {
    super.initState();
    fetchData();
    getfav(widget.studentId);
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
                      widget.onTabChange(3);
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

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        '${ApiEndPoints.baseUrl}search-internships/all-internships/all-duration/starting-immidiately/all/all/all/stipend-any/all/all/all/all?page=$_currentPage'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      _totalInternships = jsonDecode(response.body)['total'];
      _totalPages = jsonDecode(response.body)['last_page'];
      List<Internship> fetchedInternships =
          data.map((item) => Internship.fromJson(item)).toList();
      //print(data);
      

      setState(() {
        internships = fetchedInternships;
        filteredInternships = internships;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    fetchDataWithFilters();
  }

  void _prevPage() {
    setState(() {
      _currentPage--;
    });
    fetchDataWithFilters();
  }
  
  void filterInternships(String query) {
    setState(() {
      filteredInternships = internships
          .where((internship) => internship.companyName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleFavorite(Internship internship) {
    if (favoriteInternships.contains(internship.id)) {
      setState(() {
        favoriteInternships.remove(internship.id);
      });
    } else {
      setState(() {
        favoriteInternships.add(internship.id);
      });
    }
  }
  
  Future<void> addremfav(String employerInternshipId, studentId) async {
    try{
      Response response = await post(
        Uri.parse('${ApiEndPoints.baseUrl}addRemoveFavoriteInternship'),
        body: {
          'employerInternshipId' : employerInternshipId,
          'studentId' : studentId
        }
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        message = data['message'];
        print(data);
        Get.snackbar(
            'Added to',
            'Favourites'
        );
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getfav(int studentId) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getStudentFavoriteInternships/$studentId'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        data.forEach((element) {
          favoriteInternships.add(element);
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

  Future<void> fetchDataWithFilters() async {
    try {
      String apiUrl =
          '${ApiEndPoints.baseUrl}search-internships/';

      if (_selectedSkills != '' && _selectedCities != '' && _wfm != 'all') {
        apiUrl += '$_wfm-$_selectedSkills-internships-in-$_selectedCities';
      } else if (_selectedSkills != '' && _selectedCities != '') {
        apiUrl += '$_selectedSkills-internships-in-$_selectedCities';
      } else if (_selectedSkills != '' && _wfm != 'all') {
        apiUrl += '$_wfm-$_selectedSkills-all-internships';
      } else if (_selectedCities != '' && _wfm != 'all') {
        apiUrl += '$_wfm-internships-in-$_selectedCities';
      } else if (_selectedSkills != '') {
        apiUrl += '$_selectedSkills-all-internships';
      } else if (_selectedCities != '') {
        apiUrl += 'internships-in-$_selectedCities';
      } else if (_wfm != 'all') {
        apiUrl += '$_wfm-all-internships';
      } else {
        apiUrl += 'all-internships';
      }

      apiUrl +=
          '/$_selectedDuration/starting-immediately/$_ifw/$_pt/$_ft/$_selectedStipend/$_iwjo/$_ofo/$_selectedLastUpdate/all?page=$_currentPage';

      //print(apiUrl);

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        _totalInternships = jsonDecode(response.body)['total'];
        _totalPages = jsonDecode(response.body)['last_page'];
        List<Internship> fetchedInternships =
            data.map((item) => Internship.fromJson(item)).toList();
        //print(data);
        //print('hello');
        setState(() {
          internships = fetchedInternships;
          filteredInternships = internships;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle the error as needed, such as displaying an error message to the user.
      // You can also log the error or perform any other necessary actions.
    }
  }

  Future<void> applyForInternship(int internshipId, studentId) async {
    try {
      const apiUrl =
          '${ApiEndPoints.baseUrl}applyForInternship';
      final requestBody = {
        'internshipId': internshipId,
        'studentId': widget.studentId.toString(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['message'] == 'student_internship created') {
          Get.snackbar(
            'Success',
            ' !! Internship is applied successfully.',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Applied successfully');
          widget.refreshCallback.call();
        } else if (responseData['message'] == 'Already_applied') {
          Get.snackbar(
            'Error',
            ' !! Already applied',
            snackPosition: SnackPosition.BOTTOM,
          );
          print(
              'Already Applied: Student has already applied to the internship');
        } else if (responseData['message'] == 'No_software_skill') {
          // Handle case where student skills don't match
          Get.snackbar(
            'Skills not matched',
            ' !! Apply for our courses',
            snackPosition: SnackPosition.BOTTOM,
          );
          print(
              'Student skills not matched: No Student skills matched for the internship');
        } else {
          // Handle unknown response
          print('Unknown response: ${response.body}');
        }
      } else {
        // Handle failed API call
        print(
            'Failed to apply for internship. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors during the API call
      print('Error: $error');
    }
  }

  Future<void> applyNow(int internshipId) async {
    // Replace with the actual studentId from your data or state
    int studentId = widget.studentId;

    // Call the function to apply for the internship
    await applyForInternship(internshipId, studentId);
  }

  void refreshData() {
    fetchDataWithFilters();
  }

  void refreshData1() {
    _selectedCities = '';
    _selectedSkills = '';
    _selectedDuration = 'all-duration';
    _selectedLastUpdate = 'all';
    _selectedStipend = 'stipend-any';
    _wfm = 'all';
    _ifw = 'all';
    _ft = 'all';
    _pt = 'all';
    _iwjo = 'all';
    _ofo = 'all';
    fetchData();
  }

  void handleFilterCallback(String skills, String cities, String duration, String lastUpdate, String stipend, String wfm, String ifw, String ft, String pt, String iwjo, String ofo) {
    setState(() {
      _selectedSkills = skills;
      _selectedCities = cities;
      _selectedDuration = duration;
      _selectedLastUpdate = lastUpdate;
      _selectedStipend = stipend;
      _wfm = wfm;
      _ifw = ifw;
      _ft = ft;
      _pt = pt;
      _iwjo = iwjo;
      _ofo = ofo;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print('hello');
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.015,
          ),
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Search Internship',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: false,
                    controller: searchController,
                    onChanged: filterInternships,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 12.0,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 160, 159, 159),
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
                      hintText: 'Search Internship Post',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color.fromRGBO(44, 56, 149, 1),
                        ),
                        onPressed: () {
                          if (searchController.text.isNotEmpty) {
                            fetchDataWithFilters();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.015),
                SizedBox(
                  width: width * 0.2,
                  height: height * 0.055,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => Filter(callback: handleFilterCallback,refreshCallback: refreshData, refreshCallback1: refreshData1, skills: _selectedSkills.isNotEmpty ? _selectedSkills.split(',').map((e) => e.trim()).toList() : [], cities: _selectedCities.isNotEmpty ? _selectedCities.split(',').map((e) => e.trim()).toList() : [], duration: _selectedDuration, lastUpdate: _selectedLastUpdate, stipend: _selectedStipend, wfh: _wfm, ifw: _ifw, ft: _ft, pt: _pt, iwjo: _iwjo, ofo: _ofo));
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      foregroundColor: Colors.grey.shade600,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      padding: EdgeInsets.symmetric(vertical: height * 0.005, horizontal: width * 0.03),
                    ),
                    child: Text('Filters', style: TextStyle(fontSize: width * 0.04),),
                  ),
                ),
                /*DropdownButton<String>(
                  value: selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                      fetchDataWithFilters();
                    });
                  },
                  items: <String>[
                    'all',
                    'Mumbai',
                    'Delhi',
                    'Bangalore',
                    'Hyderabad',
                    'Chennai',
                    'Kolkata',
                    'Pune',
                    'Ahmedabad',
                    'Jaipur',
                    'Lucknow',
                    'Kanpur',
                    'Nagpur',
                    'Indore',
                    'Thane',
                    'Bhopal',
                    'Visakhapatnam',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedSkills,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSkills = newValue!;
                      fetchDataWithFilters();
                    });
                  },
                  items: <String>['all', 'PHP', 'Python', 'Java']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),*/
              ],
            ),
          ),
          SizedBox(height: height * 0.01,),
          Text(
            'Showing ${searchController.text.isNotEmpty ? filteredInternships.length.toString() : '$_totalInternships'} Internships',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredInternships.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: ListTile(
    //                       leading: CircleAvatar(

    //                         radius: 25,
    //   child: ClipOval(
    //     child: Image.network(
    //       'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/${filteredInternships[index].orgLogo}',
    //       // fit: BoxFit.cover,
    //       width: 50,
    //       height: 50,
    //       errorBuilder: (context, error, stackTrace) {
    //         // Handle error (invalid URL, network issue, etc.)
    //         // You can return a default image or null, or any other widget
    //         return const Icon(Icons.work);
    //       },
    //     ),
    //   ),
    // ),
                        leading: CircleAvatar(
      radius:30,
      backgroundColor: Colors.white, // Set background color if needed
      child: Container(
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
        'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/${filteredInternships[index].orgLogo}',
        width: 60,
        height: 60,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.work);
        },
      ),
    ),
      ),
    ),

    // CircleAvatar(
    //   radius: 50,
    //   backgroundColor: Colors.white,
    //   child: ClipOval(
    //     child: Image.network(
    //       'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/$_pic',
    //       width: 100, // Set the width to be the double of the radius
    //       height: 100, // Set the height to be the double of the radius
    //       fit: BoxFit.cover,
    //       errorBuilder: (context, error, stackTrace) {
    //         // Handle error (invalid URL, network issue, etc.)
    //         // You can return a default image or null, or any other widget
    //         return const Icon(Icons.work);
    //       },
    //     ),
    //   ),
    // ),


                      title: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              filteredInternships[index].companyName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              (favoriteInternships.contains(filteredInternships[index].id)) ? Icons.favorite : Icons.favorite_border, // Initial state assuming not a favorite
                              color: (favoriteInternships.contains(filteredInternships[index].id)) ? Colors.red : null, // Initial color for non-favorite
                            ),
                            onPressed: () async {
                              String employerInternshipId = filteredInternships[index].id.toString();
                              String studentId = widget.studentId.toString();

                              // Make the API call
                              await addremfav(employerInternshipId, studentId);
                              toggleFavorite(filteredInternships[index]);
                            },
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('Internship Details: ${filteredInternships[index].internshipDetails}'),
                          Text('Location: ${filteredInternships[index].location}'),
                          Text('Type: ${filteredInternships[index].type}'),
                          Text('Duration: ${filteredInternships[index].duration1} ${filteredInternships[index].duration2}'),

                          Row(
                            children: [
                              ElevatedButton(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InternshipDetailPage(
                                        studentId: widget.studentId,
                                        internshipId:
                                            filteredInternships[index].id,
                                        applyForInternshipCallback:
                                            applyForInternship,
                                            complete_profile: widget.complete_profile,
                                            refreshCallback: profileData,
                                      ),
                                    ),
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Text(
                                  'More Details',
                                  style: TextStyle(
                                    fontSize: width * 0.035,
                                    color: const Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: width * 0.015),
                              ElevatedButton(
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
                                  if (widget.complete_profile) {
                                    profileData();
                                  } else {
                                    applyForInternship(
                                      filteredInternships[index].id,
                                      widget.studentId);
                                  }
                                },
                                child: Text(
                                  'Apply Now',
                                  style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: width * 0.035),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
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
