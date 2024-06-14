import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../utils/api_endpoints.dart';
import '../auth_screen.dart';

class Filter extends StatefulWidget {
  final List<String> skills, cities;
  final String duration, lastUpdate, stipend, wfh, ifw, ft, pt, iwjo, ofo;
  final VoidCallback refreshCallback;
  final VoidCallback refreshCallback1;
  final Function(String, String, String, String, String, String, String, String, String, String, String) callback;
  const Filter({super.key, required this.refreshCallback, required this.callback, required this.refreshCallback1, required this.skills, required this.cities, required this.duration, required this.lastUpdate, required this.stipend, required this.wfh, required this.ifw, required this.ft, required this.pt, required this.iwjo, required this.ofo});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void  _initializeValues() {
    skill();
    cities();
    selectedSkills = List.from(widget.skills);
    selectedCities = List.from(widget.cities);
    if (widget.duration == "duration-1-M") {
      selectedDuration = "1-Month";
    } else if (widget.duration == "duration-2-M") {
      selectedDuration = "2-Months";
    } else if (widget.duration == "duration-3-M") {
      selectedDuration = "3-Months";
    } else if (widget.duration == "duration-4-M") {
      selectedDuration = "4-Months";
    } else if (widget.duration == "duration-5-M") {
      selectedDuration = "5-Months";
    } else if (widget.duration == "duration-6-M") {
      selectedDuration = "6-Months";
    } else if (widget.duration == "duration-7-M") {
      selectedDuration = "7-Months";
    } else if (widget.duration == "duration-8-M") {
      selectedDuration = "8-Months";
    } else if (widget.duration == "duration-9-M") {
      selectedDuration = "9-Months";
    } else if (widget.duration == "duration-10-M") {
      selectedDuration = "10-Months";
    } else if (widget.duration == "duration-11-M") {
      selectedDuration = "11-Months";
    } else if (widget.duration == "duration-12-M") {
      selectedDuration = "12-Months";
    } else if(widget.duration == 'duration-1-W') {
      selectedDuration = '1-Week';
    } else if (widget.duration == "duration-2-W") {
      selectedDuration = "2-Weeks";
    } else if (widget.duration == "duration-3-W") {
      selectedDuration = "3-Weeks";
    } else if (widget.duration == "duration-4-W") {
      selectedDuration = "4-Weeks";
    } else if (widget.duration == "duration-5-W") {
      selectedDuration = "5-Weeks";
    } else if (widget.duration == "duration-6-W") {
      selectedDuration = "6-Weeks";
    } else if (widget.duration == "duration-7-W") {
      selectedDuration = "7-Weeks";
    } else if (widget.duration == "duration-8-W") {
      selectedDuration = "8-Weeks";
    } else if (widget.duration == "duration-9-W") {
      selectedDuration = "9-Weeks";
    } else if (widget.duration == "duration-10-W") {
      selectedDuration = "10-Weeks";
    } else if (widget.duration == "duration-11-W") {
      selectedDuration = "11-Weeks";
    } else if (widget.duration == "duration-12-W") {
      selectedDuration = "12-Weeks";
    } else if (widget.duration == "all-duration") {
      selectedDuration = "All";
    } else {
      selectedDuration = null;
    }
    if (widget.lastUpdate == "Last-1-Day") {
      selectedLastUpdate = "Last 1 Day";
    } else if (widget.lastUpdate == "Last-3-Days") {
      selectedLastUpdate = "Last 3 Days";
    } else if (widget.lastUpdate == "Last-7-Days") {
      selectedLastUpdate = "Last 7 Days";
    } else if (widget.lastUpdate == "all") {
      selectedLastUpdate = "All";
    } else {
      selectedLastUpdate = null;
    }
    if (widget.stipend == "stipend-unpaid") {
      selectedStipend = "Unpaid";
    } else if (widget.stipend == "stipend-0,2000") {
      selectedStipend = "0-2000";
    } else if (widget.stipend == "stipend-2001,5000") {
      selectedStipend = "2000-5000";
    } else if (widget.stipend == "stipend-5000,max") {
      selectedStipend = "Above 5000";
    }  else if (widget.stipend == "stipend-any") {
      selectedStipend = "All";
    } else {
      selectedStipend = null;
    }
    wfh = widget.wfh;
    ifw = widget.ifw;
    ft = widget.ft;
    pt = widget.pt;
    iwjo = widget.iwjo;
    ofo = widget.ofo;
  }

