import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'application_screen.dart';
import 'emp_intern_update.dart';
import 'package:internshipgate/utils/api_endpoints.dart';

class EmployeeList extends StatefulWidget {
  final int recId;
  final String name, email, emptoken;

  const EmployeeList({super.key, required this.recId, required this.name, required this.email, required this.emptoken,});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  var internships = [];
  String _selectedStatus = 'All';
  var filteredInternships = [];
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    list(widget.recId.toString()).then((value) {
      setState(() {
        filteredInternships = internships;
      });
    });
  }

  Future<List<dynamic>> list(String id) async {
    try{
      Response response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getEmployerInternshipByEmployerId/$id'),
      );
      if(response.statusCode == 200) {
        internships = jsonDecode(response.body.toString());
        print(internships);
        return internships;
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
        return [];
      }
    } catch (e){
      print(e.toString());
      return [];
    }
  }

  Future<void> delInt(int id) async {
    try{
      final response = await delete(
        Uri.parse('${ApiEndPoints.baseUrl}deleteEmployerInternshipById/$id'),
      );
      if(response.statusCode == 200 | 202) {
        Get.snackbar(
          'Success',
          'Internship deleted successfully',
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

  Future<void> inactive(int id) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}deActivateEmployerInternship/$id'),
      );
      if(response.statusCode == 200 | 202) {
        var data = jsonDecode(response.body.toString());
        print(data);
        Get.snackbar(
          'Success',
          'Internship inactivated successfully',
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

  void _runFilter(String enteredKeyword) {
    var results = [];

    if (_selectedStatus == 'All') {
      results = internships.where((user) =>
      user["internship_details"].toLowerCase().contains(enteredKeyword.toLowerCase()) &&
          (_selectedStartDate == null || DateTime.parse(user["created_at"]).isAfter(_selectedStartDate!)) &&
          (_selectedEndDate == null || DateTime.parse(user["created_at"]).isBefore(_selectedEndDate!.add(const Duration(days: 1)))),
      ).toList();
    } else {
      results = internships.where((user) =>
      user["internship_details"].toLowerCase().contains(enteredKeyword.toLowerCase()) &&
          user["internship_status"].toLowerCase() == _selectedStatus.toLowerCase() &&
          (_selectedStartDate == null || DateTime.parse(user["created_at"]).isAfter(_selectedStartDate!)) &&
          (_selectedEndDate == null || DateTime.parse(user["created_at"]).isBefore(_selectedEndDate!.add(const Duration(days: 1)))),
      ).toList();
    }

    setState(() {
      filteredInternships = results;
    });
  }

  void _clearDateFilters() {
    setState(() {
      _selectedStartDate = null;
      _selectedEndDate = null;
      _runFilter('');
    });
  }

  Future<void> _handleRefresh() async {
    // Fetch updated data for each section
    await list(widget.recId.toString()).then((value) {
      setState(() {
        filteredInternships = internships;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pull down to refresh', style: TextStyle(color: const Color.fromRGBO(44, 56, 149, 1), fontSize: width * 0.035),),
                    SizedBox(width: width * 0.01,),
                    Icon(Iconsax.arrow_down, size: width * 0.04, color: const Color.fromRGBO(44, 56, 149, 1),)
                  ],
                ),
                SizedBox(height: height * 0.015,),
                Text(
                  'Internship List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.085),
                ),
                SizedBox(height: height * 0.02,),
                SizedBox(
                  height: height * 0.06,
                  child: TextField(
                    autofocus: false,
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                      hintText: 'Search Internship post',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02,),
                PaginatedDataTable(
                  headingRowHeight: height * 0.1,
                  rowsPerPage: 8,
                  columns: [
                    DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.045),),),
                    DataColumn(label: Text('Internship Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.045),),),
                    DataColumn(
                      label: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.04),),
                            SizedBox(height: height * 0.001),
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedStartDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null && pickedDate != _selectedStartDate) {
                                        setState(() {
                                          _selectedStartDate = pickedDate;
                                          _runFilter('');
                                        });
                                      }
                                    },
                                    child: Icon(Icons.calendar_today, size: width * 0.05,)
                                ),
                                Text('   to   ', style: TextStyle(fontSize: width * 0.04),),
                                GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedEndDate ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null && pickedDate != _selectedEndDate) {
                                        setState(() {
                                          _selectedEndDate = pickedDate;
                                          _runFilter('');
                                        });
                                      }
                                    },
                                    child: Icon(Icons.calendar_today, size: width * 0.05,)
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.002,),
                            GestureDetector(
                                onTap: _clearDateFilters,
                                child: Text('clear', style: TextStyle(fontSize: width * 0.04),)
                            ),
                          ],
                        ),
                      ),
                    DataColumn(
                      label: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.04),),
                          SizedBox(
                            height: height * 0.05,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedStatus,
                                items: ['All', 'Draft', 'Active', 'Inactive']
                                    .map((status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status, style: TextStyle(fontSize: width * 0.04),),
                                )).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedStatus = value ?? 'All';
                                    _runFilter('');
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataColumn(label: Text('Received', style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.045)),),
                    const DataColumn(label:  Text(' ')),
                  ],
                  source: InternshipDataSource(filteredInternships, onApplicationView: (id) {
                    Get.to(() => ApplicationsScreen(id: id, email: widget.email, fullname: widget.name, emptoken: widget.emptoken, recId: widget.recId));
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                    onDeleteInternship: (id) async {
                      await delInt(id);
                      await list(widget.recId.toString()).then((value) {
                        setState(() {
                          filteredInternships = internships;
                        });
                      });
                    },
                    onDeactivateInternship: (id) async {
                      await inactive(id);
                      await list(widget.recId.toString()).then((value) {
                        setState(() {
                          filteredInternships = internships;
                        });
                      });
                    },
                    recId: widget.recId,
                    name: widget.name,
                    email: widget.email,
                    emptoken: widget.emptoken,
                    onListUpdate: () async {
                      await list(widget.recId.toString());
                      setState(() {
                        filteredInternships = internships;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InternshipDataSource extends DataTableSource {
  var internships = [];
  final Function(int) onApplicationView;
  final Function(int) onDeleteInternship;
  final Function(int) onDeactivateInternship;
  final int recId;
  final String name, email, emptoken;
  final Function() onListUpdate;

  InternshipDataSource(this.internships, {required this.onApplicationView, required this.onDeleteInternship, required this.onDeactivateInternship, required this.recId, required this.name, required this.email, required this.emptoken, required this.onListUpdate});

  String industry_type  = '';
  String internshipDetails = '';
  String location = '';
  int total_opening = 0;
  String type = '';
  int duration1 = 0;
  String duration2 = '';
  String startDate = '';
  String job_description = '';
  String stipend_type = '';
  int compensation1 = 0;
  String compensation2 = '';
  String perks = '';
  String skill = '';
  String intshipid = '';

  // Add a method to get the background color based on the status
  Color getBackgroundColor(String status) {
    switch (status) {
      case 'Draft':
        return Colors.blue;
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  Future<void> app(String id) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getEmployerInternshipById/$id'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        industry_type = data['industry_type'];
        if (data['internship_details'] == 'Campus Ambassodor') {
          internshipDetails = 'Campus Ambassador';
        } else if (data['internship_details'] == 'Business development') {
          internshipDetails = 'Business Development';
        } else {
          internshipDetails = data['internship_details'];
        }
        location = data['location'];
        total_opening = data['total_opening'];
        type = data['type'];
        duration1 = data['duration1'];
        duration2 = data['duration2'];
        startDate = data['startdate'];
        job_description = data['job_description'];
        stipend_type = data['stipend_type'];
        compensation1 = data['compensation1'] ?? 0;
        compensation2 = data['compensation2'] ?? '';
        perks = data['perks'];
        skill = data['skill'];
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  extendDead(String internshipId, extendFromCurrentDate) async {
    try{
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}extendInternshipDeadline'),
          body: {
            'internshipId' : internshipId,
            'extendFromCurrentDate' : extendFromCurrentDate,
          }
      );
      if(response.statusCode == 200) {
        //var data = jsonDecode(response.body.toString());
        Get.snackbar(
          'Success',
          'Internship Extended Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        //print(data);
        await onListUpdate();
      }
      else if(response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        Get.snackbar(
          'Success',
          'Internship Already Extended Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        print(data);
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  postSim(String internshipId) async {
    try{
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}copyInternship'),
          body: {
            'internshipId' : internshipId,
          }
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
      else {
        var data = jsonDecode(response.body.toString());
        //print(data);
        int intshipIdValue = data["intshipid"];
        //print("Extracted Value: $intshipIdValue");
        return intshipIdValue;
      }
    } catch (e){
      print(e.toString());
    }
  }

  @override
  DataRow? getRow(int index) {
    var height = MediaQuery.of(Get.context!).size.height;
    var width = MediaQuery.of(Get.context!).size.width;
    final internship = internships[index];
    final id = internship["id"];
    final status = internship["internship_status"];

    return DataRow(
      cells: [
        DataCell(Text('${internship["id"]}', style: TextStyle(fontSize: width * 0.04),)),
        DataCell(Text('${internship["internship_details"]}', style: TextStyle(fontSize: width * 0.04),)),
        DataCell(Text('${internship["created_at"]}', style: TextStyle(fontSize: width * 0.04),)),
        // Set background color dynamically based on the status
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: getBackgroundColor(status),
            ),
            child: Text(
              '$status',
              style: TextStyle(color: Colors.white, fontSize: width * 0.04),
            ),
          ),
        ),
        DataCell(
            InkWell(
              onTap:() { onApplicationView(id); },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.005),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.indigo,
                  ),
                  child: Text('View Applications', style: TextStyle(color: Colors.white, fontSize: width * 0.04),)
              ),
            )
        ),
        DataCell(
            InkWell(
                child: Container(
                  margin: const EdgeInsets.only(right: 12, top: 3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: PopupMenuButton<String>(
                    position: PopupMenuPosition.under,
                    onSelected: (value) async {
                      if (status == 'Draft') {
                        if (value == "item1") {
                          await app(id.toString());
                          Get.to(() => EmployeeInternUpdate(name: name, email: email, recId: recId, emptoken: emptoken, selectedValue: industry_type, radioOption: internshipDetails, selectedCities: location.split(',').map((e) => e.trim()).toList(), noOfOpeningsController: TextEditingController(text: total_opening.toString()), selectedInternshipTypes: type.split(',').map((e) => e.trim().toLowerCase()).toList(), numberValue: duration1.toString(), selectedDuration: duration2, selectedOption: '', descriptionController: TextEditingController(text: job_description), selectedType: stipend_type, stipendController: TextEditingController(text: compensation1.toString()), selectedDuration1: compensation2, selectedPerks: perks.split(',').map((e) => e.trim().toLowerCase()).toList(), selectedSkills: skill.split(',').map((e) => e.trim()).toList(), id: id, status: internship['internship_status'], refreshCallback: onListUpdate,));
                        }
                        if (value == "item2") {
                          onDeleteInternship(id);
                        }
                      } else if (status == 'Active') {
                        if (value == "item1") {
                          await app(id.toString());
                          Get.to(() => EmployeeInternUpdate(name: name, email: email, recId: recId, emptoken: emptoken, selectedValue: industry_type, radioOption: internshipDetails, selectedCities: location.split(',').map((e) => e.trim()).toList(), noOfOpeningsController: TextEditingController(text: total_opening.toString()), selectedInternshipTypes: type.split(',').map((e) => e.trim().toLowerCase()).toList(), numberValue: duration1.toString(), selectedDuration: duration2, selectedOption: '', descriptionController: TextEditingController(text: job_description), selectedType: stipend_type, stipendController: TextEditingController(text: compensation1.toString()), selectedDuration1: compensation2, selectedPerks: perks.split(',').map((e) => e.trim().toLowerCase()).toList(), selectedSkills: skill.split(',').map((e) => e.trim()).toList(), id: id, status: internship['internship_status'], refreshCallback: onListUpdate,));
                        } else if (value == "item3") {
                          onDeactivateInternship(id);
                        } else if (value == "item4") {
                          await app(id.toString());
                          int extractedValue = await postSim(id.toString());
                          await Get.to(() => EmployeeInternUpdate(id: extractedValue, name: name, email: email, recId: recId, emptoken: emptoken, selectedValue: industry_type, radioOption: internshipDetails, selectedCities: location.split(',').map((e) => e.trim()).toList(), noOfOpeningsController: TextEditingController(text: total_opening.toString()), selectedInternshipTypes: type.split(',').map((e) => e.trim().toLowerCase()).toList(), numberValue: duration1.toString(), selectedDuration: duration2, selectedOption: '', descriptionController: TextEditingController(text: job_description), selectedType: stipend_type, stipendController: TextEditingController(text: compensation1.toString()), selectedDuration1: compensation2, selectedPerks: perks.split(',').map((e) => e.trim().toLowerCase()).toList(), selectedSkills: skill.split(',').map((e) => e.trim()).toList(), status: internship['internship_status'], refreshCallback: onListUpdate,));
                        } else if (value == "item5") {
                          String? extendFromCurrentDate = (status == 'Active') ? '1' : 'null';
                          await extendDead(id.toString(), extendFromCurrentDate);
                        }
                      } else if (status == 'Inactive') {
                        // Handle inactive status menu items
                        if (value == "item1") {
                          await app(id.toString());
                          Get.to(() => EmployeeInternUpdate(name: name, email: email, recId: recId, emptoken: emptoken, selectedValue: industry_type, radioOption: internshipDetails, selectedCities: location.split(',').map((e) => e.trim()).toList(), noOfOpeningsController: TextEditingController(text: total_opening.toString()), selectedInternshipTypes: type.split(',').map((e) => e.trim().toLowerCase()).toList(), numberValue: duration1.toString(), selectedDuration: duration2, selectedOption: '', descriptionController: TextEditingController(text: job_description), selectedType: stipend_type, stipendController: TextEditingController(text: compensation1.toString()), selectedDuration1: compensation2, selectedPerks: perks.split(',').map((e) => e.trim().toLowerCase()).toList(), selectedSkills: skill.split(',').map((e) => e.trim()).toList(), id: id, status: internship['internship_status'], refreshCallback: onListUpdate,));
                        } else if (value == "item4") {
                          await app(id.toString());
                          int extractedValue = await postSim(id.toString());
                          await Get.to(() => EmployeeInternUpdate(id: extractedValue, name: name, email: email, recId: recId, emptoken: emptoken, selectedValue: industry_type, radioOption: internshipDetails, selectedCities: location.split(',').map((e) => e.trim()).toList(), noOfOpeningsController: TextEditingController(text: total_opening.toString()), selectedInternshipTypes: type.split(',').map((e) => e.trim().toLowerCase()).toList(), numberValue: duration1.toString(), selectedDuration: duration2, selectedOption: '', descriptionController: TextEditingController(text: job_description), selectedType: stipend_type, stipendController: TextEditingController(text: compensation1.toString()), selectedDuration1: compensation2, selectedPerks: perks.split(',').map((e) => e.trim().toLowerCase()).toList(), selectedSkills: skill.split(',').map((e) => e.trim()).toList(), status: internship['internship_status'], refreshCallback: onListUpdate,))?.then((updatedData) {
                           if (updatedData != null) {
                             onListUpdate();
                           }
                          });
                        } else if (value == "item5") {
                          String? extendFromCurrentDate = (status == 'Active') ? '1' : 'null';
                          await extendDead(id.toString(), extendFromCurrentDate);
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      if (status == 'Draft') {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'item1',
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_outlined),
                                SizedBox(width: 10,),
                                Text('View Internship', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'item2',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_outlined),
                                SizedBox(width: 10,),
                                Text('Delete', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                        ];
                      } else if (status == 'Active') {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'item1',
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_outlined),
                                SizedBox(width: 10,),
                                Text('View Internship', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'item3',
                            child: Row(
                              children: [
                                Icon(Icons.close_outlined),
                                SizedBox(width: 10,),
                                Text('Deactivate', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'item4',
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_outlined),
                                SizedBox(width: 10,),
                                Text('Post Similar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'item5',
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined),
                                const SizedBox(width: 10,),
                                Column(
                                  children: [
                                    const Text('Extend Deadline by a Month', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                    Text('Expires on: ${internship["startdate"]}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ];
                      } else if (status == 'Inactive') {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'item1',
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_outlined),
                                SizedBox(width: 10,),
                                Text('View Internship', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'item4',
                            child: Row(
                              children: [
                                Icon(Icons.file_copy_outlined),
                                SizedBox(width: 10,),
                                Text('Post Similar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'item5',
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Extend Deadline by a Month', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                    Text('Expires on: ${internship["startdate"]}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ];
                      } else {
                        return [];
                      }
                    },
                    child: GestureDetector(
                      child: Icon(Icons.more_vert_outlined, color: Colors.grey.shade500, size: width * 0.06,),
                    ),
                  ),
                )
            )
        ),
      ],
    );
  }

  @override
  int get rowCount => internships.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}