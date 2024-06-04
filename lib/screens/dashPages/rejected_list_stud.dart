// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';

// class StudRejected extends StatefulWidget {
//   final int studentId;

//   const StudRejected({Key? key, required this.studentId}) : super(key: key);

//   @override
//   State<StudRejected> createState() => _StudRejectedState();
// }

// class _StudRejectedState extends State<StudRejected> {
//   var rejectedApplications = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchRejectedApplications(widget.studentId.toString()).then((value) {
//       setState(() {
//         rejectedApplications = value;
//       });
//     });
//   }

//   Future<List<dynamic>> _fetchRejectedApplications(String studentId) async {
//     try {
//       Response response = await get(
//         Uri.parse(
//           'https://staging-dev.internshipgate.com/public/api/getStudentInternshipApplications/$studentId/1',
//         ),
//       );
//       if (response.statusCode == 200) {
//         var allApplications = jsonDecode(response.body.toString());
//         // Filter rejected applications based on application_status: Rejected
//         return allApplications
//             .where((application) =>
//                 application["application_status"] == 'Rejected')
//             .toList();
//       } else {
//         var data = jsonDecode(response.body.toString());
//         print(data);
//         return [];
//       }
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }
// Color _getButtonColor(String status) {
//     switch (status) {
//       case 'Not Shortlisted':
//         return const Color.fromRGBO(249, 143, 67, 1); // Blue
//       case 'Rejected':
//         return const Color.fromARGB(255, 243, 32, 17);
//       case 'Hired':
//         return Colors.green;
//       case 'Shortlisted':
//         return const Color.fromARGB(255, 59, 176, 254); // Your original color
//       default:
//         return Colors.grey; // You can set a default color here
//     }
//   }

//   void _runFilter(String enteredKeyword) {
//     var results = [];

//     // Filter shortlisted applications based on application_status: Shortlisted
//     results = rejectedApplications
//         .where((application) =>
//             application["internship_details"]
//                 .toLowerCase()
//                 .contains(enteredKeyword.toLowerCase()) &&
//             application["application_status"] == 'Rejected')
//         .toList();

//     setState(() {
//       rejectedApplications = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 25.0,
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         title: GestureDetector(
//           child: Image.asset(
//             'lib/icons/logo.png',
//             height: 120.0,
//             width: 180.0,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: height * 0.015,
//               ),
//               const Text(
//                 'Rejected Internship Applications',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//               ),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               TextField(
//                 onChanged: (value) => _runFilter(value),
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                   labelText: 'Search Internship post',
//                   prefixIcon: const Icon(Icons.search),
//                 ),
//               ),
//               SizedBox(
//                 height: height * 0.01,
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   headingRowHeight: 80,
//                   columns: const [
//                     DataColumn(
//                         label: Text(
//                       'Company Name',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//                     )),
//                     DataColumn(
//                         label: Text(
//                       'Internship Name',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//                     )),
//                     DataColumn(
//                         label: Text(
//                       'Date',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//                     )),
//                     DataColumn(
//                         label: Text(
//                       'Status',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
//                     )),
//                   ],
//                   rows: rejectedApplications.map((application) {
//                     return DataRow(
//                       cells: [
//                         DataCell(Text('${application["org_name"] ?? "N/A"}')),
//                         DataCell(
//                             Text('${application["internship_details"] ?? "N/A"}')),
//                         DataCell(Text('${application["created_at"] ?? "N/A"}')),
//                         DataCell(
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 width: 120,
//                                 height: 32,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.white.withOpacity(0.25),
//                                       offset: const Offset(0, 0),
//                                       blurRadius: 2,
//                                       spreadRadius: 1,
//                                     ),
//                                   ],
//                                 ),
//                                 child: TextButton(
//                                   style: ButtonStyle(
//                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         side: BorderSide.none,
//                                       ),
//                                     ),
//                                     backgroundColor: MaterialStateProperty.all<Color>(
//                                       _getButtonColor(application["application_status"] ?? ""),
//                                     ),
//                                     overlayColor: MaterialStateProperty.all<Color>(
//                                      const Color.fromARGB(255, 59, 176, 254),
//                                     ),
//                                   ),
//                                   onPressed: () {},
//                                   child: Center(
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           '${application["application_status"] ?? "N/A"}',
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../utils/api_endpoints.dart';

class StudRejected extends StatefulWidget {
  final int studentId;

  const StudRejected({Key? key, required this.studentId}) : super(key: key);

  @override
  State<StudRejected> createState() => _StudRejectedState();
}

class _StudRejectedState extends State<StudRejected> {
  var rejectedApplications = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final int _sortColumnIndex = 0;
  final bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchRejectedApplications(widget.studentId.toString()).then((value) {
      setState(() {
        rejectedApplications = value;
      });
    });
  }

  Future<List<dynamic>> _fetchRejectedApplications(String studentId) async {
    try {
      Response response = await get(
        Uri.parse(
          '${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/1',
        ),
      );
      if (response.statusCode == 200) {
        
        var allApplications = jsonDecode(response.body.toString());
       
        // Filter rejected applications based on application_status: Rejected
        return allApplications
            .where((application) =>
                application["application_status"] == 'Rejected')
            .toList();
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

    // Filter shortlisted applications based on application_status: Shortlisted
    results = rejectedApplications
        .where((application) =>
            application["internship_details"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) &&
            application["application_status"] == 'Rejected')
        .toList();

    setState(() {
      rejectedApplications = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          child: Image.asset(
            'lib/icons/logo.png',
            height: 120.0,
            width: 180.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.015,
              ),
              const Text(
                'Rejected Internship Applications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7)),
                  labelText: 'Search Internship post',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              PaginatedDataTable(
                headingRowHeight: 80,
                rowsPerPage: _rowsPerPage,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                availableRowsPerPage: const [5, 10, 20],
                onRowsPerPageChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      _rowsPerPage = value;
                    });
                  }
                },
                columns: const [
                  DataColumn(
                      label: Text(
                    'Company Name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  )),
                  DataColumn(
                      label: Text(
                    'Internship Name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  )),
                  DataColumn(
                      label: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  )),
                  DataColumn(
                      label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  )),
                ],
                source: _YourCustomDataTableSource(
                    filteredApplications: rejectedApplications),
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
        return const Color.fromARGB(255, 243, 32, 17);
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
    final application = filteredApplications[index];
    return DataRow(
      cells: [
        DataCell(Text('${application["org_name"] ?? "N/A"}')),
        DataCell(Text('${application["internship_details"] ?? "N/A"}')),
        DataCell(Text('${application["created_at"] ?? "N/A"}')),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 120,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide.none,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      _getButtonColor(application["application_status"] ?? ""),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 59, 176, 254),
                    ),
                  ),
                  onPressed: () {},
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${application["application_status"] ?? "N/A"}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
