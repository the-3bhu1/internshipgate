import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart';
import 'package:internshipgate/screens/auth_screen.dart';

import '../../utils/api_endpoints.dart';

class StudApplicationList extends StatefulWidget {
  final int studentId;

  const StudApplicationList({super.key, required this.studentId});

  @override
  State<StudApplicationList> createState() => _StudApplicationListState();
}

class _StudApplicationListState extends State<StudApplicationList> {
  var applications = [];
  String _selectedListType = 'All';
  var filteredApplications = [];

  @override
  void initState() {
    super.initState();
    _fetchApplications(widget.studentId.toString(), 'All').then((value) {
      setState(() {
        filteredApplications = applications;
      });
    });
  }

  Future<List<dynamic>> _fetchApplications(
      String studentId, String listType) async {
    try {
      String endpoint;
      if (listType == 'All') {
        endpoint = 'getStudentInternshipApplications/$studentId';
      } else {
        endpoint = 'getStudentInternshipApplications/$studentId/$listType';
      }

      Response response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}$endpoint'),
      );

      if (response.statusCode == 200) {
        applications = jsonDecode(response.body.toString());
        print(applications);
        return applications;
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> _fetchShortlistedApplications(String studentId) async {
    try {
      Response response = await get(
        Uri.parse(
            '${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/1'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> _fetchFavoritesApplications(String studentId) async {
    try {
      Response response = await get(
        Uri.parse(
            '${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/5'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> _fetchOfferReceivedApplications(
      String studentId) async {
    try {
      Response response = await get(
        Uri.parse(
            '${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/2'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> _fetchRejectedApplications(String studentId) async {
    try {
      Response response = await get(
        Uri.parse(
            '${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/1'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body.toString());
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  void _runFilter(String enteredKeyword) {
    var results = [];

    if (_selectedListType == 'All') {
      // Filter by keyword only
      results = applications
          .where((application) => application["internship_details"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    } else if (_selectedListType == 'Shortlisted') {
      // Fetch and filter shortlisted applications based on application_status: Shortlisted
      _fetchShortlistedApplications(widget.studentId.toString())
          .then((shortlistedApps) {
        results = shortlistedApps
            .where((application) =>
                application["internship_details"]
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) &&
                application["application_status"] == 'Shortlisted')
            .toList();

        setState(() {
          filteredApplications = results;
        });
      });
    } else if (_selectedListType == 'Favorites') {
      // Fetch and filter favorites applications
      _fetchFavoritesApplications(widget.studentId.toString())
          .then((favoritesApps) {
        results = favoritesApps
            .where((application) => application["internship_details"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();

        setState(() {
          filteredApplications = results;
        });
      });
    } else if (_selectedListType == 'Offer Received') {
      // Fetch and filter applications with Offer Received status
      _fetchOfferReceivedApplications(widget.studentId.toString())
          .then((offerReceivedApps) {
        results = offerReceivedApps
            .where((application) =>
                application["internship_details"]
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) &&
                application["hired_ind"] == 1)
            .toList();

        setState(() {
          filteredApplications = results;
        });
      });
    } else if (_selectedListType == 'Rejected') {
      // Fetch and filter applications with Rejected status
      _fetchRejectedApplications(widget.studentId.toString())
          .then((rejectedApps) {
        results = rejectedApps
            .where((application) =>
                application["internship_details"]
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) &&
                application["application_status"] == 'Rejected')
            .toList();

        setState(() {
          filteredApplications = results;
        });
      });
    } else {
      // Filter by both keyword and list type
      results = applications
          .where((application) =>
              application["internship_details"]
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              application["list_type"].toString() == _selectedListType)
          .toList();
    }

    setState(() {
      filteredApplications = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 5.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
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
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Internship Applications',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              // TextField(
              //   onChanged: (value) => _runFilter(value),
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
              //     labelText: 'Search Internship post',
              //     prefixIcon: const Icon(Icons.search),
              //   ),
              // ),
              TextField(
                onChanged: _runFilter,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
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
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color.fromRGBO(44, 56, 149, 1),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              DropdownButton<String>(
                dropdownColor: Colors.white,
                value: _selectedListType,
                items: [
                  'All',
                  'Shortlisted',
                  'Favorites',
                  'Offer Received',
                  'Rejected'
                ]
                    .map((listType) => DropdownMenuItem<String>(
                          value: listType,
                          child: Text(listType),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedListType = value ?? 'All';
                    if (_selectedListType != 'Favorites' &&
                        _selectedListType != 'Offer Received') {
                      _fetchApplications(
                              widget.studentId.toString(), _selectedListType)
                          .then((value) {
                        _runFilter('');
                      });
                    } else {
                      _runFilter('');
                    }
                  });
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              PaginatedDataTable(
                headingRowHeight: 80,
                rowsPerPage: 8, // Set the number of rows per page
                columns: const [
                  DataColumn(
                      label: Text('Company Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))),
                  DataColumn(
                      label: Text('Internship Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))),
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))),
                  DataColumn(
                      label: Text('Status',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))),
                ],
                source: _YourCustomDataTableSource(
                    filteredApplications: filteredApplications),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _YourCustomDataTableSource extends DataTableSource {
  var filteredApplications = [];

  _YourCustomDataTableSource({required this.filteredApplications});

  Color _getButtonColor(String status) {
    switch (status) {
      case 'Not Shortlisted':
        return const Color.fromRGBO(249, 143, 67, 1); // Blue
      case 'Rejected':
        return Colors.red;
      case 'Hired':
        return Colors.green;
      case 'Shortlisted':
        return const Color.fromARGB(255, 59, 176, 254); // Your original color
      default:
        return Colors.grey; // You can set a default color here
    }
  }

  @override
  DataRow getRow(int index) {
    var width = MediaQuery.of(Get.context!).size.width;
    var height = MediaQuery.of(Get.context!).size.height;
    final application = filteredApplications[index];
    return DataRow(
      cells: [
        DataCell(Text('${application["org_name"]}')),
        DataCell(Text('${application["internship_details"] ?? "N/A"}')),
        DataCell(Text('${application["created_at"] ?? "N/A"}')),
        DataCell(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.007),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.25),
                      offset: const Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide.none,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      _getButtonColor(
                          application["application_status"] ?? "N/A"),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(196, 112, 51, 0),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    '${application["application_status"] ?? "N/A"}',
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredApplications.length;

  @override
  int get selectedRowCount => 0;
}
