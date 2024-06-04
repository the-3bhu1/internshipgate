import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:internshipgate/screens/auth_screen.dart';

import '../../../utils/api_endpoints.dart';

class AddEdu extends StatefulWidget {
  final int applicantId;
  final String email;
  const AddEdu({super.key, required this.applicantId, required this.email, required this.refreshCallback,});
 final VoidCallback refreshCallback;
  @override
  State<AddEdu> createState() => _AddEduState();
}

class _AddEduState extends State<AddEdu> {

  @override
  void initState() {
    super.initState();
    deglist(selectedType);
    college();
  }

  final TextEditingController _cgpapercentController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _boardController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  String selectedScale = 'CGPA';
  List<Map<String, String>> colleges = [];
  List<Map<String, String>> streams = [];
  List<Map<String, String>> degrees = [];
  String? selectedCollege;
  String? selectedStream;
  String? selectedDegree;
  List<String> scaleList = [
    'Percentage',
    'CGPA',
  ];
  String selectedType = 'pgraduation';
  String selectedStatus = 'Pursuing';
  int? selectedstartYear;
  int? selectedendYear;

  Future<void> college() async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getCollegeListByName'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        List<Map<String, String>> collegeList = (data['collegeList'] as List)
            .map((item) => {
          'value': item['value'].toString(),
          'label': item['label'].toString(),
        }).toList();

