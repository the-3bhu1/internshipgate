import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:internshipgate/screens/login_reg_Employer/emp_dash.dart';
import '../../../utils/api_endpoints.dart';
import '../../auth_screen.dart';

class EmployeeInternUpdate extends StatefulWidget {
  final VoidCallback refreshCallback;
  final int id;
  final int recId;
  final String name, email, emptoken, status;
  final String selectedValue;
  final String radioOption;
  final List<String> selectedCities;
  final TextEditingController noOfOpeningsController;
  final List<String> selectedInternshipTypes;
  final String numberValue;
  final String selectedDuration;
  final String selectedOption;
  final TextEditingController descriptionController;
  final String selectedType;
  final TextEditingController stipendController;
  final String selectedDuration1;
  final List<String> selectedPerks;
  final List<String> selectedSkills;

  const EmployeeInternUpdate({
    Key? key,
    required this.name,
    required this.email,
    required this.id,
    required this.recId,
    required this.emptoken,
    required this.selectedValue,
    required this.radioOption,
    required this.selectedCities,
    required this.noOfOpeningsController,
    required this.selectedInternshipTypes,
    required this.numberValue,
    required this.selectedDuration,
    required this.selectedOption,
    required this.descriptionController,
    required this.selectedType,
    required this.stipendController,
    required this.selectedDuration1,
    required this.selectedPerks,
    required this.selectedSkills,
    required this.status,
    required this.refreshCallback,
  }) : super(key: key);

  @override
  State<EmployeeInternUpdate> createState() => _EmployeeInternUpdateState();
}

