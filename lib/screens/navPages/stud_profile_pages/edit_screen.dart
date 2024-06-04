

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:internshipgate/widgets/edit_input_textfield.dart';


// // Custom InputField widget
// class InputField extends StatelessWidget {
//   final String labelText;
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final List<String>? dropdownItems; // Add this property

//   InputField({
//     required this.labelText,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.dropdownItems, // Initialize the property
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//         suffixIcon: dropdownItems != null
//             ? DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: controller.text,
//                   items: dropdownItems!.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       controller.text = newValue;
//                     }
//                   },
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
// }

// class EditEducationDetailsPage extends StatefulWidget {
//   var educationId,
//       applicantId,
//       startDate,
//       endDate,
//       cgpa,
//       completionYear,
//       email,
//       eduType,
//       eduStatus,
//       eduBoard,
//       instituteName,
//       degree,
//       specialization,
//       performanceScale;

//   EditEducationDetailsPage({
//     required this.educationId,
//     required this.email,
//     required this.eduType,
//     required this.applicantId,
//     required this.startDate,
//     required this.endDate,
//     required this.eduStatus,
//     required this.eduBoard,
//     required this.instituteName,
//     required this.degree,
//     required this.specialization,
//     required this.completionYear,
//     required this.performanceScale,
//     required this.cgpa,
//   });
//   @override
//   _EditEducationDetailsPageState createState() =>
//       _EditEducationDetailsPageState();
// }

// class _EditEducationDetailsPageState extends State<EditEducationDetailsPage> {
  
//   List<String> specializations = [];
//   String selectedDegree = '';
//   late String _status;
//   late ValueNotifier<String> _statusNotifier;
//   TextEditingController _collegeController = TextEditingController();
//   TextEditingController _degreeController = TextEditingController();
//   TextEditingController _specializationController  = TextEditingController();
//   final TextEditingController textEditingController = TextEditingController();
//     final TextEditingController _intStartDateController = TextEditingController();
  
// List<Map<String, String>> items = [];
//   List<Map<String, String>> clgItems = [];
//   List<Map<String, String>>specializationItems = [];
//   String? selectedCollege;
//   String? selectedSpecialization;


//   Future<void> fetchCollegeList([String search = '']) async {
//     String apiUrl =
//         'https://staging-dev.internshipgate.com/public/api/getCollegeListByName';

//     if (search != null && search.isNotEmpty) {
//       apiUrl += '/$search';
//     }

//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         if (data['collegeList'] is List) {
//           List<dynamic> collegeList = data['collegeList'];

//           setState(() {
//             clgItems = collegeList.map<Map<String, String>>((item) {
//               return {
//                 'value': item['value'].toString(),
//                 'label': item['label'].toString(),
//               };
//             }).toList();
//           });
//         } else {
//           print('College list is not in the expected format.');
//         }
//       } else {
//         print('Failed to load colleges. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching colleges: $e');
//     }
//   }

 
//   Future<void> fetchDegreeList({String? type}) async {
//     String apiUrl;
//     if (type == 'P') {
//       apiUrl =
//           'https://staging-dev.internshipgate.com/public/api/getDegreeList/P';
//     } else if (type == 'G') {
//       apiUrl =
//           'https://staging-dev.internshipgate.com/public/api/getDegreeList/G';
//     } else {
//       apiUrl =
//           'https://staging-dev.internshipgate.com/public/api/getDegreeList';
//     }
//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body.toString());
//         print(data);
//         setState(() {
//           items = data
//               .map<Map<String, String>>((item) => {
//                     'value': item['value'].toString(),
//                     'label': item['label'].toString(),
//                   })
//               .toList();
//         });
//       } else {
//         var data = jsonDecode(response.body.toString());
//         print(data);
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }












//   Future<void> fetchSpecializationList(String degree) async {
//   String apiUrl = 'https://staging-dev.internshipgate.com/public/api/getSpecializationList/$degree';

