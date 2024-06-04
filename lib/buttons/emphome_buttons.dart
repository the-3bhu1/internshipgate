// import 'package:flutter/material.dart';

// class EmpHomeButton extends StatelessWidget {
//   final int number;
//   final String title;
//   final IconData icon;
//   final Color iconColor; // New property for the icon color

//   EmpHomeButton({
//     required this.number,
//     required this.title,
//     required this.icon,
//     required this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
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
//                   color: Colors.black,
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
//     );
//   }
// }





import 'package:flutter/material.dart';

class EmpHomeButton extends StatelessWidget {
  final int number;
  final String title;
  final IconData icon;
  final Color iconColor; // New property for the icon color
  final VoidCallback onPressed; // New property for the onPressed callback

  const EmpHomeButton({super.key,
    required this.number,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: onPressed, // Set the onTap callback
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  number.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Icon(
                  icon,
                  size: 15,
                  color: iconColor, // Use the provided icon color
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