class _EmployeeInternUpdateState extends State<EmployeeInternUpdate> {
  final List<String> industryTypes = [
    "Engineering",
    "Design",
    "NGO",
    "Science",
    "Media",
    "Humanities",
    "MBA",
  ];
  final List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
  final List<String> durs = ['Weeks', 'Months'];
  final List<String> durs1 = ['Weekly', 'Monthly'];
  late List<String> selectedInternshipTypes;
  late List<String> selectedPerks;
  List<Map<String, String>> items = [];
  List<Map<String, String>> skills = [];
  final TextEditingController optionEditingController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController _noOfOpeningsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stipendController = TextEditingController();
  String? selectedValue;
  late String _radioOption;
  int id = 0;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    selectedValue = widget.selectedValue;
    checkAndSetRadioOption();
    selectedCities = List.from(widget.selectedCities);
    _noOfOpeningsController.text = widget.noOfOpeningsController.text;
    selectedInternshipTypes = List.from(widget.selectedInternshipTypes);
    numberValue = widget.numberValue;
    if (widget.selectedDuration == "M") {
      selectedDuration = "Months";
    } else if (widget.selectedDuration == "W") {
      selectedDuration = "Weeks";
    } else {
      selectedDuration = "Weeks";
    }
    _descriptionController.text = widget.descriptionController.text;
    if (widget.selectedType == "Performance based") {
      selectedType = "Performance\nbased";
    } else {
      selectedType = widget.selectedType;
    }
    _stipendController.text = widget.stipendController.text;
    if (widget.selectedDuration1 == "Months") {
      selectedDuration1 = "Monthly";
    } else if (widget.selectedDuration1 == "Weeks") {
      selectedDuration1 = "Weekly";
    } else {
      selectedDuration1 = "Weekly";
    }
    selectedPerks = List.from(widget.selectedPerks);
    selectedSkills = List.from(widget.selectedSkills);
    cities();
    skill();
    selectedOption = getCurrentTime();
  }

  late List<String> selectedCities;
  late List<String> selectedSkills;
  String? numberValue;
  String selectedOption = '';
  String? selectedDuration;
  String selectedType = '';
  String? selectedDuration1;
  late bool _showTextField = false;
  List<String> predefinedOptions = [
    'Business Development',
    'Campus Ambassador',
    'Content Writing',
    'Electrical and Electronics',
    'Finance-Commerce',
    'Graphic Design',
    'Human Resources',
    'Mechanical-Production',
    'Media and Entertainment',
    'Mobile App',
    'Operations',
    'Social Media Marketing',
    'Web Development',
  ];
  int intshipid = 0;

  void checkAndSetRadioOption() {
    if (predefinedOptions.contains(widget.radioOption)) {
      _radioOption = widget.radioOption;
    } else {
      _radioOption = 'Options';
      _showTextField = true;
      optionEditingController.text = widget.radioOption;
    }
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)} ${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}";
    return formattedTime;
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> cities() async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getLocationMasterDetails'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          items = data.map<Map<String, String>>((item) => {
            'value' : item['value'].toString(),
            'label' : item['label'].toString(),
          }).toList();
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

  Future<void> skill() async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getSoftwareSkill'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          skills = data.map<Map<String, String>>((item1) => {
            'value' : item1['value'].toString(),
            'label' : item1['label'].toString(),
          }).toList();
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

  postint1(String id, employerId, email, companyname, industryType, internshipDetails, location, totalOpening, type, duration1, duration2, startdate, jobDescription, stipendType, compensation1, compensation2, perks, skill) async {
    try{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}updateEmployerInternship'),
          body: {
            'id' : id,
            'employer_id' : employerId,
            'email' : email,
            'companyname' : companyname,
            'industry_type' : industryType,
            'internship_details' : internshipDetails,
            'location' : location,
            'total_opening' : totalOpening,
            'type' : type,
            'duration1' : duration1,
            'duration2' : duration2,
            'startdate' : startdate,
            'job_description' : jobDescription,
            'stipend_type' : stipendType,
            'compensation1' : compensation1,
            'compensation2' : compensation2,
            'perks' : perks,
            'skill' : skill
          }
      );
      if(response.statusCode == 200 | 201) {
        Navigator.pop(context);
        var data = jsonDecode(response.body.toString());
        //print(data);
        intshipid = data['intshipid'];
        Get.snackbar(
          'Success',
          'Internship Posted Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        widget.refreshCallback.call();
        Navigator.pop(context);
      }
      else {
        Navigator.pop(context);
        var data = jsonDecode(response.body.toString());
        print(data);
      }
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> active(int intshipid) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}activateEmployerInternship/$intshipid'),
      );
      if(response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        Get.snackbar(
          'Success',
          'Internship activated successfully',
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

  void updateSelectedOptions(String option) {
    option = option.toLowerCase();
    setState(() {
      if (selectedPerks.contains(option)) {
        selectedPerks.remove(option);
      } else {
        selectedPerks.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leadingWidth: width * 0.1,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: GestureDetector(
          onTap: () async {
            Get.offAll(() => const AuthPage()); // Use a callback to instantiate AuthScreen
          },
          child: Image.asset(
            'lib/icons/logo.png',
            width: width * 0.47,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(width * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.005,),
              Text(
                'Post new Internship / Job',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.07),
              ),
              SizedBox(height: height * 0.015,),
              Divider(
                thickness: 1,
                color: Colors.grey[400],
              ),
              SizedBox(height: height * 0.015,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organization Name:  ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.04),
                  ),
                  Flexible(
                    child: Text(
                      widget.name,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.04),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Industry Type', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
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
                          value: selectedValue,
                          hint: Text(
                            'Select Industry',
                            style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                          ),
                          items: industryTypes.map((industryType) => DropdownMenuItem<String>(
                            value: industryType,
                            child: Text(
                              industryType,
                              style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
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
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03,),
                    Text('Internship Details', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Business Development'),
                          value: 'Business Development',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Campus Ambassador'),
                          value: 'Campus Ambassador',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Content Writing'),
                          value: 'Content Writing',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Electrical and Electronics'),
                          value: 'Electrical and Electronics',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Finance-Commerce'),
                          value: 'Finance-Commerce',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Graphic Design'),
                          value: 'Graphic Design',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Human Resources'),
                          value: 'Human Resources',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Mechanical-Production'),
                          value: 'Mechanical-Production',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Media and Entertainment'),
                          value: 'Media and Entertainment',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Mobile App'),
                          value: 'Mobile App',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Operations'),
                          value: 'Operations',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Social Media Marketing'),
                          value: 'Social Media Marketing',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Web Development'),
                          value: 'Web development',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: ListTileTheme(
                        horizontalTitleGap: 0.1,
                        child: RadioListTile<String>(
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Others'),
                          value: 'Others',
                          groupValue: _radioOption,
                          onChanged: (value) {
                            setState(() {
                              _radioOption = value!;
                              _showTextField = _radioOption == 'Others';
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _showTextField,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.03,),
                          SizedBox(
                            height: height * 0.06,
                            child: TextFormField(
                              controller: optionEditingController,
                              onChanged: (value) {
                                setState(() {
                                  if (predefinedOptions.contains(value)) {
                                    _radioOption = value;
                                    _showTextField = false;
                                  } else {
                                    _radioOption = 'Others';
                                  }
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  _radioOption = optionEditingController.text.trim();
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(color: Colors.red),
                                ),
                                hintText: "Enter your option",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    setState(() {
                                      const BorderSide(color: Colors.green);
                                      _radioOption = optionEditingController.text.trim();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.005,),
                          Text('Tap on the tick mark after typing', style: TextStyle(fontSize: width * 0.033, color: const Color.fromRGBO(44, 56, 149, 1)),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03,),
              Text('Scope', style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w600),),
              SizedBox(height: height * 0.02,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('City/Cities', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
                    SizedBox(height: height * 0.015,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            runSpacing: -8.0,
                            children: selectedCities.map((city) {
                              return Container(
                                padding: const EdgeInsets.only(left: 8),
                                child: InputChip(
                                  label: Text(city),
                                  onDeleted: () {
                                    setState(() {
                                      selectedCities.remove(city);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select City',
                                style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                              ),
                              items: items.map((item) => DropdownMenuItem(
                                value: item['value'],
                                child: Text(
                                  item['label']!,
                                  style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                ),
                              )).toList(),
                              onChanged: (value) {
                                if (!selectedCities.contains(value)) {
                                  setState(() {
                                    selectedCities.add(value!);
                                  });
                                }
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
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: 'Search for your city',
                                      hintStyle: TextStyle(fontSize: width * 0.037),
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
                    SizedBox(height: height * 0.015,),
                    SizedBox(
                      height: height * 0.06,
                      child: TextFormField(
                        controller: _noOfOpeningsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                          hintText: "No of Openings * (Only Numbers)",
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03,),
                    Text('Internship Type', style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w600),),
                    SizedBox(
                      height: height * 0.04,
                      child: CheckboxListTile(
                        activeColor: const Color.fromRGBO(44, 56, 149, 1),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Full Time'),
                        value: selectedInternshipTypes.contains('full time'),
                        onChanged: (value) {
                          handleCheckboxChange('full time', value!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: CheckboxListTile(
                        activeColor: const Color.fromRGBO(44, 56, 149, 1),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Work From Home'),
                        value: selectedInternshipTypes.contains('work from home'),
                        onChanged: (value) {
                          handleCheckboxChange('work from home', value!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: CheckboxListTile(
                        activeColor: const Color.fromRGBO(44, 56, 149, 1),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Internships For Women'),
                        value: selectedInternshipTypes.contains('internships for women'),
                        onChanged: (value) {
                          handleCheckboxChange('internships for women', value!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: CheckboxListTile(
                        activeColor: const Color.fromRGBO(44, 56, 149, 1),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('On Field/Office'),
                        value: selectedInternshipTypes.contains('on field/office'),
                        onChanged: (value) {
                          handleCheckboxChange('on field/office', value!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: CheckboxListTile(
                        activeColor: const Color.fromRGBO(44, 56, 149, 1),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Part Time'),
                        value: selectedInternshipTypes.contains('part time'),
                        onChanged: (value) {
                          handleCheckboxChange('part time', value!);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: CheckboxListTile(
                        activeColor: const Color.fromRGBO(44, 56, 149, 1),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Internships Job Offer'),
                        value: selectedInternshipTypes.contains('internships job offer'),
                        onChanged: (value) {
                          handleCheckboxChange('internships job offer', value!);
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.03,),
                    Text('Internship Duration', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
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
                          value: numberValue,
                          hint: Text(
                            'Select Duration 1',
                            style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                          ),
                          items: numbers.map((number) => DropdownMenuItem<String>(
                            value: number,
                            child: Text(
                              number,
                              style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              numberValue = value;
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
                        ),
                      ),
                    ),
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
                          value: selectedDuration,
                          hint: Text(
                            'Select Duration 2',
                            style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                          ),
                          items: durs.map((dur) => DropdownMenuItem<String>(
                            value: dur,
                            child: Text(
                              dur,
                              style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                            ),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDuration = value;
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
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03,),
                    Text('Internship Start Date', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
                    ListTileTheme(
                      horizontalTitleGap: 0.1,
                      child: RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          activeColor: const Color.fromRGBO(44, 56, 149, 1),
                          title: const Text('Immediately (within next 30 days)'),
                          value: getCurrentTime(),
                          groupValue: getCurrentTime(),
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          }
                      ),
                    ),
                    SizedBox(height: height * 0.015,),
                    Text('Internship description', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
                    SizedBox(height: height * 0.015,),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null, // Set to null for unlimited lines
                      decoration: InputDecoration(
                        hintText: 'Write description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.035,),
              Text('Stipend', style: TextStyle(fontSize: width * 0.05,fontWeight: FontWeight.w600),),
              SizedBox(height: height * 0.02,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type:', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
                    SizedBox(height: height * 0.015,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRadioButton("Fixed"),
                            //const SizedBox(height: 5,),
                            buildRadioButton("Performance\nbased"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRadioButton("Negotiable"),
                            const SizedBox(height: 5.5),
                            buildRadioButton("Unpaid"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02,),
                    Visibility(
                      visible: (selectedType == 'Fixed' || selectedType == 'Negotiable' || selectedType == 'Performance\nbased' || selectedType == ''),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.06,
                            child: TextFormField(
                              controller: _stipendController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                                hintText: "e.g.5000",
                              ),
                            ),
                          ),
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
                                value: selectedDuration1,
                                hint: Text(
                                  'Select Duration',
                                  style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                ),
                                items: durs1.map((dur1) => DropdownMenuItem<String>(
                                  value: dur1,
                                  child: Text(
                                    dur1,
                                    style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                  ),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDuration1 = value;
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
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03,),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('Perks', style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w600),),
                        Text(' (Optional)', style: TextStyle(fontSize: width * 0.03),)
                      ],
                    ),
                    Column(
                      children: [
                        buildCheckBoxOption('Certificate'),
                        buildCheckBoxOption('Flexible Working Hours'),
                        buildCheckBoxOption('Informal Dress Code'),
                        buildCheckBoxOption('1 Leave Per Month'),
                        buildCheckBoxOption('6 Hours per Week'),
                        buildCheckBoxOption('Free Snacks'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.04,),
              Text('Skills Required', style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w600),),
              SizedBox(height: height * 0.02,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Skills', style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w600),),
                    SizedBox(height: height * 0.015,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            runSpacing: -8.0,
                            children: selectedSkills.map((skill) {
                              return Container(
                                padding: const EdgeInsets.only(left: 8),
                                child: InputChip(
                                  label: Text(skill),
                                  onDeleted: () {
                                    setState(() {
                                      selectedSkills.remove(skill);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Skills',
                                style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                              ),
                              items: skills.map((item) => DropdownMenuItem(
                                value: item['value'],
                                child: Text(
                                  item['label']!,
                                  style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                                ),
                              )).toList(),
                              onChanged: (value) {
                                if (!selectedSkills.contains(value)) {
                                  setState(() {
                                    selectedSkills.add(value!);
                                  });
                                }
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
                                      contentPadding: const EdgeInsets
                                          .symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: 'Search...',
                                      hintStyle: TextStyle(fontSize: width * 0.037),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (skill, searchValue) {
                                  return skill.value!
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
                    SizedBox(height: height * 0.01,),
                    Text(
                      'Add skills to get applicants with the skills that matches most',
                      style: TextStyle(fontSize: width * 0.03, color: const Color.fromRGBO(44, 56, 149, 1)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03,),
              /*Row(
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        await postint1(
                          id.toString(),
                          widget.recId.toString(),
                          widget.email.toString(),
                          widget.name.toString(),
                          selectedValue.toString(),
                          _radioOption.toString(),
                          selectedCities.join(', '),
                          _noOfOpeningsController.text.toString(),
                          selectedInternshipTypes.join(', '),
                          numberValue.toString(),
                          selectedDuration.toString(),
                          selectedOption.toString(),
                          _descriptionController.text.toString(),
                          selectedType.toString(),
                          _stipendController.text.toString(),
                          selectedDuration1.toString(),
                          selectedPerks.join(', '),
                          selectedSkills.join(', '),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          foregroundColor: const Color.fromRGBO(44, 56, 149, 1),
                          side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 11,horizontal: 16)
                      ),
                      child: const Text("Save Draft", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                  ),
                  SizedBox(
                    width: width * 0.025,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await postint1(
                          id.toString(),
                          widget.recId.toString(),
                          widget.email.toString(),
                          widget.name.toString(),
                          selectedValue.toString(),
                          _radioOption.toString(),
                          selectedCities.join(', '),
                          _noOfOpeningsController.text.toString(),
                          selectedInternshipTypes.join(', '),
                          numberValue.toString(),
                          selectedDuration.toString(),
                          selectedOption.toString(),
                          _descriptionController.text.toString(),
                          selectedType.toString(),
                          _stipendController.text.toString(),
                          selectedDuration1.toString(),
                          selectedPerks.join(', '),
                          selectedSkills.join(', '),
                        );
                        await active(intshipid);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                        side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      ),
                      child: const Text("Post Internship",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                ],
              ),*/
              IgnorePointer(
                ignoring: widget.status != 'Active',
                child: Opacity(
                  opacity: widget.status != 'Active' ? 0.5 : 1.0,
                  child: Row(
                    children: [
                      OutlinedButton(
                          onPressed: () async {
                            String durationType = selectedDuration == 'Weeks' ? 'W' : 'M';
                            String durationType1 = selectedDuration1 == 'Weekly' ? 'Weeks' : 'Months';
                            await postint1(
                              id.toString(),
                              widget.recId.toString(),
                              widget.email.toString(),
                              widget.name.toString(),
                              selectedValue.toString(),
                              _radioOption.toString(),
                              selectedCities.join(', '),
                              _noOfOpeningsController.text.toString(),
                              selectedInternshipTypes.join(', '),
                              numberValue.toString(),
                              durationType,
                              selectedOption.toString(),
                              _descriptionController.text.toString(),
                              selectedType.toString(),
                              _stipendController.text.toString(),
                              durationType1,
                              selectedPerks.join(', '),
                              selectedSkills.join(', '),
                            );
                            },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)
                              ),
                              foregroundColor: const Color.fromRGBO(44, 56, 149, 1),
                              side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 11,horizontal: 16)
                          ),
                          child: const Text("Save Draft", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                      ),
                      SizedBox(
                        width: width * 0.025,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            String durationType = selectedDuration == 'Weeks' ? 'W' : 'M';
                            String durationType1 = selectedDuration1 == 'Weekly' ? 'Weeks' : 'Months';
                            await postint1(
                              id.toString(),
                              widget.recId.toString(),
                              widget.email.toString(),
                              widget.name.toString(),
                              selectedValue.toString(),
                              _radioOption.toString(),
                              selectedCities.join(', '),
                              _noOfOpeningsController.text.toString(),
                              selectedInternshipTypes.join(', '),
                              numberValue.toString(),
                              durationType,
                              selectedOption.toString(),
                              _descriptionController.text.toString(),
                              selectedType.toString(),
                              _stipendController.text.toString(),
                              durationType1,
                              selectedPerks.join(', '),
                              selectedSkills.join(', '),
                            );
                            await active(intshipid);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                            side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                          ),
                          child: const Text("Post Internship",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.01,),
              OutlinedButton(
                  onPressed: () {
                    Get.to(() => EmployeeDashboard(erecId: widget.recId, eemail: widget.email, efullname: widget.name, eemptoken: widget.emptoken));
                  },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)
                      ),
                      foregroundColor: const Color.fromRGBO(249, 143, 67, 1),
                      side: const BorderSide(color: Color.fromRGBO(249, 143, 67, 1), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 11,horizontal: 16)
                  ),
                  child: const Text("Back to Dashboard", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
              ),
              SizedBox(height: height * 0.03,),
            ],
          ),
        ),
      ),
    );
  }
  void handleCheckboxChange(String value, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedInternshipTypes.add(value);
      } else {
        selectedInternshipTypes.remove(value);
      }
    });
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
            value: type,
            groupValue: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value!;
                _stipendController.clear();
                selectedDuration1 = null;
              });
            },
          ),
        ),
        Text(type, style: TextStyle(fontSize: width * 0.04),),
        SizedBox(width: width * 0.04), // Adjust the spacing between radio buttons
      ],
    );
  }
  Widget buildCheckBoxOption(String option) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.04,
      child: CheckboxListTile(
        activeColor: const Color.fromRGBO(44, 56, 149, 1),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(option),
        value: selectedPerks.contains(option.toLowerCase()),
        onChanged: (value) {
          updateSelectedOptions(option);
        },
      ),
    );
  }
}