//   try {
//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       print(data);
//       setState(() {
//   specializationItems = data
//       .expand<Map<String, String>>((item) =>
//           (item['value'] as String).split(',').map((label) => {
//                 'value': label.trim(),
//                 'label': label.trim(),
//               }))
//       .toList();
// });

//     } else {
//       var data = jsonDecode(response.body.toString());
//       print(data);
//     }
//   } catch (e) {
//     print(e.toString());
//   }
// }








//   Future<void> _selectDate(
//       BuildContext context, TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != DateTime.now()) {
//       final formattedDate =
//           "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//       controller.text = formattedDate;
//     }
//   }



//   @override
//   void initState() {
//     super.initState();
//     _collegeController = TextEditingController(text: widget.instituteName);
//     _degreeController = TextEditingController(text: widget.degree);
//       _status = widget.eduStatus;
//        _statusNotifier = ValueNotifier<String>(_status);
//     print('Initialized with status: $_status');
//     fetchCollegeList();
//     if (widget.eduType == 'P') {
//       fetchDegreeList(type: 'P');
//     } else if (widget.eduType == 'G') {
//       fetchDegreeList(type: 'G');
//     } else {
//       fetchDegreeList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      appBar: AppBar(
//         // automaticallyImplyLeading: false,

//         leadingWidth: 25.0,
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         title: GestureDetector(
//           onTap: () async {
//             // Get.offAll(() =>
//             //     const AuthPage()); // Use a callback to instantiate AuthScreen
//           },
//           child: Image.asset(
//             'lib/icons/logo.png',
//             height: 120.0,
//             width: 180.0,
//           ),
//         ),

       
//       ),
//        backgroundColor: const Color.fromARGB(255, 241, 245, 249),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                  const SizedBox(height: 30,),
//                 Row(
//                   children: [
//                     const Text(
//                       'Type',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 21,
//                           color: Colors.black87),
//                     ),
//                     const SizedBox(
//                       width: 30,
//                     ),
//                     Text(
//                       widget.eduType,
//                       style:
//                           const TextStyle(fontSize: 19, color: Colors.black),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
          
//                 Row(
//       children: [
//         const Text(
//           'Status',
//           style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 21,
//               color: Colors.black87),
//         ),
//         const SizedBox(width: 30),
//         Row(
//           children: [
//             Radio(
//               value: 'Pursuing',
//               groupValue: _status,
//               onChanged: (String? value) {
//                 setState(() {
//                   _status = value!;
//                 });
//               },
//             ),
//             const Text(
//               'Pursuing',
//               style: TextStyle(fontSize: 19, color: Colors.black),
//             ),
//             const SizedBox(width: 8.0),
//             Radio(
//               value: 'Completed',
//               groupValue: _status,
//               onChanged: (String? value) {
//                 setState(() {
//                   _status = value!;
//                 });
//               },
//             ),
//             const Text(
//               'Completed',
//               style: TextStyle(fontSize: 19, color: Colors.black),
//             ),
//           ],
//         ),
//       ],
//     ),
//                 const SizedBox(height: 16.0),

                
//                  const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Text(
//                           'College Name',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 21,
//                               color: Colors.black87),
//                         ),
//                    ],
//                  ),
//                  const SizedBox(height: 20,),
//                 Wrap(
//                   spacing: 8.0,
//                   runSpacing:
//                       -8.0, // This will make chips flow to the next line when needed
//                   children: [
//                     // InputChip(
//                     //   label: Text(selectedCollege ?? widget.instituteName),
//                     //   onDeleted: () {
//                     //     setState(() {
//                     //       selectedCollege =widget.instituteName;
//                     //     });
//                     //   },
//                     // ),
//                     EditInputTextFieldWidget(
//                         textEditingController: _collegeController,
//                         hintText: 'Search College Name',
//                         icon: Icons.school),
//                     Container(
//                       decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey), // Border color
//                   borderRadius: BorderRadius.circular(7), // Border radius to match text field
//                 ),
//                       child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           DropdownButtonHideUnderline(
//                             child: DropdownButton2<String>(
//                               isExpanded: true,
//                               hint: const Text(
//                                 'Search for a college',
//                                 style: TextStyle(fontSize: 14, color: Colors.black),
//                               ),
//                               items: clgItems
//                                   .map((item) => DropdownMenuItem(
//                                         value: item['value'],
//                                         child: Text(item['label']!),
//                                       ))
//                                   .toList(),
//                               onChanged: (value) {
//                           setState(() {
//                             selectedCollege = value;
//                             _collegeController.text = value ?? widget.instituteName;
//                           });
//                     },
                              
//                               buttonStyleData: const ButtonStyleData(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 height: 58,
//                                 width: double.infinity,
//                               ),
//                               dropdownStyleData: const DropdownStyleData(
//                                 maxHeight: 200,
//                               ),
//                               menuItemStyleData: const MenuItemStyleData(
//                                 height: 50,
//                               ),
//                               dropdownSearchData: DropdownSearchData(
//                                 searchController: textEditingController,
//                                 searchInnerWidgetHeight: 50,
//                                 searchInnerWidget: Container(
//                                   height: 60,
//                                   padding: const EdgeInsets.only(
//                                     top: 8,
//                                     bottom: 4,
//                                     right: 8,
//                                     left: 8,
//                                   ),
                                  
//                                   child: TextFormField(
//                                     expands: true,
//                                     maxLines: null,
//                                     controller: textEditingController,
//                                     decoration: InputDecoration(
//                                       isDense: true,
//                                       contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 8,
//                                       ),
//                                       hintText: 'Search for a college',
//                                       hintStyle: const TextStyle(fontSize: 16),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(7),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 searchMatchFn: (item, searchValue) {
//                                   return item.value!
//                                       .toLowerCase()
//                                       .toString()
//                                       .contains(searchValue.toLowerCase());
//                                 },
//                               ),
//                               onMenuStateChange: (isOpen) {
//                                 if (!isOpen) {
//                                   textEditingController.clear();
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 20,),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                               'Degree',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 21,
//                                   color: Colors.black87),
//                             ),
//                   ],
//                 ),
                   
          
          
