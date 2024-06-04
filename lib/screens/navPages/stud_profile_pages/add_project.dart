import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/widgets/date_textfield.dart';
import 'package:internshipgate/widgets/edit_project_textfield.dart';
import 'package:intl/intl.dart';

import '../../../utils/api_endpoints.dart';

class AddProjectDetailsPage extends StatefulWidget {
  final String email;
  final int applicantId;
  final VoidCallback refreshCallback;

  const AddProjectDetailsPage({
    super.key,
    required this.refreshCallback,
    required this.applicantId,
    required this.email,
  });

  @override
  State<AddProjectDetailsPage> createState() => _AddProjectDetailsPageState();
}

class _AddProjectDetailsPageState extends State<AddProjectDetailsPage> {
  final TextEditingController _prjProfileController = TextEditingController();
  final TextEditingController _prjOrgNameController = TextEditingController();
  final TextEditingController _prjLocationController = TextEditingController();
  final TextEditingController _prjStartDateController = TextEditingController();
  final TextEditingController _prjEndDateController = TextEditingController();
  final TextEditingController _prjDescriptionController =
      TextEditingController();
  bool _isCurrentlyWorking = false;

  Future<void> _submitForm() async {
    const apiUrl = '${ApiEndPoints.baseUrl}updateApplicantProject';

    if (_prjProfileController.text.isEmpty ||
        _prjOrgNameController.text.isEmpty ||
        _prjLocationController.text.isEmpty ||
        _prjStartDateController.text.isEmpty ||
        (!_isCurrentlyWorking && _prjEndDateController.text.isEmpty) ||
        _prjDescriptionController.text.isEmpty) {
      print("Please fill in all required fields");
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        "email": widget.email,
        "prj_profile": _prjProfileController.text,
        "prj_org_name": _prjOrgNameController.text,
        "prj_location": _prjLocationController.text,
        "prj_start_date": _prjStartDateController.text,
        "prj_end_date": _isCurrentlyWorking ? "" : _prjEndDateController.text,
        "prj_current_status": _isCurrentlyWorking ? "YES" : "NO",
        "prj_description": _prjDescriptionController.text,
        "applicantId": widget.applicantId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        Get.snackbar(
          'Success',
          'Project added/updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        widget.refreshCallback.call();
        Navigator.pop(context);
        print("Project added/updated successfully!");
        print(responseData);
      } else {
        print("Failed to add/update project. ${responseData['message']}");
      }
    } else {
      print("HTTP error ${response.statusCode}");
      print(widget.email);
      print(widget.applicantId);
    }
  }

  /*Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _prjStartDateController.text = picked.toLocal().toString();
      });
    }
  }*/

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      controller.text = formattedDate;
    }
  }

  /*Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _prjEndDateController.text = picked.toLocal().toString();
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            // Navigate to another screen or perform an action
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
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Add Project Details',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 10.0),
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
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Project Name',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: EditProjectTextFieldWidget(
                    textEditingController: _prjProfileController,
                    hintText: 'e.g. Optical Character Recognition',
                  ),
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Organization',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: EditProjectTextFieldWidget(
                    textEditingController: _prjOrgNameController,
                    hintText: 'Organization/Institute Name',
                  ),
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Work From Home / City',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: EditProjectTextFieldWidget(
                    textEditingController: _prjLocationController,
                    hintText: 'Work From Home / City',
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Text(
                //     'Start Date',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w700,
                //         fontSize: 20,
                //         color: Colors.black87),
                //   ),
                // ),
                // TextFormField(
                //   controller: _prjStartDateController,
                //   decoration: InputDecoration(
                //     labelText: 'Start Date',
                //     suffixIcon: IconButton(
                //       onPressed: () =>
                //           _selectDate(context, _prjStartDateController),
                //       icon: Icon(Icons.calendar_today),
                //     ),
                //   ),
                //   validator: (value) {
                //     if ((value ?? '').isEmpty) {
                //       return 'Please enter start date';
                //     }
                //     return null;
                //   },
                // ),
                // if (!_isCurrentlyWorking)
                //   TextFormField(
                //     controller: _prjEndDateController,
                //     decoration: InputDecoration(
                //       labelText: 'End Date',
                //       suffixIcon: IconButton(
                //         onPressed: () =>
                //             _selectDate(context, _prjEndDateController),
                //         icon: Icon(Icons.calendar_today),
                //       ),
                //     ),
                //   ),
                // const SizedBox(height: 10.0),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Text(
                //     'Start Date',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w700,
                //         fontSize: 20,
                //         color: Colors.black87),
                //   ),
                // ),
                // const SizedBox(height: 10),

                // START AND END DATE ....
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Start Date',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DateTextFieldWidget(
                    textEditingController: _prjStartDateController,
                    hintText: 'dd-mm-yyyy',
                    suffixIcon: IconButton(
                      onPressed: () => _selectDate(context, _prjStartDateController),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                if (!_isCurrentlyWorking) ...{
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'End Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DateTextFieldWidget(
                          textEditingController: _prjEndDateController,
                          hintText: 'dd-mm-yyyy',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                _selectDate(context, _prjEndDateController),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ],
                  ),
                },
                CheckboxListTile(
                  title: const Text('Currently Working Here'),
                  shape: const CircleBorder(),
                  value: _isCurrentlyWorking,
                  onChanged: (value) {
                    setState(() {
                      _isCurrentlyWorking = value!;
                      if (value) {
                        _prjEndDateController.clear();
                      }
                    });
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Descriptions:",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black87),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Add some space between label and input box
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Scrollbar(
                          trackVisibility: true,
                          controller: ScrollController(),
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*const Padding(
                                  padding: EdgeInsets.all(8.0),
                                ),*/
                                TextFormField(
                                  controller: _prjDescriptionController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    hintText: 'short description max - 500',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {
                //         _submitForm();
                //       },
                //       child: const Text('Submit'),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       child: const Text('Close'),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 16),
                      ),
                      child: const Text("Save",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                    SizedBox(width: width * 0.04),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        foregroundColor: const Color.fromRGBO(249, 143, 67, 1),
                        side: const BorderSide(
                            color: Color.fromRGBO(249, 143, 67, 1), width: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 16),
                      ),
                      child: const Text("Close",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
