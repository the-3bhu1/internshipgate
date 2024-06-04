import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart';
import 'package:internshipgate/widgets/edit_input_textfield.dart';
import '../../../utils/api_endpoints.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<String>? dropdownItems;

  // final VoidCallback refreshCallback;

  const InputField({
    super.key,
    // required this.refreshCallback,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.dropdownItems, // Initialize the property
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: dropdownItems != null
            ? DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.text,
                  items: dropdownItems!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.text = newValue;
                    }
                  },
                ),
              )
            : null,
      ),
    );
  }
}

class EditEducationDetailsPage extends StatefulWidget {
  final startDate,
      endDate,
      cgpa,
      completionYear,
      email,
      eduType,
      eduStatus,
      eduBoard,
      instituteName,
      degree,
      specialization,
      performanceScale, applicantId, educationId;
  final VoidCallback refreshCallback;

  const EditEducationDetailsPage({
    super.key,
    required this.refreshCallback,
    required this.educationId,
    required this.email,
    required this.eduType,
    required this.applicantId,
    required this.startDate,
    required this.endDate,
    required this.eduStatus,
    required this.eduBoard,
    required this.instituteName,
    required this.degree,
    required this.specialization,
    required this.completionYear,
    required this.performanceScale,
    required this.cgpa,
  });

  @override
  State<EditEducationDetailsPage> createState() =>
      _EditEducationDetailsPageState();
}

class _EditEducationDetailsPageState extends State<EditEducationDetailsPage> {
  List<String> specializations = [];
  String selectedDegree = '';
  String? _status;
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _degreeController = TextEditingController();
  TextEditingController _boardController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  TextEditingController _intStartDateController = TextEditingController();
  TextEditingController _intEndDateController = TextEditingController();
  TextEditingController _scaleController = TextEditingController();
  TextEditingController _cgpapercentController = TextEditingController();
  List<Map<String, String>> items = [];
  List<Map<String, String>> clgItems = [];
  List<Map<String, String>> specializationItems = [];
  String? selectedCollege;
  String? selectedSpecialization;
  String? selectedstartYear;
  String? selectedendYear;
  String? selectedScale;
  List<String> scaleList = [
    'Percentage',
    'CGPA',
  ];