//           const SizedBox(height: 20,),
          
          
               
//                  Wrap(
//                   spacing: 8.0,
//                   runSpacing:
//                       -8.0, // This will make chips flow to the next line when needed
//                   children: [
//                     // InputChip(
//                     //   label: Text(selectedCollege ?? widget.instituteName),
//                     //   onDeleted: () {
//                     //     setState(() {
//                     //       selectedCollege =widget.instituteName;
//                     //     });
//                     //   },
//                     // ),
//                     EditInputTextFieldWidget(
//                         textEditingController: _degreeController,
//                         hintText: 'Search Degree',
//                         icon: Icons.school),
//                     Container(
//                       decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey), // Border color
//                   borderRadius: BorderRadius.circular(7), // Border radius to match text field
//                 ),
//                       child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                          DropdownButtonHideUnderline(
//             child: DropdownButton2<String>(
//               isExpanded: true,
//               hint: const Text(
//                 'Search for Degree',
//                 style: TextStyle(fontSize: 14, color: Colors.black),
//               ),
//              items: items
//                               .map((item) => DropdownMenuItem(
//                                     value: item['value'],
//                                     child: Text(
//                                       item['label']!,
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
//                                   ))
//                               .toList(),
          
//              onChanged: (value) {
//   setState(() {
//     selectedCollege = value;
//     _degreeController.text = value ?? widget.degree;

//     // Fetch specialization list based on the selected degree
//     fetchSpecializationList(value!);
//   });
// },

