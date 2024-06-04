import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../utils/api_endpoints.dart';

class StudFavoritesList extends StatefulWidget {
  final int studentId;
  const StudFavoritesList({super.key, required this.studentId});

  @override
  State<StudFavoritesList> createState() => _StudFavoritesListState();
}

class _StudFavoritesListState extends State<StudFavoritesList> {
  var favoriteApplications = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteApplications(widget.studentId.toString()).then((value) {
      setState(() {
        favoriteApplications = value;
      });
    });
  }

  Future<List<dynamic>> _fetchFavoriteApplications(String studentId) async {
    try {
      Response response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getStudentInternshipApplications/$studentId/5'),
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
                'Favorite Internship Applications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: height * 0.01,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 80,
                  columns: const [
                    DataColumn(label: Text('Company Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
                    DataColumn(label: Text('Internship Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),)),
                  ],
                  rows: favoriteApplications.map((application) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${application["companyname"] ?? "N/A"}')),
                        DataCell(Text('${application["internship_details"] ?? "N/A"}')),
                        DataCell(Text('${application["created_at"] ?? "N/A"}')),
                        DataCell(Text('${application["application_status"] ?? "N/A"}')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
