import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/api_endpoints.dart';

class ScheduleScreenEmp extends StatefulWidget {
  final int id, currentId;
  final String stuname, internshipDetails, emptoken;
  const ScheduleScreenEmp({super.key, required this.id, required this.internshipDetails, required this.stuname, required this.emptoken, required this.currentId});

  @override
  State<ScheduleScreenEmp> createState() => _ScheduleScreenEmpState();
}

class _ScheduleScreenEmpState extends State<ScheduleScreenEmp> {
  late TextEditingController _titleController;
  final _linkController = TextEditingController(text: '');
  final _contactController = TextEditingController(text: '');
  final _addressController = TextEditingController(text: '');
  final _descriptionController = TextEditingController(text: '');
  String selectedDuration = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Color _containerColor = const Color.fromRGBO(44, 56, 149, 1);
  String _selectedType = 'Video Call';
  late DateTime combinedDateTime;
  String formattedDateTime = '';
  String interviewType = '1';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: 'Interview Schedule - ${widget.internshipDetails}: ${widget.stuname}',
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  schedule(String title, address, contactno, desc, duration, id, internshipApplicationId, interviewDateTime, interviewType, interviewLink) async {
    try{
      Response response = await post(
          Uri.parse('${ApiEndPoints.baseUrl}updateInterviewSchedule'),
          body: {
            'id' : id,
            'address' : address,
            'contactno' : contactno,
            'desc' : desc,
            'duration' : duration,
            'internshipApplicationId' : internshipApplicationId,
            'interviewDateTime' : interviewDateTime,
            'interviewLink' : interviewLink,
            'interviewType' : interviewType,
            'title' : title,
          }
      );
      print('Response Status Code: ${response.statusCode}');
      if(response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Interview Scheduled Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
        Get.snackbar(
          'Failed',
          'All Fields are Mandatory',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    formattedDateTime = "${combinedDateTime.year}-${combinedDateTime.month.toString().padLeft(2, '0')}-${combinedDateTime.day.toString().padLeft(2, '0')} ${combinedDateTime.hour.toString().padLeft(2, '0')}:${combinedDateTime.minute.toString().padLeft(2, '0')}";
    if (_selectedType == 'Video Call') {
      interviewType = '1';
    } else if (_selectedType == 'Phone') {
      interviewType = '2';
    } else if (_selectedType == 'In Office') {
      interviewType = '3';
    }
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
        ),
        title: Text("Schedule Interview", style: TextStyle(fontSize: width * 0.045),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Row(
            children: [
              const Icon(Iconsax.calendar_add, size: 30,),
              SizedBox(width: width * 0.04,)
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("To: ",style: TextStyle(fontSize: 18),),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: Text(widget.stuname, style: const TextStyle(fontSize: 18),),
                  )
                ],
              ),
              SizedBox(height: height * 0.03,),
              const Text("Add Title", style: TextStyle(fontSize: 18),),
              SizedBox(height: height * 0.01,),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03,),
              const Text("Interview date", style: TextStyle(fontSize: 18),),
              SizedBox(height: height * 0.01,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(7)
                ),
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedDate.year}-${selectedDate.month < 10 ? '0${selectedDate.month}' : selectedDate.month}-${selectedDate.day < 10 ? '0${selectedDate.day}' : selectedDate.day}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.calendar),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03,),
              const Text("Interview time", style: TextStyle(fontSize: 18),),
              SizedBox(height: height * 0.01,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(7)
                ),
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedTime.hour < 10 ? '0${selectedTime.hour}' : selectedTime.hour}:${selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.clock_14),
                      onPressed: () => _selectTime(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03,),
              const Text("Duration", style: TextStyle(fontSize: 18),),
              SizedBox(height: height * 0.01,),
              Row(
                children: [
                  buildRadioButton("30 Minute", "1"),
                  buildRadioButton("60 Minute", "2"),
                ],
              ),
              SizedBox(height: height * 0.03,),
              const Text("Interview Type", style: TextStyle(fontSize: 18),),
              SizedBox(height: height * 0.01,),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Change the color on tap
                      setState(() {
                        _containerColor = const Color.fromRGBO(44, 56, 149, 1);
                        _selectedType = 'Video Call';
                        _contactController.clear();
                        _addressController.clear();
                      });
                    },
                    child: Container(
                      height: 60,
                      width: width * 0.25,
                      decoration:  BoxDecoration(
                        border: Border.all(width: 1, color: const Color.fromRGBO(44, 56, 149, 1)),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                        color: _selectedType == 'Video Call' ? _containerColor : null,
                      ),
                      child: Center(child: Text('Video Call', style: TextStyle(color: _selectedType == 'Video Call' ? Colors.white : Colors.black, fontWeight: _selectedType == 'Video Call' ? FontWeight.bold : FontWeight.normal, fontSize: 16),)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _containerColor = _selectedType == 'Phone' ? Colors.white : const Color.fromRGBO(44, 56, 149, 1);
                        _selectedType = 'Phone';
                        _linkController.clear();
                        _addressController.clear();
                      });
                    },
                    child: Container(
                      height: 60,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        border: const Border.symmetric(horizontal: BorderSide(width: 1, color: Color.fromRGBO(44, 56, 149, 1)) ),
                        color: _selectedType == 'Phone' ? _containerColor : null,
                      ),
                      child: Center(child: Text('Phone', style: TextStyle(color: _selectedType == 'Phone' ? Colors.white : Colors.black, fontWeight: _selectedType == 'Phone' ? FontWeight.bold : FontWeight.normal, fontSize: 16),)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Change the color and selected text on tap
                      setState(() {
                        _containerColor = _selectedType == 'In Office' ? Colors.white : const Color.fromRGBO(44, 56, 149, 1);
                        _selectedType = 'In Office';
                        _linkController.clear();
                        _contactController.clear();
                      });
                    },
                    child: Container(
                      height: 60,
                      width: width * 0.25,
                      decoration:  BoxDecoration(
                          border: Border.all(width: 1, color: const Color.fromRGBO(44, 56, 149, 1)),
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(7), bottomRight: Radius.circular(7)),
                          color: _selectedType == 'In Office' ? _containerColor : null,
                      ),
                      child: Center(child: Text('In Office', style: TextStyle(color: _selectedType == 'In Office' ? Colors.white : Colors.black, fontWeight: _selectedType == 'In Office' ? FontWeight.bold : FontWeight.normal, fontSize: 16),)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03,),
              Visibility(
                visible: _selectedType == 'Video Call',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Share video call link", style: TextStyle(fontSize: 18),),
                    SizedBox(height: height * 0.01,),
                    TextField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        hintText: 'e.g. https://meet.google.com/internshipgate-interview-meet',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedType == 'Phone',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Share your contact number", style: TextStyle(fontSize: 18),),
                    SizedBox(height: height * 0.01,),
                    TextField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        hintText: '+91-7004619795',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedType == 'In Office',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Add office address", style: TextStyle(fontSize: 18),),
                    SizedBox(height: height * 0.01,),
                    TextField(
                      controller: _addressController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03,),
              const Text("Add description", style: TextStyle(fontSize: 18),),
              SizedBox(height: height * 0.01,),
              TextField(
                controller: _descriptionController,
                maxLines: null, // Set to null for unlimited lines
                decoration: InputDecoration(
                  hintText: 'Interview description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03,),
              SizedBox(
                width: width * 0.5,
                height: 60,
                child: OutlinedButton(
                  onPressed: () {
                    schedule(
                        _titleController.text.toString(),
                        _addressController.text.toString(),
                        _contactController.text.toString(),
                        _descriptionController.text.toString(),
                        selectedDuration,
                        '',
                        widget.id.toString(),
                        formattedDateTime,
                        interviewType,
                        _linkController.text.toString(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                    side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1),),
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                  ),
                  child: const Text('Scheduled Interview',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                ),
              ),
              SizedBox(height: height * 0.02,)
            ],
          ),
        ),
      ),
    );
  }
  Widget buildRadioButton(String type, value) {
    return Row(
      children: [
        SizedBox(
          height: 35,
          child: Radio<String>(
            activeColor: const Color.fromRGBO(44, 56, 149, 1),
            value: type,
            groupValue: selectedDuration,
            onChanged: (String? selectedValue) {
              setState(() {
                selectedDuration = selectedValue!;
              });
            },
          ),
        ),
        Text(type, style: const TextStyle(fontSize: 16),),
        const SizedBox(width: 20), // Adjust the spacing between radio buttons
      ],
    );
  }
}