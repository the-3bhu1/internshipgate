import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VirtualInternshipPage extends StatelessWidget {
  final int studentId, applicantId;
  final String emai, fullname, emptoken;

  // ignore: use_key_in_widget_constructors
  const VirtualInternshipPage({
    Key? key,
    required this.studentId,
    required this.emai,
    required this.fullname,
    required this.emptoken,
    required this.applicantId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Image(
              image: const AssetImage('lib/images/vipage.png'),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),*/
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trending on InternshipGate 🔥',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      letterSpacing: 1.1,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  buildJobCard(
                    'Virtual Internship',
                    'https://internshipgate.com/virtual-internship',
                    'lib/images/Virtual_Internship.png',
                  ),
                  buildJobCard(
                    'Resume Builder',
                    'https://internshipgate.com/ResumeBuilder',
                    'lib/images/BuildResume.png',
                  ),
                  buildJobCard(
                    'Study Abroad',
                    'https://internshipgate.com/study-abroad',
                    'lib/images/Study_Abroad.png',
                  ),
                  buildJobCard(
                    'Study Abroad',
                    'https://internshipgate.com/mentorship',
                    'lib/images/Mentorship.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create job card-like rounded rectangle ListTile
  Widget buildJobCard(String title, String url, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 7.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 155,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: ListTile(
          onTap: () async {
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not launch $uri';
            }
          },
          tileColor: Colors.white,
        ),
      ),
    );
  }
}