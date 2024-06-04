import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internshipgate/widgets/date_textfield.dart';
import 'package:internshipgate/widgets/edit_project_textfield.dart';
import 'package:intl/intl.dart';
import '../../../utils/api_endpoints.dart';

class InternshipForm extends StatefulWidget {
  final int studentId, applicantId;
  final String emai;
  final VoidCallback refreshCallback;

  const InternshipForm({
    Key? key,
    required this.refreshCallback,
    required this.studentId,
    required this.applicantId,
    required this.emai,
  }) : super(key: key);

  @override
  State<InternshipForm> createState() => _InternshipFormState();
}

class _InternshipFormState extends State<InternshipForm> {
  final TextEditingController _intProfileController = TextEditingController();
  final TextEditingController _intOrgNameController = TextEditingController();
  final TextEditingController _intStartDateController = TextEditingController();
  TextEditingController _intEndDateController = TextEditingController();
  final TextEditingController _intDescriptionController =
      TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  bool _isCurrentlyWorking = false;
  List<Map<String, String>> items = [];
  String selectedCity = "";

  @override
  void initState() {
    super.initState();
    cities();
  }

  Future<void> _submitForm(String selectedCity) async {
    const apiUrl = '${ApiEndPoints.baseUrl}updateApplicantInternship';

    // Check for null values before sending the request
    if (_intProfileController.text.isEmpty ||
        _intOrgNameController.text.isEmpty ||
        selectedCity.isEmpty ||
        _intStartDateController.text.isEmpty ||
        (!_isCurrentlyWorking && _intEndDateController.text.isEmpty) ||
        _intDescriptionController.text.isEmpty) {
      print("Please fill in all required fields");
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        "email": widget.emai,
        "int_profile": _intProfileController.text,
        "int_org_name": _intOrgNameController.text,
        "int_location": selectedCity,
        "int_start_date": _intStartDateController.text,
        "int_end_date": _isCurrentlyWorking ? "Present" : _intEndDateController.text,
        "int_current_status": _isCurrentlyWorking ? "YES" : "NO",
        "int_description": _intDescriptionController.text,
        "applicantId": widget.applicantId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        Get.snackbar(
          'Success',
          'Internship added/updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        widget.refreshCallback.call();

        Navigator.pop(context);

        print("Internship added successfully!");
      } else {
        print("Failed to add internship. ${responseData['message']}");
      }
    } else {
      print("HTTP error ${response.statusCode}");
    }
  }

  Future<void> cities() async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getLocationMasterDetails'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          items = data
              .map<Map<String, String>>((item) => {
                    'value': item['value'].toString(),
                    'label': item['label'].toString(),
                  })
              .toList();
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
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
        _intEndDateController.text = picked.toLocal().toString();
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                      'Add Internship Details',
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
                      'Job Profile',
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
                      textEditingController: _intProfileController,
                      hintText: 'e.g. Operations',
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: EditProjectTextFieldWidget(
                      textEditingController: _intOrgNameController,
                      hintText: 'e.g. Internshipgate',
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Location',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black87)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: selectedCity.isNotEmpty
                                  ? Text(
                                      selectedCity,
                                      style: TextStyle(fontSize: width * 0.035),
                                    )
                                  : Text(
                                      'Select City',
                                      style: TextStyle(
                                          fontSize: width * 0.035, color: Colors.black),
                                    ),
                              value:
                                  selectedCity.isNotEmpty ? selectedCity : null,
                              items: items
                                  .map((item) => DropdownMenuItem(
                                        value: item['value'],
                                        child: Text(
                                          item['label']!,
                                          style: TextStyle(fontSize: width * 0.035),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCity = value!;
                                  print(
                                      selectedCity); // Set the selected location
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                width: double.infinity,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: height * 0.35,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: height * 0.055,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController: textEditingController,
                                searchInnerWidgetHeight: height * 0.05,
                                searchInnerWidget: Container(
                                  height: height * 0.065,
                                  padding: const EdgeInsets.only(
                                    top: 4,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                  ),
                  const SizedBox(height: 10,),
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DateTextFieldWidget(
                      textEditingController: _intStartDateController,
                      hintText: 'dd-mm-yyyy',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDate(context, _intStartDateController),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  if (!_isCurrentlyWorking) ...{
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            textEditingController: _intEndDateController,
                            hintText: 'dd-mm-yyyy',
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  _selectDate(context, _intEndDateController),
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
                          _intEndDateController =
                              TextEditingController(text: null);
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
                          // Adjust the height according to your preference
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Scrollbar(
                            trackVisibility: true,
                            // Set to true to always show the scrollbar
                            controller: ScrollController(),
                            // You can customize this controller if needed
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              // Use the same controller for both
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*const Padding(
                                    padding: EdgeInsets.all(8.0),
                                  ),*/
                                  TextFormField(
                                    controller: _intDescriptionController,
                                    maxLines: null,
                                    // Allows the TextField to have unlimited lines
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _submitForm(selectedCity);
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
