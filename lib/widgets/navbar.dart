// // import 'package:flutter/material.dart';
// // class NavBar extends StatelessWidget {
// //   const NavBar({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Drawer ();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ig/screens/login_reg_Student/home_stud_screen.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class NavBar extends StatelessWidget {
//   const NavBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: const EdgeInsets.only(top: 30),
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(left: 0),
//             child: ListTile(
//               // title: const Text('Virtual Internship'),
//               title: Image.asset(
//                 'lib/icons/logo.png',
//                 height: 50.0,
//                 width: 50.0,
//               ),
//               // onTap: () {
//               //   // Handle the onTap event here
//               // },
//             ),
//           ),
//           ListTile(
//             title: const Text(' Internships'),
//             leading: const Icon(Icons.school_outlined),
//             iconColor: Colors.amber,
//             onTap: () {
//               // Handle the onTap event here
//             },
//           ),
//           ListTile(
//             title: const Text('Online Training'),
//             leading: const Icon(Icons.open_in_browser_outlined),
//             onTap: () {
//               // Handle the onTap event here
//             },
//           ),
//           ListTile(
//             title: const Text('Virtual Internship'),
//             leading: const Icon(Icons.screen_search_desktop_outlined),
//             onTap: () {
//               // Handle the onTap event here
//             },
//           ),
//           ListTile(
//             title: const Text('Dashboard'),
//             leading: const Icon(Icons.space_dashboard_outlined),
//             onTap: () {
//               // Get.offAll(() =>
//               //   const HomeScreen());// Handle the onTap event here
//               Get.to(const StudHomeScreen());
//             },
//           ),
//           ListTile(
//             title: const Text('Report a Complaint'),
//             leading: const Icon(Icons.report_gmailerrorred),
//             onTap: () {
//               // Handle the onTap event here
//             },
//           ),
//           ListTile(
//             title: const Text('More'),
//             leading: const Icon(Icons.more_horiz),
//             onTap: () {
//               // Handle the onTap event here
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   String? userToken; // Store the user's token

//   @override
//   void initState() {
//     super.initState();
//     _loadUserToken(); // Load the user's token when the screen initializes
//   }

//   Future<void> _loadUserToken() async {
//     final SharedPreferences prefs = await _prefs;
//     setState(() {
//       userToken = prefs.getString('token');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const NavBar(),
//       backgroundColor: const Color.fromARGB(255, 241, 245, 249),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         title: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(
//                 'your_app_logo_path_here', // Replace with your app logo path
//                 height: 30,
//                 width: 30,
//               ),
//             ),
//             const Text('Your App Title'),
//           ],
//         ),
//         actions: <Widget>[
//           PopupMenuButton(
//             itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//               const PopupMenuItem(
//                 child: Text('Virtual Internship'),
//               ),
//               const PopupMenuItem(
//                 child: Text('Help & Support'),
//               ),
//               const PopupMenuItem(
//                 child: Text('Help Centre'),
//               ),
//               const PopupMenuItem(
//                 child: Text('Report a Complaint'),
//               ),
//               const PopupMenuItem(
//                 child: Text('More'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Welcome home'),
//             if (userToken != null) Text('Token: $userToken'),
//             ElevatedButton(
//               onPressed: () async {
//                 final SharedPreferences prefs = await _prefs;
//                 print(prefs.get('token'));
//               },
//               child: const Text('Print Token'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
