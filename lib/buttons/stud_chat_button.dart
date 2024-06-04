// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ig/screens/dashPages/stud_chat_screen.dart';


// class StudChatButton extends StatelessWidget {
//   final int number;
//   final String title;
//   final IconData icon;
//   final Color iconColor; // New property for the icon color

//   const StudChatButton({super.key, 
//     required this.number,
//     required this.title,
//     required this.icon,
//     required this.iconColor, 
    
//   });

//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: () {
//         Get.to(const ChatScreen(internshipApplicationId: 1, userType: 'S', userToken: '123ghjkgf24',));
//       },
//     child:Container(
//       decoration: BoxDecoration(

//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 number.toString(),
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 icon,
//                 size: 15,
//                 color: iconColor, // Use the provided icon color
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
              
//             ),
//           ),
//         ],
//       ),
//     )
//     );
//   }
// }
