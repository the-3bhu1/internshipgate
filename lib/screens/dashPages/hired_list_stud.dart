// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';

// class StudHiredList extends StatefulWidget {
//   final int studentId;
//   const StudHiredList({Key? key, required this.studentId});

//   @override
//   State<StudHiredList> createState() => _StudHiredListState();
// }

// class _StudHiredListState extends State<StudHiredList> {
//   var hiredApplications = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchHiredApplications(widget.studentId.toString()).then((value) {
//       setState(() {
//         hiredApplications = value;
//       });
//     });
//   }

//   Future<List<dynamic>> _fetchHiredApplications(String studentId) async {
//     try {
//       Response response = await get(
//         Uri.parse('https://staging-dev.internshipgate.com/public/api/getStudentInternshipApplications/$studentId/2'),
//       );
//       if (response.statusCode == 200) {
        
//         return jsonDecode(response.body.toString());
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
//               SizedBox(height: height * 0.015,),
//               const Text(
//                 'Hired Internship Applications',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//               ),
//               SizedBox(height: height * 0.01,),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   headingRowHeight: 80,
//                   columns: [
//                     const DataColumn(label: Text('Company Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
//                     const DataColumn(label: Text('Internship Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
//                     const DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
//                     const DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
//                   ],
//                   rows: hiredApplications.map((application) {
//                     return DataRow(
//                       cells: [
//                         DataCell(Text('${application["companyname"] ?? "N/A"}')),
//                         DataCell(Text('${application["internship_details"] ?? "N/A"}')),
//                         DataCell(Text('${application["created_at"] ?? "N/A"}')),
//                         DataCell(Text('${application["application_status"] ?? "N/A"}')),
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

class StudHiredList extends StatefulWidget {
  final int studentId;
  const StudHiredList({super.key, required this.studentId});

  @override
  State<StudHiredList> createState() => _StudHiredListState();
}

class _StudHiredListState extends State<StudHiredList> {
  var hiredApplications = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final int _sortColumnIndex = 0;
  final bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchHiredApplications(widget.studentId.toString()).then((value) {
      setState(() {
        hiredApplications = value;
      });
    });
  }

  Future<List<dynamic>> _fetchHiredApplications(String studentId) async {
    try {
      Response response = await get(
        Uri.parse(
          '${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/2',
        ),
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
              SizedBox(height: height * 0.015,),
              const Text(
                'Hired Internship Applications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: height * 0.01,),
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
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Internship Name',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                  ),
                ],
                source: _YourCustomDataTableSource(filteredApplications: hiredApplications),
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

  @override
  DataRow getRow(int index) {
    final application = filteredApplications[index];
    return DataRow(
      cells: [
        DataCell(Text('${application["companyname"] ?? "N/A"}')),
        DataCell(Text('${application["internship_details"] ?? "N/A"}')),
        DataCell(Text('${application["created_at"] ?? "N/A"}')),
        DataCell(Text('${application["application_status"] ?? "N/A"}')),
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
