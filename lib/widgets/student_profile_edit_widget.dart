// import 'package:flutter/material.dart';
// import 'package:ig/widgets/edit_text_field.dart';

//  // Adjust this import

// class StudentProfileEditWidget extends StatelessWidget {
//   final TextEditingController nameController;
//   final TextEditingController mobileController;
//   final TextEditingController locationController;
//   final TextEditingController addressController;
//   final TextEditingController experienceController;
//   final GlobalKey<FormState> formKey;

//   const StudentProfileEditWidget({
//     Key? key,
//     required this.nameController,
//     required this.mobileController,
//     required this.locationController,
//     required this.addressController,
//     required this.experienceController,
//     required this.formKey,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//            EditTextFieldWidget(
//   textEditingController: nameController,
//   hintText: 'Enter your name',
//   icon: Icons.person,
//   label: 'Name',
// ),
// const SizedBox(height: 10),
// EditTextFieldWidget(
//   textEditingController: mobileController,
//   hintText: 'Enter your mobile number',
//   icon: Icons.phone,
//   label: 'Mobile',
// ),
// const SizedBox(height: 10),
// EditTextFieldWidget(
//   textEditingController: locationController,
//   hintText: 'Enter your location',
//   icon: Icons.location_on,
//   label: 'Location',
// ),
// const SizedBox(height: 10),
// EditTextFieldWidget(
//   textEditingController: addressController,
//   hintText: 'Enter your address',
//   icon: Icons.home,
//   label: 'Address',
// ),
// const SizedBox(height: 10),
// EditTextFieldWidget(
//   textEditingController: experienceController,
//   hintText: 'Enter your experience',
//   icon: Icons.work,
//   label: 'Experience',
// ),

//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:internshipgate/widgets/edit_text_field.dart';

class StudentProfileEditWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController locationController;
  final TextEditingController addressController;
  final TextEditingController experienceController;
  final TextEditingController expMonthController;
  final TextEditingController titleController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;

  const StudentProfileEditWidget({
    Key? key,
    required this.nameController,
    required this.mobileController,
    required this.locationController,
    required this.addressController,
    required this.experienceController,
    required this.expMonthController,
    required this.titleController,
    required this.formKey,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: nameController,
              hintText: 'Enter your name',
              icon: Icons.person,
              label: 'Name',
            ),
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: mobileController,
              hintText: 'Enter your mobile number',
              icon: Icons.phone,
              label: 'Mobile',
            ),
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: locationController,
              hintText: 'Enter your location',
              icon: Icons.location_on,
              label: 'Location',
            ),
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: addressController,
              hintText: 'Enter your address',
              icon: Icons.home,
              label: 'Address',
            ),
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: experienceController,
              hintText: 'Enter your experience',
              icon: Icons.work,
              label: 'Experience',
            ),
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: expMonthController,
              hintText: 'Enter your experience months',
              icon: Icons.calendar_today,
              label: 'Experience Months',
            ),
            const SizedBox(height: 10),
            EditTextFieldWidget(
              textEditController: titleController,
              hintText: 'Enter your title',
              icon: Icons.title,
              label: 'Title',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    onSave();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
