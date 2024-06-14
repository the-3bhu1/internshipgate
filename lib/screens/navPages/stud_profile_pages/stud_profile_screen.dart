import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internshipgate/buttons/add_education_button.dart';
import 'package:internshipgate/buttons/edit_button.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/add_educationdetails.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/add_internshipdetails.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/add_project.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/add_trainingdetails.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/edit_education.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/edit_internship.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/edit_project.dart';
import 'package:internshipgate/screens/navPages/stud_profile_pages/edit_training.dart';
import 'package:internshipgate/widgets/input_field.dart';
import '../../../utils/api_endpoints.dart';

class StudentProfilePage extends StatelessWidget {
  final int studentId, applicantId;
  final String emai, fullname, emptoken;
  final VoidCallback refreshCallback;

  const StudentProfilePage({super.key,
    required this.studentId,
    required this.emai,
    required this.fullname,
    required this.emptoken,
    required this.applicantId,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      body: StudentProfilePageContent(
        studentId: studentId,
        applicantId: applicantId,
        emai: emai,
        fullname: fullname,
        emptoken: emptoken,
        refreshCallback: refreshCallback,
      ),
    );
  }
}

class StudentProfilePageContent extends StatefulWidget {
  final studentId, applicantId, emai;
  var fullname;
  var emptoken;
  final VoidCallback refreshCallback;
  StudentProfilePageContent({super.key,
    required this.studentId,
    required this.applicantId,
    required this.emai,
    required this.fullname,
    required this.emptoken,
    required this.refreshCallback,
  });

  @override
  State<StudentProfilePageContent> createState() =>
      _StudentProfilePageContentState();
}

class _StudentProfilePageContentState extends State<StudentProfilePageContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();

  bool _isEditing = false;
  bool _isEditingSkills = false;
  // List<Map<String, dynamic>> educations = [];
  String _savedLocation = "";
  String _savedAddress = "";
  String _savedExperience = "";
  String selectedScale = "";
  String selectedCity = '';
  final List<dynamic> _savedSkills = [];
  // dynamic _pic;
  final List<dynamic> _educationDetails = [];
  final List<dynamic> _internshipDetails = [];
  List<dynamic> _projectDetails = [];
  final List<dynamic> _trainingDetails = [];
  File? _imageFile;
  String _pic = '';

  List<Map<String, String>> skills = [];
  // List<InternshipDetails> _internships = [];
  List<String> selectedSkills = [];
  String title = "";

  List<String> uniqueSelectedSkills = [];
  // File? _imageFile;
  String _profilePic = '';
  bool complete_profile = false;
  bool edu = false;
  bool sku = false;
  bool locu = false;
  bool adu = false;

//   // Define a function to update project details
// void updateProjectDetails(Map<String, dynamic> updatedProject) {
//     setState(() {
//       int index = _projectDetails
//           .indexWhere((project) => project['id'] == updatedProject['id']);
//       if (index != -1) {
//         _projectDetails[index] = updatedProject;
//       }
//     });
//   }

  @override
  void initState() {
    super.initState();
    fetchStudentProfile(widget.applicantId.toString());
    fetchEducation(widget.applicantId.toString());
    fetchInternship(widget.applicantId.toString());
    fetchProjects(widget.applicantId.toString());
    fetchTraining(widget.applicantId.toString());
    fetchSkill(widget.applicantId.toString());
    skill();
  }

  void refreshData() {
    print('refreshed');
    fetchStudentProfile(widget.applicantId.toString());
    fetchEducation(widget.applicantId.toString());
    fetchInternship(widget.applicantId.toString());
    fetchProjects(widget.applicantId.toString());
    fetchTraining(widget.applicantId.toString());
    fetchSkill(widget.applicantId.toString());
    // fetchInternships();
    skill();
    widget.refreshCallback.call();
  }

//  checkPermissions() async {
//   // Check and request the necessary permissions

//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.camera,
//     Permission.storage,
//   ].request();

//   print("Asked for permission");

//   if (statuses[Permission.camera] != PermissionStatus.granted ||
//       statuses[Permission.storage] != PermissionStatus.granted) {
//     // Permissions were not granted, handle the error
//     return;
//   }