  final TextEditingController textEditingController = TextEditingController();
  List<String> selectedSkills = [];
  String selectedSkillsValue = '';
  List<Map<String, String>> skills = [];
  List<String> selectedCities = [];
  String selectedCitiesValue = '';
  List<Map<String, String>> items = [];
  String? selectedDuration;
  String selectedDurationValue = 'all-duration';
  List<String> duration = [
    "All",
    "1-Month",
    "2-Months",
    "3-Months",
    "4-Months",
    "5-Months",
    "6-Months",
    "7-Months",
    "8-Months",
    "9-Months",
    "10-Months",
    "11-Months",
    "12-Months",
    "1-Week",
    "2-Weeks",
    "3-Weeks",
    "4-Weeks",
    "5-Weeks",
    "6-Weeks",
    "7-Weeks",
    "8-Weeks",
    "9-Weeks",
    "10-Weeks",
    "11-Weeks",
    "12-Weeks",
  ];
  String? selectedLastUpdate;
  String selectedLastUpdateValue = 'all';
  final List<String> lastUpdate = [
    "All",
    "Last 1 Day",
    "Last 3 Days",
    "Last 7 Days",
  ];
  String? selectedStipend;
  String selectedStipendValue = 'stipend-any';
  final List<String> stipend = [
    "All",
    "Unpaid",
    "0-2000",
    "2000-5000",
    "Above 5000",
  ];
  String wfh = 'all';
  String ifw = 'all';
  String ft = 'all';
  String pt = 'all';
  String iwjo = 'all';
  String ofo = 'all';

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
          padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Filters',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),
                ),
              ),
              SizedBox(height: height * 0.015,),
              const Text('Skills', style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600),),
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
                            style: TextStyle(fontSize: width * 0.035),
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
                                contentPadding: const EdgeInsets.symmetric(
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
              SizedBox(height: height * 0.02,),
              Text('Locations', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
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
                      runSpacing: -8.0, // This will make chips flow to the next line when needed
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
                          'Select Locations',
                          style: TextStyle(fontSize: width * 0.035, color: Colors.black),
                        ),
                        items: items.map((item) => DropdownMenuItem(
                          value: item['value'],
                          child: Text(
                            item['label']!,
                            style: TextStyle(fontSize: width * 0.035),
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
              SizedBox(height: height * 0.02,),
              Text('Duration', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
              SizedBox(height: height * 0.015,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: selectedDuration,
                    hint: Text(
                      'Select Duration',
                      style: TextStyle(fontSize: width * 0.035,color: Colors.black87),
                    ),
                    items: duration.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: width * 0.035),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value;
                        if (value == "1-Month") {
                          selectedDurationValue = "duration-1-M";
                        } else if (value == "2-Months") {
                          selectedDurationValue = "duration-2-M";
                        } else if (value == "3-Months") {
                          selectedDurationValue = "duration-3-M";
                        } else if (value == "4-Months") {
                          selectedDurationValue = "duration-4-M";
                        } else if (value == "5-Months") {
                          selectedDurationValue = "duration-5-M";
                        } else if (value == "6-Months") {
                          selectedDurationValue = "duration-6-M";
                        } else if (value == "7-Months") {
                          selectedDurationValue = "duration-7-M";
                        } else if (value == "8-Months") {
                          selectedDurationValue = "duration-8-M";
                        } else if (value == "9-Months") {
                          selectedDurationValue = "duration-9-M";
                        } else if (value == "10-Months") {
                          selectedDurationValue = "duration-10-M";
                        } else if (value == "11-Months") {
                          selectedDurationValue = "duration-11-M";
                        } else if (value == "12-Months") {
                          selectedDurationValue = "duration-12-M";
                        } else if (value == "1-Week") {
                          selectedDurationValue = "duration-1-W";
                        } else if (value == "2-Weeks") {
                          selectedDurationValue = "duration-2-W";
                        } else if (value == "3-Weeks") {
                          selectedDurationValue = "duration-3-W";
                        } else if (value == "4-Weeks") {
                          selectedDurationValue = "duration-4-W";
                        } else if (value == "5-Weeks") {
                          selectedDurationValue = "duration-5-W";
                        } else if (value == "6-Weeks") {
                          selectedDurationValue = "duration-6-W";
                        } else if (value == "7-Weeks") {
                          selectedDurationValue = "duration-7-W";
                        } else if (value == "8-Weeks") {
                          selectedDurationValue = "duration-8-W";
                        } else if (value == "9-Weeks") {
                          selectedDurationValue = "duration-9-W";
                        } else if (value == "10-Weeks") {
                          selectedDurationValue = "duration-10-W";
                        } else if (value == "11-Weeks") {
                          selectedDurationValue = "duration-11-W";
                        } else if (value == "12-Weeks") {
                          selectedDurationValue = "duration-12-W";
                        }
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
              SizedBox(height: height * 0.02,),
              Text('Last Updated', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
              SizedBox(height: height * 0.015,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: selectedLastUpdate,
                    hint: Text(
                      'Last Updated',
                      style: TextStyle(fontSize: width * 0.035,color: Colors.black87),
                    ),
                    items: lastUpdate.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: width * 0.035),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLastUpdate = value;
                        if (value == "Last 1 Day") {
                          selectedLastUpdateValue = "Last-1-Day";
                        } else if (value == "Last 3 Days") {
                          selectedLastUpdateValue = "Last-3-Days";
                        } else if (value == "Last 7 Days") {
                          selectedLastUpdateValue = "Last-7-Days";
                        }
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
              SizedBox(height: height * 0.02,),
              Text('Stipend', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
              SizedBox(height: height * 0.015,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: selectedStipend,
                    hint: Text(
                      'Select Stipend',
                      style: TextStyle(fontSize: width * 0.035,color: Colors.black87),
                    ),
                    items: stipend.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: width * 0.035),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStipend = value;
                        if (value == "Unpaid") {
                          selectedStipendValue = "stipend-unpaid";
                        } else if (value == "0-2000") {
                          selectedStipendValue = "stipend-0,2000";
                        } else if (value == "2000-5000") {
                          selectedStipendValue = "stipend-2001,5000";
                        } else if (value == "Above 5000") {
                          selectedStipendValue = "stipend-5000,max";
                        }
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
              SizedBox(height: height * 0.02,),
              Text('Internship Type', style: TextStyle(fontSize: width * 0.04,fontWeight: FontWeight.w600),),
              SizedBox(
                height: height * 0.04,
                child: CheckboxListTile(
                  activeColor: const Color.fromRGBO(44, 56, 149, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Work From Home'),
                  value: wfh == 'work-from-home',
                  onChanged: (value) {
                    setState(() {
                      wfh = value! ? 'work-from-home' : 'all';
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
                child: CheckboxListTile(
                  activeColor: const Color.fromRGBO(44, 56, 149, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Internships for Women'),
                  value: ifw == 'internships-for-women',
                  onChanged: (value) {
                    setState(() {
                      ifw = value! ? 'internships-for-women' : 'all';
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
                child: CheckboxListTile(
                  activeColor: const Color.fromRGBO(44, 56, 149, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Full Time'),
                  value: ft == 'full-time-internships',
                  onChanged: (value) {
                    setState(() {
                      ft = value! ? 'full-time-internships' : 'all';
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
                child: CheckboxListTile(
                  activeColor: const Color.fromRGBO(44, 56, 149, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Part Time'),
                  value: pt == 'part-time-internships',
                  onChanged: (value) {
                    setState(() {
                      pt = value! ? 'part-time-internships' : 'all';
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
                child: CheckboxListTile(
                  activeColor: const Color.fromRGBO(44, 56, 149, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Internships with Job Offer'),
                  value: iwjo == 'with-job-offer',
                  onChanged: (value) {
                    setState(() {
                      iwjo = value! ? 'with-job-offer' : 'all';
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
                child: CheckboxListTile(
                  activeColor: const Color.fromRGBO(44, 56, 149, 1),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('On Field/Office'),
                  value: ofo == 'onfield-office',
                  onChanged: (value) {
                    setState(() {
                      ofo = value! ? 'onfield-office' : 'all';
                    });
                  },
                ),
              ),
              SizedBox(height: height * 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        if (selectedSkills.isNotEmpty) {
                          selectedSkillsValue = selectedSkills.join(', ');
                        }
                        if (selectedCities.isNotEmpty) {
                          selectedCitiesValue = selectedCities.join(', ');
                        }
                        selectedDuration = selectedDurationValue;
                        selectedLastUpdate = selectedLastUpdateValue;
                        selectedStipend = selectedStipendValue;

                        widget.callback(selectedSkillsValue, selectedCitiesValue, selectedDuration!, selectedLastUpdate!, selectedStipend!, wfh, ifw, ft, pt, iwjo, ofo);
                        widget.refreshCallback.call();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1), width: 2),
                          padding: EdgeInsets.symmetric(vertical: height * 0.012, horizontal: width * 0.04)
                      ),
                      child: const Text("Apply", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
                  ),
                  SizedBox(width: width * 0.03,),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCities.clear();
                          selectedSkills.clear();
                          selectedDuration = null;
                          selectedLastUpdate = null;
                          selectedStipend = null;
                          wfh = 'all';
                          ifw = 'all';
                          ft = 'all';
                          pt = 'all';
                          iwjo = 'all';
                          ofo = 'all';
                          widget.refreshCallback1.call();
                        });
                        },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          foregroundColor: const Color.fromRGBO(249, 143, 67, 1),
                          side: const BorderSide(color: Color.fromRGBO(249, 143, 67, 1), width: 2),
                          padding: EdgeInsets.symmetric(vertical: height * 0.012, horizontal: width * 0.04)
                      ),
                      child: const Text("Clear All", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)
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
}