  Future<void> fetchCollegeList([String search = '']) async {
    String apiUrl = '${ApiEndPoints.baseUrl}getCollegeListByName';

    if (search.isNotEmpty) {
      apiUrl += '/$search';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['collegeList'] is List) {
          List<dynamic> collegeList = data['collegeList'];

          setState(() {
            clgItems = collegeList.map<Map<String, String>>((item) {
              return {
                'value': item['value'].toString(),
                'label': item['label'].toString(),
              };
            }).toList();
          });
        } else {
          print('College list is not in the expected format.');
        }
      } else {
        print('Failed to load colleges. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching colleges: $e');
    }
  }

  Future<void> fetchDegreeList({String? type}) async {
    String apiUrl;
    if (type == 'P') {
      apiUrl = '${ApiEndPoints.baseUrl}getDegreeList/P';
    } else if (type == 'G') {
      apiUrl = '${ApiEndPoints.baseUrl}getDegreeList/G';
    } else {
      apiUrl = '${ApiEndPoints.baseUrl}getDegreeList/hsecondary';
    }
    try {
      final response = await http.get(Uri.parse(apiUrl));

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

  Future<void> fetchSpecializationList(String degree) async {
    String apiUrl = '${ApiEndPoints.baseUrl}getSpecializationList/$degree';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          specializationItems = data
              .expand<Map<String, String>>((item) =>
                  (item['value'] as String).split(',').map((label) => {
                        'value': label.trim(),
                        'label': label.trim(),
                      }))
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

  savedetails(
      String id,
      applicantId,
      email,
      edu_type,
      edu_status,
      edu_board,
      institute_name,
      degree,
      specialization,
      start_date,
      end_date,
      completion_year,
      performance_scale,
      cgpa) async {
    try {
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}updateApplicantEducation'),
          body: {
            'id': id,
            'applicantId': applicantId,
            'email': email,
            'edu_type': edu_type,
            'edu_status': edu_status,
            'edu_board': edu_board,
            'institute_name': institute_name,
            'degree': degree,
            'specialization': specialization,
            'start_date': start_date,
            'end_date': end_date,
            'completion_year': completion_year,
            'performance_scale': performance_scale,
            'cgpa': cgpa,
          });
      if (response.statusCode == 200 | 201) {
        var data = jsonDecode(response.body.toString());
        print(data);
        Get.snackbar(
          'Success',
          'Education details added Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        widget.refreshCallback.call();

        Navigator.pop(context);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /*Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controller.text = formattedDate;
    }
  }*/

  String getFormattedEducationType(String eduType) {
    switch (eduType) {
      case 'pgraduation':
        return 'Post Graduation';
      case 'graduation':
        return 'Graduation';
      case 'hsecondary':
        return 'Senior Secondary';
      case 'secondary':
        return 'Secondary';
      default:
        return eduType; // Return the original value if not recognized
    }
  }

  @override
  void initState() {
    super.initState();
    _collegeController = TextEditingController(text: widget.instituteName);
    _degreeController = TextEditingController(text: widget.degree);
    _boardController = TextEditingController(text: widget.eduBoard);
    _intStartDateController = TextEditingController(text: widget.startDate);
    _intEndDateController = TextEditingController(text: widget.endDate);
    _specializationController = TextEditingController(text: widget.specialization);
    _scaleController = TextEditingController(text: widget.performanceScale);
    _cgpapercentController = TextEditingController(text: widget.cgpa);
    _status = widget.eduStatus.toLowerCase();
    print('Initialized with status: $_status');
    fetchCollegeList();
    if (widget.eduType == 'pgraduation') {
      fetchDegreeList(type: 'P');
    } else if (widget.eduType == 'graduation') {
      fetchDegreeList(type: 'G');
    } else {
      fetchDegreeList();
    }
    if (widget.eduType!= 'secondary') {
      fetchSpecializationList(widget.degree);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Type',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.055,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      width: width * 0.08,
                    ),
                    Text(
                      getFormattedEducationType(widget.eduType),
                      style: TextStyle(fontSize: width * 0.05, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.055,
                          color: Colors.black87),
                    ),
                    SizedBox(width: width * 0.01,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRadioButton("Pursuing"),
                        SizedBox(height: height * 0.005,),
                        buildRadioButton("Completed"),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Visibility(
                  visible: (widget.eduType == 'pgraduation' || widget.eduType == 'graduation'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'College Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                            color: Colors.black87),
                      ),
                      SizedBox(height: height * 0.01,),
                      EditInputTextFieldWidget(
                          textEditingController: _collegeController,
                          hintText: 'Search College Name',
                          icon: Icons.school
                      ),
                      SizedBox(height: height * 0.01,),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Search for your college',
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),),
                            items: clgItems
                                .map((item) => DropdownMenuItem(
                                      value: item['value'],
                                      child: Text(item['label']!,
                                      style: TextStyle(fontSize: width * 0.04),
                                      ),
                                    )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCollege = value;
                                _collegeController.text = value ?? widget.instituteName;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              width: double.infinity,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: height * 0.35,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: height * 0.065,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: textEditingController,
                              searchInnerWidgetHeight: height * 0.05,
                              searchInnerWidget: Container(
                                height: height * 0.06,
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
                                    hintText: 'Search for your college',
                                    hintStyle: TextStyle(fontSize: width * 0.04),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value!.toLowerCase().toString().contains(searchValue.toLowerCase());
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: (widget.eduType == 'hsecondary' || widget.eduType == 'secondary'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'School Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      EditInputTextFieldWidget(
                          textEditingController: _collegeController,
                          hintText: 'Enter School Name',
                          icon: Icons.school),
                    ],
                  ),
                ),
                Visibility(
                  visible: (widget.eduType == 'pgraduation' || widget.eduType == 'graduation'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Degree',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      EditInputTextFieldWidget(
                          textEditingController: _degreeController,
                          hintText: 'Search Degree',
                          icon: Icons.school),
                      SizedBox(height: height * 0.01,),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // Border color
                          borderRadius: BorderRadius.circular(7), // Border radius to match text field
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Search for Degree',
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                            ),
                            items: items.map((item) => DropdownMenuItem(
                                      value: item['value'],
                                      child: Text(
                                        item['label']!,
                                        style: TextStyle(fontSize: width * 0.04),
                                      ),
                                    )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCollege = value;
                                _degreeController.text = value ?? widget.degree;
                                _specializationController = TextEditingController(text: '');
                                fetchSpecializationList(value!);
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              width: double.infinity,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: height * 0.35,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: height * 0.065,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: textEditingController,
                              searchInnerWidgetHeight: height * 0.05,
                              searchInnerWidget: Container(
                                height: height * 0.06,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search for a Degree',
                                    hintStyle: TextStyle(fontSize: width * 0.04),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.toString().toLowerCase().contains(searchValue.toLowerCase());
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: (widget.eduType == 'hsecondary' || widget.eduType == 'secondary'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      'Board',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.055,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    EditInputTextFieldWidget(
                        textEditingController: _boardController,
                        hintText: 'Enter Board',
                        icon: Icons.school)
                  ]),
                ),
                Visibility(
                  visible: (widget.eduType == 'pgraduation' || widget.eduType == 'graduation' || widget.eduType == 'hsecondary'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Stream / Specialization',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                            color: Colors.black87),
                      ),
                      SizedBox(height: height * 0.01),
                      EditInputTextFieldWidget(
                        textEditingController: _specializationController,
                        hintText: 'Search Specialization',
                        icon: Icons.school, // Adjust the icon as needed
                      ),
                      SizedBox(height: height * 0.01,),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Search for Specialization',
                              style: TextStyle(fontSize: width * 0.04, color: Colors.black),
                            ),
                            items: specializationItems
                                .map((item) => DropdownMenuItem(
                                      value: item['value'],
                                      child: Text(
                                        item['label']!,
                                        style:
                                        TextStyle(fontSize: width * 0.04),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSpecialization = value;_specializationController.text = value ?? widget.specialization;
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
                              height: height * 0.065,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: textEditingController,
                              searchInnerWidgetHeight: height * 0.05,
                              searchInnerWidget: Container(
                                height: height * 0.06,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search for Specialization',
                                    hintStyle: TextStyle(fontSize: width * 0.04),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item
                                    .toString()
                                    .toLowerCase()
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
                      ),
                    ],
                  ),
                ),
                /*const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                              'Start Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21,
                                  color: Colors.black87),
                            ),
                  ],
                ),
                    TextFormField(
                    controller: _intStartDateController,
                    decoration: InputDecoration(
                      labelText: null,
                      suffixIcon: IconButton(
                        onPressed: () =>
                            _selectDate(context, _intStartDateController),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return 'Please enter start date';
                      }
                      return null;
                    },
                  ),*/
                Visibility(
                  visible: (widget.eduType == 'pgraduation' || widget.eduType == 'graduation'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Text('Start Year',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: width * 0.055, color: Colors.black87)),
                      SizedBox(height: height * 0.01),
                      EditInputTextFieldWidget(
                        textEditingController: _intStartDateController,
                        hintText: 'Select Start Year',
                        icon: Icons.school,
                      ),
                      SizedBox(height: height * 0.01,),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select Start Year',
                              style: TextStyle(fontSize: width * 0.04, color: Colors.black),
                            ),
                            items: List.generate(35, (index) {
                              int year = DateTime.now().year - index;
                              return DropdownMenuItem<String>(
                                value: year.toString(),
                                child: Text(year.toString()),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedstartYear = value;
                                _intStartDateController.text = value ?? widget.specialization;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              width: double.infinity,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: height * 0.35,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: height * 0.065,
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Start Year',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 21,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      EditInputTextFieldWidget(
                        textEditingController: _intStartDateController,
                        hintText: 'Select Start Year',
                        icon: Icons.school, // Adjust the icon as needed
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Positioned(
                              top: -58,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select Start Year',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  items: List.generate(35, (index) {
                                    int year = DateTime.now().year - index;
                                    return DropdownMenuItem<String>(
                                      value: year.toString(),
                                      child: Text(year.toString()),
                                    );
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedstartYear = value;
                                      _intStartDateController.text =
                                          value ?? widget.specialization;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    height: 58,
                                    width: double.infinity,
                                  ),
                                  dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 200,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 50,
                                  ),
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),*/
                ),
                Visibility(
                  visible: _status == 'completed',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'End Year',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                            color: Colors.black87),
                      ),
                      SizedBox(height: height * 0.01),
                      EditInputTextFieldWidget(
                        textEditingController: _intEndDateController,
                        hintText: 'Select End Year',
                        icon: Icons.school, // Adjust the icon as needed
                      ),
                      SizedBox(height: height * 0.01,),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select End Year',
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                            ),
                            items: List.generate(39, (index) {
                              int year = DateTime.now().year - 34 + index;
                              return DropdownMenuItem<String>(
                                value: year.toString(),
                                child: Text(year.toString()),
                              );
                            }).reversed.toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedendYear = value;
                                _intEndDateController.text =
                                    value ?? widget.specialization;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              width: double.infinity,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: height * 0.35,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: height * 0.065,
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _status == 'pursuing' && (widget.eduType == 'hsecondary' || widget.eduType == 'secondary'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        'Expected End Year',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.055,
                            color: Colors.black87),
                      ),
                      SizedBox(height: height * 0.01),
                      EditInputTextFieldWidget(
                        textEditingController: _intEndDateController,
                        hintText: 'Select Expected End Year',
                        icon: Icons.school, // Adjust the icon as needed
                      ),
                      SizedBox(height: height * 0.01,),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select End Year',
                              style: TextStyle(
                                  fontSize: width * 0.04, color: Colors.black),
                            ),
                            items: List.generate(39, (index) {
                              int year = DateTime.now().year - 34 + index;
                              return DropdownMenuItem<String>(
                                value: year.toString(),
                                child: Text(year.toString()),
                              );
                            }).reversed.toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedendYear = value;
                                _intEndDateController.text =
                                    value ?? widget.specialization;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              width: double.infinity,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: height * 0.35,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: height * 0.065,
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      'Performance Scale',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.055,
                          color: Colors.black87),
                    ),
                    SizedBox(height: height * 0.01),
                    EditInputTextFieldWidget(
                      textEditingController: _scaleController,
                      hintText: 'Select Performance Scale',
                      icon: Icons.school, // Adjust the icon as needed
                    ),
                    SizedBox(height: height * 0.01,),
                    EditInputTextFieldWidget(
                      textEditingController: _cgpapercentController,
                      hintText: 'Enter CGPA / Percentage',
                      icon: Icons.school, // Adjust the icon as needed
                    ),
                    SizedBox(height: height * 0.01,),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Performance Scale',
                            style: TextStyle(fontSize: width * 0.04, color: Colors.black),
                          ),
                          items: scaleList
                              .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedScale = value;
                              _scaleController.text =
                                  value ?? widget.performanceScale;
                              _cgpapercentController =
                                  TextEditingController(text: '');
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                            width: double.infinity,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: height * 0.35,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: height * 0.065,
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          await savedetails(
                              widget.educationId.toString(),
                              widget.applicantId.toString(),
                              widget.email,
                              widget.eduType,
                              _status,
                              _boardController.text.toString(),
                              _collegeController.text.toString(),
                              _degreeController.text.toString(),
                              _specializationController.text.toString(),
                              _intStartDateController.text.toString(),
                              _intEndDateController.text.toString(),
                              '',
                              _scaleController.text.toString(),
                              _cgpapercentController.text.toString());
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            backgroundColor:
                                const Color.fromRGBO(44, 56, 149, 1),
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Color.fromRGBO(44, 56, 149, 1),
                                width: 2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 16)),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: width * 0.04),
                        )),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            foregroundColor:
                                const Color.fromRGBO(249, 143, 67, 1),
                            side: const BorderSide(
                                color: Color.fromRGBO(249, 143, 67, 1),
                                width: 2),
                            padding: const EdgeInsets.symmetric(
                                vertical: 11, horizontal: 16)),
                        child: Text(
                          "Close",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: width * 0.04),
                        )),
                  ],
                ),

                /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle logic for the Save button
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 8.0),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Close'),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildRadioButton(String type) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          height: height * 0.04,
          child: Radio<String>(
            activeColor: const Color.fromRGBO(44, 56, 149, 1),
            value: type.toLowerCase(),
            groupValue: _status,
            onChanged: (value) {
              if (value == 'pursuing') {
                setState(() {
                  _status = value!;
                  _intEndDateController = TextEditingController(text: null);
                });
              } else {
                setState(() {
                  _status = value!;
                });
              }
            },
          ),
        ),
        Text(type, style: TextStyle(fontSize: width * 0.05),),
      ],
    );
  }
}