//   _pickImage();
// }

  void updateProjectDetails(Map<String, dynamic> updatedProject) {
    setState(() {
      // Update the project details in the state
      _projectDetails = _projectDetails.map((project) {
        if (project['id'] == updatedProject['id']) {
          return updatedProject;
        } else {
          return project;
        }
      }).toList();
    });
  }

  //  Future<void> _uploadImage() async {

  //    // Replace 'YOUR_API_ENDPOINT' with your Laravel API endpoint for image upload
  //    final apiUrl = Uri.parse('https://staging-dev.internshipgate.com/public/api/uploadApplicantProfilePicture');

  //    // Create a multipart request for image upload
  //    var request = http.MultipartRequest('POST', apiUrl);

  //    // Attach the image file to the request
  //    request.files.add(
  //      await http.MultipartFile.fromPath('image', _imageFile!.path),
  //    );

  //    // Send the request and get the response
  //    var response = await request.send();

  //    // Check the response status
  //    if (response.statusCode == 200) {
  //      // Image uploaded successfully
  //      print('Image uploaded successfully');
  //    } else {
  //      // Handle error
  //      print('Error uploading image: ${response.reasonPhrase}');
  //    }
  //  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));
      if (croppedFile != null) {
        setState(() {
          _imageFile = croppedFile;
        });
        await _uploadProfilePicture();
      }
    }
  }

  Future<File?> _cropImage(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        ]
    );
    return croppedFile?.path != null ? File(croppedFile!.path) : null;
  }

  // Future<void> _uploadProfilePicture() async {
  //   if (_imageFile == null) return;

  //   final Uri uploadUri = Uri.parse(
  //       'https://staging-dev.internshipgate.com/public/api/uploadApplicantProfilePicture');

  //   var headers = {
  //     'Cookie': 'laravel_session=tOnpvwISht7BSx4QKS7riQ0v3a2lfEUGofKuAmCw',
  //   };

  //   final request = http.MultipartRequest('POST', uploadUri)
  //     ..files.add(
  //       await http.MultipartFile.fromPath(
  //         'pic',
  //         _imageFile!.path,
  //         filename: _imageFile!.path.split('/').last,
  //       ),
  //     )
  //     ..headers.addAll(headers);

  //   try {
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();

  //     print('Response Status Code: ${response.statusCode}');
  //     print('Response Body: $responseBody');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Check if the response body is a valid JSON object
  //       try {
  //         final data = jsonDecode(responseBody);
  //         setState(() {
  //           _profilePic = data['message'];
  //           print("Check profile pic upload");
  //           print(_profilePic);
  //         });
  //         // Additional logic if needed for successful upload
  //       } catch (e) {
  //         print('Error parsing JSON: $e');
  //       }
  //     } else {
  //       print('Failed to upload image: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //   }
  // }

  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null) return;

    final Uri uploadUri = Uri.parse(
        '${ApiEndPoints.baseUrl}uploadApplicantProfilePicture');

    var headers = {
      'Cookie': 'laravel_session=tOnpvwISht7BSx4QKS7riQ0v3a2lfEUGofKuAmCw',
    };

    final request = http.MultipartRequest('POST', uploadUri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'pic',
          _imageFile!.path,
          filename: _imageFile!.path.split('/').last,
        ),
      )
      ..headers.addAll(headers);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      //print('Response Status Code: ${response.statusCode}');
      //print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Use regular expression to extract JSON part
        final jsonMatch = RegExp(r'\{.*\}').firstMatch(responseBody);

        if (jsonMatch != null) {
          final jsonPart = jsonMatch.group(0)!;

          try {
            final data = jsonDecode(jsonPart);
            setState(() {
              _profilePic = data['message'];
              //print("Check profile pic upload");
              //print(_profilePic);
            });
            await _updateProfilePicture();
            // Additional logic if needed for successful upload
            widget.refreshCallback.call();
            Get.snackbar(
              'Success',
              'Profile picture updated successfully!',
              snackPosition: SnackPosition.BOTTOM,
            );
          } catch (e) {
            print('Error parsing JSON: $e');
          }
        } else {
          print('No valid JSON found in the response.');
        }
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  Future<void> _updateProfilePicture() async {
    final Uri updateUri = Uri.parse(
        '${ApiEndPoints.baseUrl}updateApplicantPictureById');
    final response = await http.post(
      updateUri,
      body: jsonEncode({
        'pic': _profilePic,
        'applicantId': widget.applicantId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Profile picture updated successfully');
    } else {
      // Handle failure
      print('Failed to update profile picture: ${response.reasonPhrase}');
    }
  }

  /*Widget _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (_uploading) return;

        setState(() {
          _uploading = true;
        });

        await _uploadProfilePicture();

        setState(() {
          _uploading = false;
        });
      },
      icon: _uploading
          ? const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : const Icon(Icons.upload),
      label: const Text('Upload'),
    );
  }*/

  void onSelectedScaleChanged(String newScaleValue, String newCityValue) {
    setState(() {
      selectedScale = newScaleValue;
      selectedCity = newCityValue;
    });
  }

  Future<void> fetchStudentProfile(String applicantId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.isNotEmpty) {
          final Map<String, dynamic> basicDetail =
              data['applicant_basic_detail'] ?? {};
          final Map<String, dynamic> mobileno =
              data['applicant_mobileno'] ?? {};

          setState(() {
            selectedScale = basicDetail['title'] ?? "";
            _nameController.text = basicDetail['name'] ?? "";
            _mobileController.text = mobileno['mobileno'] ?? "";
            selectedCity = basicDetail['location'] ?? "";
            _addressController.text = basicDetail['address'] ?? "";
            _experienceController.text = basicDetail['exp_year'] ?? "";
            _expMonthController.text = basicDetail['exp_month'] ?? "";
            _emailController.text = basicDetail['email'] ?? "";
            _pic = basicDetail['pic'] ?? "";

            _savedLocation = basicDetail['location'] ?? ' ';
            if (basicDetail['location'] == null) {
              locu = true;
            } else {
              locu = false;
            }
            _savedAddress = basicDetail['address'] ?? ' ';
            if (basicDetail['address'] == null) {
              adu = true;
            } else {
              adu = false;
            }
            _savedExperience = " ${basicDetail['exp_year'] ?? 0} Year "
                "${basicDetail['exp_month'] ?? 0} Months";
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student student profile: $error");
    }
  }

  Future<void> fetchProjects(String applicantId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
          final dynamic applicantProjects = data['applicant_project'];
        if (data.isNotEmpty) {
          if (applicantProjects is List<dynamic>) {
            final List<dynamic> projectList = applicantProjects;

            setState(() {
              for (var project in projectList) {
                if (project['applicant_basic_detail_id'] != null) {
                  break;
                }
              }
              //print(projectList);
              _projectDetails.clear();
              _projectDetails.addAll(projectList);
              //print("Check projectlist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              //print(_projectDetails);
            });
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student projects: $error");
    }
  }

  Future<void> fetchInternship(String applicantId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
          final dynamic applicantInternship = data['applicant_intership'];
        if (data.isNotEmpty) {
          if(applicantInternship is List<dynamic>) {
            final List<dynamic> internshipList = applicantInternship;

            setState(() {
              for (var internship in internshipList) {
                if (internship['applicant_basic_detail_id'] != null) {
                  break;
                }
              }

              _internshipDetails.clear();
              _internshipDetails.addAll(internshipList);
              //print("Check internshiplist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              //print(_internshipDetails);
            });
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student internship: $error");
    }
  }

  Future<void> fetchTraining(String applicantId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final dynamic applicantTraining = data['applicant_training'];
          if (applicantTraining is List<dynamic>) {
            final List<dynamic> trainingList = applicantTraining;

            setState(() {
              _trainingDetails.clear();
              _trainingDetails.addAll(trainingList);
              //print("Check traininglist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              //print(_trainingDetails);
            });
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student training: $error");
    }
  }

  Future<void> fetchEducation(String applicantId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final dynamic applicantEducation = data['applicant_education'];
          if (applicantEducation is List<dynamic>) {
            final List<dynamic> educationList = applicantEducation;
            setState(() {
              for (var education in educationList) {
                if (education['applicant_basic_detail_id'] != null) {
                  break;
                }
              }
              _educationDetails.clear();
              _educationDetails.addAll(educationList);
              //print("Check educationlist hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
              //print("education: $_educationDetails");
            });
            edu = false;
          } else {
            edu = true;
            //print('education: ${edu.toString()}');
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student education: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student education: $error");
    }
  }

  Future<void> fetchSkill(String applicantId) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiEndPoints.baseUrl}getApplicantProfileById/$applicantId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        if (data.isNotEmpty) {
          final dynamic applicantSkill = data['applicant_software_skill'];
          if (applicantSkill is List<dynamic>) {
            final List<String> skillList = (applicantSkill
            as List<dynamic>?)
                ?.map((entry) => (entry['software_skill'] as String?) ?? '')
                .toList() ??
                [];

            final List<String> individualSkills = skillList.map((skill) {
              if (skill.isNotEmpty) {
                return skill.replaceAll('[', '').replaceAll(']', '').split(',');
              } else {
                return [];
              }
            }).expand((skill) => skill).cast<String>().toList();

            setState(() {
              _savedSkills.clear();
              _savedSkills.addAll(skillList);
              selectedSkills.clear();
              selectedSkills.addAll(individualSkills);
            });
            sku = skillList.isEmpty || skillList.any((element) => element.isEmpty);
            if (!sku) {
              sku = false;
            }
          } else {
            sku = true;
            print('skills: ${sku.toString()}');
          }
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student skillsssssss: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student skill: $error");
    }
  }

  Future<void> skill() async {
    try {
      final response = await get(
        Uri.parse(
            '${ApiEndPoints.baseUrl}getSoftwareSkill'),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        //print(data);
        setState(() {
          skills = data
              .map<Map<String, String>>((item1) => {
            'value': item1['value'].toString(),
            'label': item1['label'].toString(),
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

  Future<void> updateStudentProfile(String selectedScale, selectedCity) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}updateApplicantBasicDetail'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'applicantId': widget.applicantId,
          'title': selectedScale,
          'name': _nameController.text,
          'phoneNo': _mobileController.text,
          'email': _emailController.text,
          'location': selectedCity,
          'address': _addressController.text,
          'exp_year': _experienceController.text,
          'exp_month': _expMonthController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(selectedScale);
        print('Applicant details updated successfully');

        // Fetch and display the updated data
        await fetchStudentProfile(widget.applicantId.toString());
        widget.refreshCallback.call();
      } else {
        print('Failed to update applicant details: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating applicant profile details: $error');
    }
  }

  Future<void> updateSkills() async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiEndPoints.baseUrl}updateApplicantSoftwareSkill'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'applicantId': widget.applicantId,
          'software_skill': selectedSkills.join(','), // Assuming selectedSkills is a List<String>
          'email': _emailController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Applicant skills updated successfully');
        // Fetch and display the updated data
        // await fetchStudentProfile(widget.applicantId.toString());
        await fetchSkill(widget.applicantId.toString());
        widget.refreshCallback.call();
      } else {
        print('Failed to update applicant details: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating applicant skills: $error');
    }
  }

  Future<void> deleteEducation(int educationId) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
          title: const Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          content: const Text(
              'Are you sure you want to delete this Education detail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancelled
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed, proceed with deletion
    if (confirmDelete == true) {
      try {
        final response = await http.delete(
          Uri.parse(
              '${ApiEndPoints.baseUrl}deleteApplicantEducationById/$educationId'),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Show a Snackbar after successful deletion
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Education Details Deleted Successfully'),
          //   ),
          // );

          // // Fetch and display the updated data
          // await fetchStudentProfile(widget.applicantId.toString());
        } else {
          print('Success: ${response.reasonPhrase}');
          // await fetchStudentProfile(
          //     widget.applicantId.toString()); // User cancelled
          setState(() {
            _educationDetails
                .removeWhere((education) => education['id'] == educationId);
            widget.refreshCallback.call();
          });
          Get.snackbar(
            'Success',
            'Education deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (error) {
        print('Error deleting education details: $error');
      }
    }
  }

  Future<void> deleteProject(int ProjectId) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
          title: const Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          content: const Text(
              'Are you sure you want to delete this Project detail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed, proceed with deletion
    if (confirmDelete == true) {
      try {
        final response = await http.delete(
          Uri.parse(
              '${ApiEndPoints.baseUrl}deleteApplicantProjectById/$ProjectId'),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ("project delete check");
          // Show a Snackbar after successful deletion
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Project Details Deleted Successfully'),
          //   ),
          // );

          // Fetch and display the updated data
        } else {
          print('Success: ${response.reasonPhrase}');
          setState(() {
            _projectDetails
                .removeWhere((project) => project['id'] == ProjectId);
          }); // User cancelled
          Get.snackbar(
            'Success',
            'Project deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (error) {
        print('Error deleting project details: $error');
      }
    }
  }

  Future<void> deleteInternship(int internshipId) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
          title: const Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          content: const Text(
              'Are you sure you want to delete this Internship detail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed, proceed with deletion
    if (confirmDelete == true) {
      try {
        final response = await http.delete(
          Uri.parse(
              '${ApiEndPoints.baseUrl}deleteApplicantInternshipById/$internshipId'),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ("internship delete check");
          // Show a Snackbar after successful deletion
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Project Details Deleted Successfully'),
          //   ),
          // );

          // Fetch and display the updated data
        } else {
          print('Internship deleted ${response.reasonPhrase}');
          setState(() {
            _internshipDetails
                .removeWhere((internship) => internship['id'] == internshipId);
          });
          Get.snackbar(
            'Success',
            'Internship deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (error) {
        print('Error deleting internship details: $error');
      }
    }
  }

  Future<void> deleteTraining(int trainingId) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
          title: const Text(
            'Confirmation',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          content: const Text(
              'Are you sure you want to delete this Training detail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed, proceed with deletion
    if (confirmDelete == true) {
      try {
        final response = await http.delete(
          Uri.parse(
              '${ApiEndPoints.baseUrl}deleteApplicantTrainingById/$trainingId'),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ("training delete check");
          // Show a Snackbar after successful deletion
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Project Details Deleted Successfully'),
          //   ),
          // );

          // Fetch and display the updated data
        } else {
          print('success: ${response.reasonPhrase}');
          setState(() {
            _trainingDetails
                .removeWhere((training) => training['id'] == trainingId);
          }); // User cancelled
          Get.snackbar(
            'Success',
            'Training deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (error) {
        print('Error deleting training details: $error');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void editEducation(int educationId) {
    // Implement the logic to edit education details
  }
  void editInternship(int internshipId) {
    // Implement the logic to edit education details
  }

  void editProject(int educationId) {
    // Implement the logic to edit education details
  }

  void editTraining(int educationId) {
    // Implement the logic to edit education details
  }
  Future<void> _handleRefresh() async {
    // Fetch updated data for each section
    await fetchStudentProfile(widget.applicantId.toString());
    await fetchEducation(widget.applicantId.toString());
    await fetchInternship(widget.applicantId.toString());
    await fetchProjects(widget.applicantId.toString());
    await fetchTraining(widget.applicantId.toString());
    await fetchSkill(widget.applicantId.toString());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.015, vertical: height * 0.01),
                  child: Column(
                    children: [
                      Text('Fields marked with * are mandatory to apply for internships', style: TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.w600, color: Colors.blueGrey),),
                      SizedBox(height: height * 0.015,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                    child: _imageFile != null
                                        ? Image.file(
                                      _imageFile!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(
                                      'https://internshipgates3.s3.ap-south-1.amazonaws.com/stuprofilepicupload/$_pic',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                      const Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Color.fromRGBO(
                                                44, 56, 149, 1),
                                          ),
                                          Icon(
                                            Icons.person,
                                            size: 70,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.withOpacity(0.6),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ElevatedButton(
                                //   onPressed: _uploadProfilePicture,
                                //   child: Text('Upload Image'),
                                // ),
                                // ElevatedButton(
                                //   onPressed: _updateProfilePicture,
                                //   child: Text('Update Image'),
                                // ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedScale,
                                      style: TextStyle(
                                        fontSize: width * 0.06,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        _nameController.text,
                                        style: TextStyle(
                                          fontSize: width * 0.06,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _emailController.text,
                                  style: TextStyle(
                                    fontSize: width * 0.044,
                                  ),
                                ),
                                Text(
                                  _mobileController.text,
                                  style: TextStyle(
                                    fontSize: width * 0.044,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                if (_isEditing)
                  StudentProfileEditWidget(
                    nameController: _nameController,
                    mobileController: _mobileController,
                    addressController: _addressController,
                    selectedCities: selectedCity,
                    experienceController: _experienceController,
                    expMonthController: _expMonthController,
                    formKey: _formKey,
                    selectedScale: selectedScale,
                    onSelectedScaleChanged: onSelectedScaleChanged,
                  ),
                if (!_isEditing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              "*Location:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              selectedCity,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "*Address: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                _savedAddress,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Experience:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _savedExperience,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 5,),
                if (!_isEditing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EditButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                          title: 'Edit Profile'),
                      SizedBox(
                        width: width * 0.01,
                      ),
                    ],
                  ),
                if (title == "" && _savedLocation == ' ' && _savedAddress == ' ') ...[
                  SizedBox(height: height * 0.01,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text('Title, Address, Location Required!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: Colors.red.shade800),),
                  ),
                ] else if(_savedLocation == ' ' && _savedAddress == ' ') ...[
                  SizedBox(height: height * 0.01,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text('Address, Location Required!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04, color: Colors.red.shade800),),
                  ),
                ],
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await updateStudentProfile(selectedScale, selectedCity);
                              setState(() {
                                _isEditing = false;
                              });
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 10,
                  color: const Color.fromARGB(255, 241, 245, 249),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      "Basic Details"),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "*Education:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_educationDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "Education Details are mandatory...!!",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ),
                      if (_educationDetails.isNotEmpty)
                        for (var education in _educationDetails)
                          EducationWidget(
                            education: education,
                            onEdit: editEducation,
                            onDelete: deleteEducation,
                            email: widget.emai,
                            applicantId: widget.applicantId,
                            refreshCallback: refreshData,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AddEducationButton(
                              onPressed: () {
                                Get.to(() => AddEdu(
                                  applicantId: widget.applicantId,
                                  email:widget.emai,
                                  refreshCallback: refreshData,));
                              },
                              title: 'Add Education'),
                          SizedBox(
                            width: width * 0.01,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "*Key Skills:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        ..._savedSkills.join(',').split(',').map((skill) {
                          skill = skill
                              .trim(); // Remove leading and trailing whitespaces
                          skill = skill.replaceAll('[', '').replaceAll(']', '');

                          if (skill.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 0), // Decreased top padding
                              child: ListTile(
                                dense:
                                true, // Reduces the height of the ListTile
                                contentPadding: EdgeInsets.zero, // Remove default ListTile padding
                                leading: const Icon(
                                  Icons.fiber_manual_record,
                                  size: 14,
                                  color: Colors.black, // Set the color of the bullet point
                                ),
                                title: Text(
                                  skill,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container for empty sub-skills
                          }
                        }).toList(),
                        if (_isEditingSkills)
                          Column(
                            children: [
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
                                                //uniqueSelectedSkills.remove(skill);
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
                                          style: TextStyle(
                                              fontSize: width * 0.035,
                                              color: Colors.black),
                                        ),
                                        items: skills
                                            .where((skill) => !selectedSkills.contains(skill['value']))
                                            .map((item) => DropdownMenuItem(
                                          value: item['value'],
                                          child: Text(
                                            item['label']!,
                                            style: TextStyle(
                                                fontSize: width * 0.035, color: Colors.black),
                                          ),
                                        )).toList(),
                                        onChanged: (value) {
                                            /*if (!uniqueSelectedSkills
                                                .contains(value!)) {
                                              // Check if the skill is not already selected
                                              uniqueSelectedSkills.add(
                                                  value); // Add the skill to the unique list
                                              selectedSkills.add(
                                                  value); // Add the skill to the displayed list
                                            }*/
                                            if (!selectedSkills.contains(value)) {
                                              setState(() {
                                              selectedSkills.add(value!);
                                              });
                                            }
                                          },
                                        buttonStyleData: ButtonStyleData(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.02),
                                          width: double.infinity,
                                        ),
                                        dropdownStyleData:
                                        DropdownStyleData(
                                          maxHeight: height * 0.35,
                                        ),
                                        menuItemStyleData:
                                        MenuItemStyleData(
                                          height: height * 0.055,
                                        ),
                                        dropdownSearchData: DropdownSearchData(
                                          searchController:
                                          textEditingController,
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
                                                hintText: 'Search...',
                                                hintStyle: TextStyle(
                                                    fontSize: width * 0.037),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(7),
                                                ),
                                              ),
                                            ),
                                          ),
                                          searchMatchFn: (skill, searchValue) {
                                            return skill.value!
                                                .toLowerCase()
                                                .toString()
                                                .contains(
                                                searchValue.toLowerCase());
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditingSkills = false;
                                      });
                                    },
                                    child: const Text('Close'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Update the skills
                                      await updateSkills();

                                      // Fetch and display the updated data
                                      await fetchStudentProfile(
                                          widget.applicantId.toString());

                                      setState(() {
                                        _isEditingSkills = false;
                                      });
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (!_isEditingSkills)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AddEducationButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingSkills = true;
                                    });
                                  },
                                  title: 'Edit Skills'),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: const Color.fromARGB(255, 241, 245, 249),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        "Other Details"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Internship:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_internshipDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "No internship details.....",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      if (_internshipDetails.isNotEmpty)
                        for (var internship in _internshipDetails)
                          InternshipWidget(
                            internship: internship,
                            onEdit: editInternship,
                            onDelete: deleteInternship,
                            email: widget.emai,
                            applicantId: widget.applicantId,
                            refreshCallback: refreshData,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AddEducationButton(
                              onPressed: () {
                                Get.to(()=> InternshipForm(
                                  applicantId: widget.applicantId,
                                  emai: widget.emai,
                                  studentId: widget.studentId,
                                  refreshCallback: refreshData,
                                ));
                              },
                              title: 'Add Internship'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Project:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_projectDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "No project details.....",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      if (_projectDetails.isNotEmpty)
                        for (var project in _projectDetails)
                          ProjectWidget(
                            project: project,
                            onEdit: editProject,
                            onDelete: deleteProject,
                            email: widget.emai,
                            applicantId: widget.applicantId,
                            refreshCallback: refreshData,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AddEducationButton(
                              onPressed: () {
                                Get.to(()=> AddProjectDetailsPage(
                                  email: widget.emai,
                                  applicantId: widget.applicantId,
                                  refreshCallback: refreshData,
                                ));
                              },
                              title: 'Add Projects'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Training:",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_trainingDetails.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "No training details.....",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      if (_trainingDetails.isNotEmpty)
                        for (var training in _trainingDetails)
                          TrainingWidget(
                            training: training,
                            onEdit: editTraining,
                            onDelete: deleteTraining,
                            email: widget.emai,
                            applicantId: widget.applicantId,
                            refreshCallback: refreshData,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AddEducationButton(
                              onPressed: () {
                                Get.to(()=> TrainingForm(
                                  applicantId: widget.applicantId,
                                  email: widget.emai,
                                  refreshCallback: refreshData,
                                ));
                              },
                              title: 'Add Training'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EducationWidget extends StatelessWidget {
  final Map<String, dynamic> education;
  final Function(int) onEdit;
  final Function(int) onDelete;
  String email = '';
  int applicantId = 0;
  final VoidCallback refreshCallback;


  EducationWidget({super.key,
    required this.refreshCallback,
    required this.education,
    required this.onEdit,
    required this.onDelete,
    required this.email,
    required this.applicantId,
  });

  @override
  Widget build(BuildContext context) {
    String eduTypeText;
    switch (education['edu_type']) {
      case 'pgraduation':
        eduTypeText = 'Post Graduation';
        break;
      case 'graduation':
        eduTypeText = 'Graduation';
        break;
      case 'hsecondary':
        eduTypeText = 'Senior Secondary';
        break;
      case 'secondary':
        eduTypeText = 'Secondary';
        break;
      default:
        eduTypeText = education['edu_type'];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "$eduTypeText${education['edu_type'] == 'hsecondary' || education['edu_type'] == 'secondary' ? '' : ' - ${education['degree']}'}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      // Pass the education ID to the onEdit callback
                      // onEdit(education['id']);
                      Get.to(() => EditEducationDetailsPage(
                        educationId: education['id'],
                        eduType: education['edu_type'],
                        startDate: education['start_date'],
                        endDate: education['end_date'],
                        eduStatus: education['edu_status'],
                        eduBoard: education['edu_board'],
                        instituteName: education['institute_name'],
                        degree: education['degree'],
                        specialization: education['specialization'],
                        completionYear: education['completion_year'],
                        performanceScale: education['performance_scale'],
                        cgpa: education['cgpa'],
                        email: email,
                        applicantId: applicantId,
                        refreshCallback: refreshCallback,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      // Access the deleteEducation method through the parent class
                      _StudentProfilePageContentState state =
                      context.findAncestorStateOfType<
                          _StudentProfilePageContentState>()!;
                      state.deleteEducation(education['id']);
                    },
                  ),
                ],
              ),
            ],
          ),
          Text(
            "${education['institute_name']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            education['edu_status'].toLowerCase().contains('completed') &&
                (education['edu_type'] == 'hsecondary' ||
                    education['edu_type'] == 'secondary')
                ? 'Year of completion: ${education['end_date']}'
                : education['edu_status'].toLowerCase().contains('pursuing') &&
                (education['edu_type'] == 'hsecondary' ||
                    education['edu_type'] == 'secondary')
                ? 'Expected Year of completion: ${education['end_date']}'
                : 'From ${education['start_date']} to ${education['end_date'] ?? 'Present'}',
            style: const TextStyle(fontSize: 18),
          ),
          Visibility(
            visible: education['edu_type'] != 'secondary',
            child: Text(
              "Specialization: ${education['specialization']}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Text(
            "Performance: ${education['performance_scale']} - ${education['cgpa'] ??
                'N/A'}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class InternshipWidget extends StatelessWidget {
  final Map<String, dynamic> internship;
  final Function(int) onEdit;
  final Function(int) onDelete;
  String email = '';
  int applicantId = 0;
  final VoidCallback refreshCallback;

  InternshipWidget({super.key,
    required this.refreshCallback,
    required this.internship,
    required this.onEdit,
    required this.onDelete,
    required this.email,
    required this.applicantId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${internship['int_profile']} ",
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.edit_outlined, color: Colors.black87),
                    onPressed: () {
                      Get.to(()=> EditInternshipForm(
                        refreshCallback: refreshCallback,
                        internshipId: internship['id'],
                        int_profile: internship['int_profile'],
                        int_start_date: internship['int_start_date'],
                        int_end_date: internship['int_end_date'],
                        int_org_name: internship['int_org_name'],
                        int_location: internship['int_location'],
                        int_current_status: internship['int_current_status'],
                        int_description: internship['int_description'],
                        email: email,
                        applicantId: applicantId,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      // Access the deleteEducation method through the parent class
                      _StudentProfilePageContentState state =
                      context.findAncestorStateOfType<
                          _StudentProfilePageContentState>()!;
                      state.deleteInternship(internship['id']);
                    },
                  ),
                ],
              ),
            ],
          ),
          Text(
            "${internship['int_org_name']}, ${internship['int_location']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "From ${internship['int_start_date']} to ${internship['int_end_date'] ?? 'Present'}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${internship['int_description']}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ProjectWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  final Function(int) onEdit;
  final Function(int) onDelete;
  String email = '';
  int applicantId = 0;
  final VoidCallback refreshCallback;

  ProjectWidget({super.key,
    required this.refreshCallback,
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.email,
    required this.applicantId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "${project['prj_profile']} ",
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              IconButton(
                icon:
                const Icon(Icons.edit_outlined, color: Colors.black87),
                onPressed: () {
                  Get.to(()=> EditProjectDetailsPage(
                    projectId: project['id'],
                    prj_profile: project['prj_profile'],
                    prj_start_date: project['prj_start_date'],
                    prj_end_date: project['prj_end_date'],
                    prj_org_name: project['prj_org_name'],
                    prj_location: project['prj_location'],
                    prj_current_status: project['prj_current_status'],
                    prj_description: project['prj_description'],
                    email: email,
                    applicantId: applicantId,
                    refreshCallback: refreshCallback,
                  ));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {
                  // Access the deleteEducation method through the parent class
                  _StudentProfilePageContentState state =
                  context.findAncestorStateOfType<
                      _StudentProfilePageContentState>()!;
                  state.deleteProject(project['id']);
                },
              ),
            ],
          ),
          Text(
            "${project['prj_org_name']}, ${project['prj_location']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "From ${project['prj_start_date']} to ${project['prj_end_date'] ?? 'Present'}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${project['prj_description']}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TrainingWidget extends StatelessWidget {
  final Map<String, dynamic> training;
  final Function(int) onEdit;
  final Function(int) onDelete;
  String email = '';
  int applicantId = 0;
  final VoidCallback refreshCallback;

  TrainingWidget({super.key,
    required this.refreshCallback,
    required this.training,
    required this.onEdit,
    required this.onDelete,
    required this.email,
    required this.applicantId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${training['tra_profile']} ",
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              //  const SizedBox(width: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.edit_outlined, color: Colors.black87),
                    onPressed: () {
                      Get.to(EditTrainingForm(
                        trainingId: training['id'],
                        tra_profile: training['tra_profile'],
                        tra_start_date: training['tra_start_date'],
                        tra_end_date: training['tra_end_date'],
                        tra_org_name: training['tra_org_name'],
                        tra_location: training['tra_location'],
                        tra_current_status: training['tra_current_status'],
                        tra_description: training['tra_description'],
                        email: email,
                        applicantId: applicantId,
                        refreshCallback: refreshCallback,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      // Access the deleteEducation method through the parent class
                      _StudentProfilePageContentState state =
                      context.findAncestorStateOfType<
                          _StudentProfilePageContentState>()!;
                      state.deleteTraining(training['id']);
                    },
                  ),
                ],
              ),
            ],
          ),
          Text(
            "${training['tra_org_name']}, ${training['tra_location']}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "From ${training['tra_start_date']} to ${training['tra_end_date'] ?? 'Present'}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "${training['tra_description']}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class StudentProfileEditWidget extends StatefulWidget {
  final String selectedScale;
  final String selectedCities;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController addressController;
  final TextEditingController experienceController;
  final TextEditingController expMonthController;
  final GlobalKey<FormState> formKey;
  final Function(String, String) onSelectedScaleChanged;

  const StudentProfileEditWidget({
    Key? key,
    required this.selectedScale,
    required this.nameController,
    required this.mobileController,
    required this.addressController,
    required this.experienceController,
    required this.expMonthController,
    required this.formKey,
    required this.onSelectedScaleChanged,
    required this.selectedCities,
  }) : super(key: key);


  @override
  _StudentProfileEditWidgetState createState() => _StudentProfileEditWidgetState();
}

class _StudentProfileEditWidgetState extends State<StudentProfileEditWidget> {
  List<String> scaleList = [
    'Mr.',
    'Mrs.',
    'Miss',
    'Ms.',
  ];
  String? selectedScale;
  final TextEditingController textEditingController = TextEditingController();
  List<Map<String, String>> items = [];

  @override
  void initState() {
    super.initState();
    cities();
    selectedScale = (widget.selectedScale == '' ? null : widget.selectedScale);
    selectedCity = widget.selectedCities;
    // Ensure that selectedScale is valid
    /*if (!scaleList.contains(widget.selectedScale)) {
      // If not found, set it to the first item in scaleList
      widget.selectedScale = scaleList.first;
    }*/
  }

  late String selectedCity;

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
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('*', style: TextStyle(fontSize: width * 0.06, color: const Color.fromRGBO(79, 88, 153, 1)),),
                SizedBox(width: width * 0.01,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey, width: 1.35),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: selectedScale,
                        hint: Text('Select Title', style: TextStyle(fontSize: width * 0.035),),
                        //style: const TextStyle(color: Colors.black),
                        items: scaleList.map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: width * 0.035),),
                        )).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedScale = newValue;
                            //print(widget.selectedScale);
                            widget.onSelectedScaleChanged(selectedScale!, selectedCity);
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
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('*', style: TextStyle(fontSize: width * 0.06, color: const Color.fromRGBO(79, 88, 153, 1)),),
                SizedBox(width: width * 0.01,),
                Expanded(
                  child: InputTextFieldWidget(
                    widget.nameController,
                    'Name',
                    Icons.person,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('*', style: TextStyle(fontSize: width * 0.06, color: const Color.fromRGBO(79, 88, 153, 1)),),
                SizedBox(width: width * 0.01,),
                Expanded(
                  child: InputTextFieldWidget(
                    widget.mobileController,
                    'Mobile',
                    Icons.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('*', style: TextStyle(fontSize: width * 0.06, color: const Color.fromRGBO(79, 88, 153, 1)),),
                SizedBox(width: width * 0.01,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            value: selectedCity,
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
                                setState(() {
                                  selectedCity = value!;
                                  widget.onSelectedScaleChanged(selectedScale!, selectedCity);
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
                ),
              ],
            ),
            /*InputTextFieldWidget(
              widget.locationController,
              'Location',
              Icons.location_on,
            ),*/
            SizedBox(height: height * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('*', style: TextStyle(fontSize: width * 0.06, color: const Color.fromRGBO(79, 88, 153, 1)),),
                SizedBox(width: width * 0.01,),
                Expanded(
                  child: InputTextFieldWidget(
                    widget.addressController,
                    'Address',
                    Icons.home,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            InputTextFieldWidget(
              widget.experienceController,
              'Experience Year',
              Icons.work,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
            ),
            const SizedBox(height: 10),
            InputTextFieldWidget(
              widget.expMonthController,
              'Experience Month',
              Icons.work_history,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^(1[0-2]?|[1-9])$'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}