//               buttonStyleData: const ButtonStyleData(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 height: 58,
//                 width: double.infinity,
//               ),
//               dropdownStyleData: const DropdownStyleData(
//                 maxHeight: 200,
//               ),
//               menuItemStyleData: const MenuItemStyleData(
//                 height: 50,
//               ),
//               dropdownSearchData: DropdownSearchData(
//                 searchController: textEditingController,
//                 searchInnerWidgetHeight: 50,
//                 searchInnerWidget: Container(
//                   height: 60,
//                   padding: const EdgeInsets.only(
//             top: 8,
//             bottom: 4,
//             right: 8,
//             left: 8,
//                   ),
//                   child: TextFormField(
//             expands: true,
//             maxLines: null,
//             controller: textEditingController,
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 10,
//                 vertical: 8,
//               ),
//               hintText: 'Search for a Degree',
//               hintStyle: const TextStyle(fontSize: 16),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(7),
//               ),
//             ),
//                   ),
//                 ),
//                 searchMatchFn: (item, searchValue) {
//             return item.toString().toLowerCase().contains(searchValue.toLowerCase());
//           },
          
//               ),
//               onMenuStateChange: (isOpen) {
//                 if (!isOpen) {
//                   textEditingController.clear();
//                 }
//               },
//             ),
//           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
          
          
          
          
          
          
          
          
          
//           const SizedBox(height: 20,),
//               const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                               'Stream/Specialization',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 21,
//                                   color: Colors.black87),
//                             ),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 EditInputTextFieldWidget(
//   textEditingController: _specializationController,
//   hintText: 'Search Specialization',
//   icon: Icons.school, // Adjust the icon as needed
// ),
// Container(
//   decoration: BoxDecoration(
//     border: Border.all(color: Colors.grey),
//     borderRadius: BorderRadius.circular(7),
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       DropdownButtonHideUnderline(
//   child: DropdownButton2<String>(
//     isExpanded: true,
//     hint: const Text(
//       'Search for Specialization',
//       style: TextStyle(fontSize: 14, color: Colors.black),
//     ),
//     items: specializationItems
//         .map((item) => DropdownMenuItem(
//               value: item['value'],
//               child: Text(
//                 item['label']!,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ))
//         .toList(),
//     onChanged: (value) {
//       setState(() {
//         selectedSpecialization = value;
//         _specializationController.text = value ?? widget.specialization;
//       });
//     },
          
//           buttonStyleData: const ButtonStyleData(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             height: 58,
//             width: double.infinity,
//           ),
//           dropdownStyleData: const DropdownStyleData(
//             maxHeight: 200,
//           ),
//           menuItemStyleData: const MenuItemStyleData(
//             height: 50,
//           ),
//           dropdownSearchData: DropdownSearchData(
//             searchController: textEditingController,
//             searchInnerWidgetHeight: 50,
//             searchInnerWidget: Container(
//               height: 60,
//               padding: const EdgeInsets.only(
//                 top: 8,
//                 bottom: 4,
//                 right: 8,
//                 left: 8,
//               ),
//               child: TextFormField(
//                 expands: true,
//                 maxLines: null,
//                 controller: textEditingController,
//                 decoration: InputDecoration(
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 8,
//                   ),
//                   hintText: 'Search for a Specialization',
//                   hintStyle: const TextStyle(fontSize: 16),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                 ),
//               ),
//             ),
//             searchMatchFn: (item, searchValue) {
//               return item.toString().toLowerCase().contains(searchValue.toLowerCase());
//             },
//           ),
//           onMenuStateChange: (isOpen) {
//             if (!isOpen) {
//               textEditingController.clear();
//             }
//           },
//         ),
//       ),
//     ],
//   ),
// ),
//                      const SizedBox(height: 20,),
//                      const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                               'Start Date',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 21,
//                                   color: Colors.black87),
//                             ),
//                   ],
//                 ),
//                     TextFormField(
//                     controller: _intStartDateController,
//                     decoration: InputDecoration(
//                       labelText: null,
//                       suffixIcon: IconButton(
//                         onPressed: () =>
//                             _selectDate(context, _intStartDateController),
//                         icon: const Icon(Icons.calendar_today),
//                       ),
//                     ),
//                     validator: (value) {
//                       if ((value ?? '').isEmpty) {
//                         return 'Please enter start date';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10,),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle logic for the Save button
//                       },
//                       child: const Text('Save'),
//                     ),
//                     const SizedBox(width: 8.0),
//                     OutlinedButton(
//                       onPressed: () {},
//                       child: const Text('Close'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
