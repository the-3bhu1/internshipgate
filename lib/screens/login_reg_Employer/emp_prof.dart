
//trial code 1

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internshipgate/buttons/edit_button.dart';
import 'package:internshipgate/widgets/input_field.dart';
import '../../utils/api_endpoints.dart';

class EmployeeProfile extends StatelessWidget {
  final int id;
  final String email, name, emptoken;
   const EmployeeProfile({
    Key? key,
    required this.id,
    required this.email,
    required this.name,
    required this.emptoken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      body: EmployeeProfileContent(
        id: id,
        email: email,
      ),
    );
  }
}

class EmployeeProfileContent extends StatefulWidget {
  final int id;
  final String email;
  const EmployeeProfileContent({
    Key? key,
    required this.id,
    required this.email,
  }) : super(key: key);

  @override
  State<EmployeeProfileContent> createState() => _EmployeeProfileContentState();
}

class _EmployeeProfileContentState extends State<EmployeeProfileContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isEditing = false;

  String _savedLocation = " ";
  String _savedOrgName = " ";
  String _savedWebsite = " ";
  String _savedDescription = " ";
  String _pic = "";
   File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchEmployeeProfile(widget.id.toString());
  }

  Future<void> fetchEmployeeProfile(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiEndPoints.baseUrl}getEmployerProfileById/$id',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        //print('Following is employer profile data');
        //print(data);

        if (data.isNotEmpty) {
          String name = data['name'] ?? "N/A";
          String email = data['email'] ?? "N/A";
          String mobile = data['mobileno'] ?? "N/A";
          String location = data['address'] ?? "N/A";
          String pic = data['org_logo'];
          String orgName = data['org_name'] ?? "N/A";
          String website = data['website'] ?? "N/A";
          String description = data['org_description'] ?? "N/A";

          setState(() {
            _nameController.text = name;
            _emailController.text = email;
            _mobileController.text = mobile;
            _locationController.text = location;
            _orgNameController.text = orgName;
            _websiteController.text = website;
            _descriptionController.text = description;
            _pic = pic;
            _savedLocation = " $location";
            _savedOrgName = " $orgName";
            _savedWebsite = " $website";
            _savedDescription = " $description";
          });
        } else {
          print("Empty response or unexpected data format");
        }
      } else {
        print("Failed to fetch student profile: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching student profile: $error");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    _orgNameController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundColor: Colors.white,
                    //   child: ClipOval(
                    //     child: GestureDetector(
                    //       onTap: _isEditing ? _pickImage : null,
                    //       child: Image.network(
                    //         'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/$_pic',
                    //         width: 100,
                    //         height: 100,
                    //         fit: BoxFit.cover,
                    //         errorBuilder: (context, error, stackTrace) {
                    //           return const Icon(Icons.work);
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: width * 0.12,
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
                                      'https://internshipgates3.s3.ap-south-1.amazonaws.com/imgupload/$_pic',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => const Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundColor:
                                                Color.fromRGBO(44, 56, 149, 1),
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
                              radius: width * 0.04,
                              backgroundColor: Colors.grey.withOpacity(0.6),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: width * 0.03),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ElevatedButton(
                          //     onPressed: _uploadProfilePicture,
                          //     child: Text('Upload Image'),
                          //   ),
                          // ElevatedButton(
                          //   onPressed: _updateProfilePicture,
                          //   child: Text('Update Image'),
                          // ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            _orgNameController.text,
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: width * 0.01,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blueGrey[700],
                                size: width * 0.06,
                              ),
                              SizedBox(width: width * 0.01,),
                              Expanded(
                                child: Text(
                                  _locationController.text,
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Row(
                          //     children: [
                          //       IconButton(
                          //         icon: const Icon(Iconsax.edit_25),
                          //         onPressed: () {
                          //           setState(() {
                          //             _isEditing = true;
                          //           });
                          //         },
                          //       ),
                          //      const Text("Edit Profile", style: TextStyle(fontSize: 18),),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
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
                  emailController: _emailController,
                  mobileController: _mobileController,
                  locationController: _locationController,
                  orgNameController: _orgNameController,
                  websiteController: _websiteController,
                  descriptionController: _descriptionController,
                  formKey: _formKey,
                ),
              if (!_isEditing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Organization Details:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05,
                                color: Colors.black87),
                          ),
                        ),
                        if (!_isEditing)
                          Align(
                            alignment: Alignment.topRight,
                            child: EditButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              title: 'Edit Profile',
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Wrap(
                      children: [
                        buildDetailRow("Name:", _nameController.text),
                        buildDetailRow("Email:", _emailController.text),
                        buildDetailRow("Phone number:", _mobileController.text),
                        buildDetailRow("Location:", _savedLocation),
                        buildDetailRow("Organisation Name:", _savedOrgName),
                        buildDetailRow("Website:", _savedWebsite),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5),
                          child: Text(
                            "Description:",
                            style: TextStyle(
                                fontSize: width * 0.04, fontWeight: FontWeight.w500),
                          ),
                        ),
                        buildDetailRow("", _savedDescription),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              if (_isEditing)
                Row(
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isEditing = false;
                          });

                          _savedLocation = "Location: ${_locationController.text}";
                          _savedOrgName = "Organisation Name: ${_orgNameController.text}";
                          _savedWebsite = "Website: ${_websiteController.text}";
                          _savedDescription =
                              "Description: ${_descriptionController.text}";

                          // Call your API to update the employer details here
                          updateEmployerDetails();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    var width  = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: width * 0.04,
                color: Colors.blueGrey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _profilePic = '';

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

  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null) return;

    final Uri uploadUri =
        Uri.parse('${ApiEndPoints.baseUrl}uploadEmployerLogo');

    var headers = {
      'Cookie': 'laravel_session=ZJg8H4VUok2k1rnOJpzW2X51qjzCcyK3eyVDrPfs',
    };

    final request = http.MultipartRequest('POST', uploadUri)
      ..fields.addAll({
        'employer_id': widget.id.toString(),
      })
      ..files.add(
        await http.MultipartFile.fromPath(
          'org_logo',
          _imageFile!.path,
        ),
      )
      ..headers.addAll(headers);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 201) {
        // Use regular expression to extract JSON part
        final jsonMatch = RegExp(r'\{.*\}').firstMatch(responseBody);

        if (jsonMatch != null) {
          final jsonPart = jsonMatch.group(0)!;

          try {
            final data = jsonDecode(jsonPart);
            setState(() {
              _profilePic = data['message'];
              print("Check profile pic upload");
              print(_profilePic);
            });
            // Additional logic if needed for successful upload
            Get.snackbar(
              'Success',
              'Organization logo updated successfully!',
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

  void updateEmployerDetails() async {
    final response = await http.post(
      Uri.parse(
        '${ApiEndPoints.baseUrl}updateEmployerDetail',
      ),
      body: {
        'id': widget.id.toString(),
        'name': _nameController.text,
        'email': widget.email,
        'mobileno': _mobileController.text,
        'address': _locationController.text,
        'org_name': _orgNameController.text,
        'org_logo': _pic,
        'org_description': _descriptionController.text,
        'website': _websiteController.text,
      },
    );

    if (response.statusCode == 200) {
      // Successful update, handle as needed
      print('Employer details updated successfully');
    } else {
      // Handle errors or display a message to the user
      print('Failed to update employer details: ${response.reasonPhrase}');
    }
  }
}

class StudentProfileEditWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController locationController;
  final TextEditingController orgNameController;
  final TextEditingController websiteController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;

  const StudentProfileEditWidget({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.locationController,
    required this.orgNameController,
    required this.websiteController,
    required this.descriptionController,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Profile",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            const Text(
              "Personal Details",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            Text(
              "Edit your organization details, address and website etc...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[700],
              ),
            ),
            const SizedBox(height: 20),
            InputTextFieldWidget(
              nameController,
              'Enter Full Name',
              Icons.person,
            ),
            const SizedBox(height: 20),
            InputTextFieldWidget(
              emailController,
              'Enter Email Account',
              Icons.mail_outlined,
            ),
            const SizedBox(height: 20),
            InputTextFieldWidget(
              mobileController,
              'Enter Mobile No.',
              Icons.phone,
            ),
            const SizedBox(height: 20),
            const Text(
              "Organization Details:",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Organization name:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            InputTextFieldWidget(
              orgNameController,
              'e.g. internshipgate',
              Icons.business,
            ),
            const SizedBox(height: 20),
            const Text(
              "Organization Descriptions:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            Column(
              children: [
                const SizedBox(
                    height: 10), // Add some space between label and input box
                Container(
                  height: 100, // Adjust the height according to your preference
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          TextFormField(
                            controller: descriptionController,
                            maxLines:
                                null, // Allows the TextField to have unlimited lines
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              hintText: 'Write Description',
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
            const SizedBox(height: 20),
            const Text(
              "Address:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            InputTextFieldWidget(
              locationController,
              'e.g. HSR Layout, Bangalore',
              Icons.location_on,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const Text(
              "Website:",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            InputTextFieldWidget(
              websiteController,
              'e.g. http://internshipgate.com/',
              Icons.link,
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