        setState(() {
          colleges = collegeList;
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

  Future<void> deglist(String degreeType) async {
    try {
      String apiUrl = '';
      if (degreeType == 'pgraduation') {
        apiUrl = '${ApiEndPoints.baseUrl}getDegreeList/P';
      } else if (degreeType == 'graduation') {
        apiUrl = '${ApiEndPoints.baseUrl}getDegreeList/G';
      } else if (degreeType == 'hsecondary') {
        apiUrl = '${ApiEndPoints.baseUrl}getDegreeList/hsecondary';
      }

      final response = await get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        List<Map<String, String>> degreeList = (data as List)
            .map((item) => {
          'value': item['value'].toString(),
          'label': item['label'].toString(),
        }).toList();

        setState(() {
          degrees = degreeList;
        });
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> strspecList(String selectedDegree) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getSpecializationList/$selectedDegree'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        List<Map<String, String>> streamList = (data as List)
            .map((item) => {
          'value': item['value'].toString(),
          'label': item['label'].toString(),
        }).toList();

        setState(() {
          streams = streamList;
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

  savedetails(String applicantId, email, edu_type, edu_status, edu_board, institute_name, degree, specialization, start_date, end_date, completion_year, performance_scale, cgpa) async {
    try{
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}updateApplicantEducation'),
          body: {
            'applicantId' : applicantId,
            'email' : email,
            'edu_type' : edu_type,
            'edu_status' : edu_status,
            'edu_board' : edu_board,
            'institute_name' : institute_name,
            'degree' : degree,
            'specialization' : specialization,
            'start_date' : start_date,
            'end_date' : end_date,
            'completion_year' : completion_year,
            'performance_scale' : performance_scale,
            'cgpa' : cgpa,
          }
      );
      if(response.statusCode == 200 | 201) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        Get.snackbar(
          'Success',
          'Education details added Successfully',
          snackPosition: SnackPosition.BOTTOM,  
        );
        widget.refreshCallback.call();
        Navigator.pop(context);
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.offAll(() => const AuthPage()); // Use a callback to instantiate AuthScreen
          },
          child: Image.asset(
            'lib/icons/logo.png',
            height: 120.0,
            width: 180.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Add Education Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),
                ),
              ),
              SizedBox(height: height * 0.01,),
              Divider(
                thickness: 1,
                color: Colors.grey[400],
              ),
              SizedBox(height: height * 0.01,),
              const Text('Education Type', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: height * 0.005,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRadioButton('Post Graduation'),
                      buildRadioButton('Senior Secondary'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRadioButton('Graduation'),
                      buildRadioButton('Secondary'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02,),
              const Text('Education Status', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.005,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRadioButton1('Pursuing'),
                  buildRadioButton1('Completed'),
                ],
              ),
              Visibility(
                visible: (selectedType == 'pgraduation' || selectedType == 'graduation'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    const Text('College Name', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.015,),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500, width: 1.35),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedCollege,
                          hint: const Text(
                            'Select College',
                            style: TextStyle(fontSize: 14,color: Colors.black87),
                          ),
                          items: colleges.map((item) => DropdownMenuItem(
                            value: item['value'],
                            child: Text(
                              item['label']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCollege = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 58,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 350,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 60,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 60,
                              padding: const EdgeInsets.only(
                                top: 8,
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
                                  hintText: 'Search for your college',
                                  hintStyle: const TextStyle(fontSize: 14),
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
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (selectedType == 'hsecondary' || selectedType == 'secondary'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    const Text('School Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.015,),
                    SizedBox(
                      height: height * 0.06,
                      child: TextFormField(
                        controller: _schoolController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                            labelText: "School Name",
                            labelStyle: const TextStyle(fontSize: 14)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02,),
              Visibility(
                visible: (selectedType == 'pgraduation' || selectedType == 'graduation'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Degree', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.015,),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500, width: 1.35),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedDegree,
                          hint: const Text(
                            'Select Degree',
                            style: TextStyle(fontSize: 14,color: Colors.black87),
                          ),
                          items: degrees.map((item) => DropdownMenuItem(
                            value: item['value'],
                            child: Text(
                              item['label']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDegree = value;
                              selectedStream = null;
                              strspecList(selectedDegree!);
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 58,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 270,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (selectedType == 'hsecondary' || selectedType == 'secondary'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.015,),
                    SizedBox(
                      height: height * 0.06,
                      child: TextFormField(
                        controller: _boardController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                            labelText: "Board Name",
                            labelStyle: const TextStyle(fontSize: 14)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (selectedType == 'pgraduation' || selectedType == 'graduation' || selectedType == 'hsecondary'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    const Text('Stream / Specialization', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: height * 0.015,),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500, width: 1.35),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedStream,
                          hint: const Text(
                            'Select Stream',
                            style: TextStyle(fontSize: 14,color: Colors.black87),
                          ),
                          items: streams.map((item) => DropdownMenuItem(
                            value: item['value'],
                            child: Text(
                              item['label']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStream = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 58,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 250,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 60,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 60,
                              padding: const EdgeInsets.only(
                                top: 8,
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
                                  hintText: 'Select your stream',
                                  hintStyle: const TextStyle(fontSize: 14),
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
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: (selectedType == 'pgraduation' || selectedType == 'graduation'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    const Text(
                      'Start Year',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.015),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.grey, width: 1.35)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<int?>(
                          value: selectedstartYear,
                          hint: const Text(
                            'Select Start Year',
                            style: TextStyle(fontSize: 14,color: Colors.black87),
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedstartYear = newValue;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 58,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 250,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          ),
                          items: List.generate(35, (index) {
                            int year = DateTime.now().year - index;
                            return DropdownMenuItem<int?>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: selectedStatus == 'Pursuing' && (selectedType == 'hsecondary' || selectedType == 'secondary'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    const Text(
                      'Expected End Year',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.015),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.grey, width: 1.35)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<int?>(
                          value: selectedendYear,
                          hint: const Text(
                            'Select Expected End Year',
                            style: TextStyle(fontSize: 14,color: Colors.black87),
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedendYear = newValue;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 58,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 250,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          ),
                          items: List.generate(39, (index) {
                            int year = DateTime.now().year - 34 + index;
                            return DropdownMenuItem<int?>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).reversed.toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: selectedStatus == 'Completed' && (selectedType == 'hsecondary' || selectedType == 'secondary' || selectedType == 'pgraduation' || selectedType == 'graduation'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    const Text(
                      'End Year',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.015),
                    Container(
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.grey, width: 1.35)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<int?>(
                          value: selectedendYear,
                          hint: const Text(
                            'Select End Year',
                            style: TextStyle(fontSize: 14,color: Colors.black87),
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedendYear = newValue;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 58,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 250,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          ),
                          items: List.generate(39, (index) {
                            int year = DateTime.now().year - 34 + index;
                            return DropdownMenuItem<int?>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).reversed.toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02,),
              const Text('Performance Chart / Scale', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.015,),
              Container(
                height: height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    border: Border.all(color: Colors.grey, width: 1.35)
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: selectedScale,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedScale = newValue!;
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
                    items: scaleList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.135),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02,),
              selectedScale == 'CGPA'
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CGPA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.015,),
                  SizedBox(
                    height: height * 0.06,
                    child: TextField(
                      controller: _cgpapercentController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                          hintText: "e.g. 7.5"
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d?(\.\d{0,2})?$'),
                        ),
                      ],
                    ),
                  )
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Percentage', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.015,),
                  SizedBox(
                    height: height * 0.06,
                    child: TextField(
                      controller: _cgpapercentController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                          hintText: "e.g. 75"
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,2}(\.\d{0,2})?$'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        await savedetails(
                            widget.applicantId.toString(),
                            widget.email,
                            selectedType,
                            selectedStatus,
                            _boardController.text.toString(),
                            selectedCollege ?? _schoolController.text.toString(),
                            selectedDegree ?? selectedType,
                            selectedStream ?? '',
                            selectedstartYear.toString(),
                            selectedendYear != null? selectedendYear.toString() : '',
                            '',
                            selectedScale,
                            _cgpapercentController.text.toString()
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 11,horizontal: 16)
                      ),
                      child: const Text("Save", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                  ),
                  SizedBox(width: width * 0.03,),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          foregroundColor: const Color.fromRGBO(249, 143, 67, 1),
                          side: const BorderSide(color: Color.fromRGBO(249, 143, 67, 1), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 11,horizontal: 16)
                      ),
                      child: const Text("Close", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                  ),
                ],
              ),
              SizedBox(height: height * 0.03,),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildRadioButton(String type) {
    String value;
    switch (type) {
      case 'Post Graduation':
        value = 'pgraduation';
        break;
      case 'Graduation':
        value = 'graduation';
        break;
      case 'Senior Secondary':
        value = 'hsecondary';
        break;
      case 'Secondary':
        value = 'secondary';
        break;
      default:
        value = ''; // Set a default value if needed
    }
    return Row(
      children: [
        SizedBox(
          height: 35,
          child: Radio<String>(
            activeColor: const Color.fromRGBO(44, 56, 149, 1),
            value: value,
            groupValue: selectedType,
            onChanged: (newValue) {
              setState(() {
                selectedType = newValue!;
                selectedDegree = null;
                deglist(selectedType);
                if (selectedType == 'hsecondary') {
                  strspecList(selectedType);
                } else {
                  strspecList(selectedDegree ?? '') ;
                }
              });
            },
          ),
        ),
        Text(type, style: const TextStyle(fontSize: 16),),
      ],
    );
  }
  Widget buildRadioButton1(String label) {
    return Row(
      children: [
        SizedBox(
          height: 35,
          child: Radio<String>(
            activeColor: const Color.fromRGBO(44, 56, 149, 1),
            value: label,
            groupValue: selectedStatus,
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 16),),
      ],
    );
  }
}