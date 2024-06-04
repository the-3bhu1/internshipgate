
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internshipgate/widgets/date_textfield.dart';
import 'package:internshipgate/widgets/edit_project_textfield.dart';

import 'package:intl/intl.dart';

import '../../../utils/api_endpoints.dart';

class EditTrainingForm extends StatefulWidget {
  var applicantId,trainingId,tra_start_date,tra_end_date,tra_current_status,
   email,tra_profile,tra_org_name,tra_location,tra_description;
    final VoidCallback refreshCallback; 

   EditTrainingForm({
    Key? key,
    required this.refreshCallback,
    required this.applicantId,
    required this.email,
    required this.trainingId,
    required this.tra_profile,
    required this.tra_org_name,
    required this.tra_location,
    required this.tra_start_date,
    required this.tra_end_date,
    required this.tra_current_status,
    required this.tra_description,
  }) : super(key: key);

  @override
  State<EditTrainingForm> createState() => _EditTrainingFormState();
}

class _EditTrainingFormState extends State<EditTrainingForm> {
  final TextEditingController _traProfileController = TextEditingController();
  final TextEditingController _traOrgNameController = TextEditingController();
  final TextEditingController _traLocationController = TextEditingController();
  final TextEditingController _traStartDateController = TextEditingController();
  final TextEditingController _traEndDateController = TextEditingController();
  final TextEditingController _traDescriptionController =
      TextEditingController();
  bool _isCurrentlyWorking = false;
  
@override
  void initState() {
    super.initState();

    // Set initial values to controllers based on existing data
    _traProfileController.text = widget.tra_profile;
    _traOrgNameController.text = widget.tra_org_name;
    _traLocationController.text = widget.tra_location;
    _traStartDateController.text = widget.tra_start_date;
    _traEndDateController.text =
        widget.tra_current_status == "YES" ? "" : widget.tra_end_date;
    _isCurrentlyWorking = widget.tra_current_status == "YES";
    _traDescriptionController.text = widget.tra_description;
  }

  Future<void> _submitForm() async {
    const apiUrl =
        '${ApiEndPoints.baseUrl}updateApplicantTraining';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          "id": widget.trainingId, 
          "email": widget.email,
          "tra_profile": _traProfileController.text,
          "tra_org_name": _traOrgNameController.text,
          "tra_location": _traLocationController.text,
          "tra_start_date": _traStartDateController.text,
          "tra_end_date": _isCurrentlyWorking ? "" : _traEndDateController.text,
          "tra_current_status": _isCurrentlyWorking ? "YES" : "NO",
          "tra_description": _traDescriptionController.text,
          "applicantId": widget.applicantId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 1) {
          Get.snackbar(
            'Success',
            'Training details updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        widget.refreshCallback.call();

          Navigator.pop(context);
          print("Training details updated successfully!");
          print(responseData);
        } else {
          print(
              "Failed to update training details. ${responseData['message']}");
        }
      } else {
        print("HTTP error ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,

        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            // Get.offAll(() =>
            //     const AuthPage()); // Use a callback to instantiate AuthScreen
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
        child: Padding(
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
                      'Edit Training Details',
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
                      'Training Program',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: EditProjectTextFieldWidget(
                      textEditingController: _traProfileController,
                      hintText: 'Name of Training',
                    ),
                  ),

                  // TextFormField(
                  //   controller: _traProfileController,
                  //   decoration: InputDecoration(labelText: 'Training Profile'),
                  //   validator: (value) {
                  //     if ((value ?? '').isEmpty) {
                  //       return 'Please enter training profile';
                  //     }
                  //     return null;
                  //   },
                  // ),

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
                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: EditProjectTextFieldWidget(
                      textEditingController: _traOrgNameController,
                      hintText: 'Organization/Institute Name',
                    ),
                  ),

                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Location',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: EditProjectTextFieldWidget(
                      textEditingController: _traLocationController,
                      hintText: 'Enter Location',
                    ),
                  ),
                  // TextFormField(
                  //   controller: _traLocationController,
                  //   decoration: InputDecoration(labelText: 'Location'),
                  //   validator: (value) {
                  //     if ((value ?? '').isEmpty) {
                  //       return 'Please enter location';
                  //     }
                  //     return null;
                  //   },
                  // ),

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
                      textEditingController: _traStartDateController,
                      hintText: 'dd-mm-yyyy',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDate(context, _traStartDateController),
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
                            textEditingController: _traEndDateController,
                            hintText: 'dd-mm-yyyy',
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  _selectDate(context, _traEndDateController),
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
                          _traEndDateController.clear();
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
                        const SizedBox(
                            height:
                                10), // Add some space between label and input box
                        Container(
                          height:
                              100, // Adjust the height according to your preference
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Scrollbar(
                            trackVisibility:
                                true, // Set to true to always show the scrollbar
                            controller:
                                ScrollController(), // You can customize this controller if needed
                            child: SingleChildScrollView(
                              controller:
                                  ScrollController(), // Use the same controller for both
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*const Padding(
                                    padding: EdgeInsets.all(8.0),
                                  ),*/
                                  TextFormField(
                                    controller: _traDescriptionController,
                                    maxLines:
                                        null, // Allows the TextField to have unlimited lines
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
                  // TextFormField(
                  //   controller: _traDescriptionController,
                  //   decoration: InputDecoration(labelText: 'Description'),
                  //   validator: (value) {
                  //     if ((value ?? '').isEmpty) {
                  //       return 'Please enter description';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 16.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         _submitForm();
                  //       },
                  //       child: Text('Submit'),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: Text('Close'),
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
                          foregroundColor:
                              const Color.fromRGBO(249, 143, 67, 1),
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
      ),
    );
  }
}
