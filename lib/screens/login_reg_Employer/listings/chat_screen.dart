import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import '../../../utils/api_endpoints.dart';
import 'message_screen.dart';

class ChatScreenEmp extends StatefulWidget {
  final int id;
  final String emptoken;
  const ChatScreenEmp({super.key, required this.id, required this.emptoken});

  @override
  State<ChatScreenEmp> createState() => _ChatScreenEmpState();
}

class DropdownItem {
  final String id;
  final String internshipDetails;

  DropdownItem({required this.id, required this.internshipDetails});
}

class _ChatScreenEmpState extends State<ChatScreenEmp> {
  final _text1Controller = TextEditingController();
  List<DropdownItem> dropdownItems = [];
  DropdownItem allItem = DropdownItem(id: 'All', internshipDetails: 'All');
  String searchText = '';
  List<Map<String, dynamic>> chatList = [];

  Color getBackgroundColor(String text3) {
    switch (text3) {
      case 'Not Shortlisted':
        return Colors.orange;
      case 'Hired/Offer Sent':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Shortlisted':
        return Colors.blue;
      default:
        return Colors.transparent;
    }
  }

  @override
  void initState() {
    super.initState();
    chat3(widget.id.toString(), widget.emptoken.toString());
    list(widget.id.toString());
  }

  Future<void> chat3(String id, token) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getAllInitiatedChats/$id/E$token'),
      );
      if(response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body.toString());
          //print(data);
          chatList = List<Map<String, dynamic>>.from(
              data['initiatedChatList'] ?? []);
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

  Future<void> list(String id) async {
    try{
      Response response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getEmployerInternshipByEmployerId/$id'),
      );
      if(response.statusCode == 200) {
        var internships = jsonDecode(response.body.toString());
        //print(internships);
        List<DropdownItem> internshipDetailsList = internships.map<DropdownItem>((internship) {
          return DropdownItem(
            id: internship['id'].toString(), // Assuming 'id' is the field name in your data
            internshipDetails: internship['internship_details'].toString(),
          );
        }).toList();
        internshipDetailsList.insert(0, DropdownItem(id: 'All', internshipDetails: 'All'));
        setState(() {
          dropdownItems = internshipDetailsList;
        });
      }
      else {
        var data = jsonDecode(response.body.toString());
        print(data);
        //return [];
      }
    } catch (e){
      print(e.toString());
      //return [];
    }
  }

  Future<void> stu(String id) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getApplicantListForInternship/$id'),
      );
      if(response.statusCode == 200) {
        setState(() {
          List<dynamic> decodedData = jsonDecode(response.body.toString());
          chatList = decodedData.map<Map<String, dynamic>>((item) {
            return {
              'student_name': item['student_name'],
              'internship_details': item['internship_details'],
              'application_status': item['application_status'],
              'created_at': item['created_at'],
              'id' : item['id']
            };
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
        ),
        title: Text("Messages from all internships & jobs", style: TextStyle(fontSize: width * 0.045),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.08,
              child: DropdownSearch<DropdownItem>(
                items: dropdownItems,
                itemAsString: (item) => item.id == 'All' ? 'All' : '${item.id} - ${item.internshipDetails}',
                onChanged: (selectedItem) {
                  if (selectedItem != null) {
                    if (selectedItem.id == 'All') {
                      chat3(widget.id.toString(), widget.emptoken.toString());
                    } else {
                      stu(selectedItem.id);
                    }
                  }
                },
                popupProps:  const PopupProps.menu(
                  constraints: BoxConstraints(maxHeight: 400),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(7))
                  ),
                ),
                selectedItem: allItem,
              ),
            ),
            SizedBox(height: height * 0.005,),
            SizedBox(
              height: height * 0.08,
              child: TextField(
                autofocus: false,
                controller: _text1Controller,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search applicants by name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01,),
            Divider(
              thickness: 1,
              color: Colors.grey[400],
            ),
            SizedBox(height: height * 0.01,),
            Expanded(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  var chatData = chatList[index];
                  if (searchText.isNotEmpty && !chatData['student_name'].toLowerCase().contains(searchText.toLowerCase())) {
                    return Container();
                  }
                  return Mes(
                    chatData['student_name'],
                    chatData['internship_details'],
                    chatData['application_status'],
                    chatData['created_at'],
                    chatData['id']
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget Mes(String text1, text2, text3, text4, int id) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Get.to(() => MessageScreenEmp(fullname: text1, emptoken: widget.emptoken, id: id,));
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.blueGrey.shade300,),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.047),),
                      SizedBox(height: height * 0.013,),
                      Text(text2),
                      SizedBox(height: height * 0.013,),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: height * 0.004, horizontal: width * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: getBackgroundColor(text3),
                        ),
                        child: Text(
                          text3,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(text4.substring(11, 16))
              ],
            ),
          ),
          SizedBox(height: height * 0.015,),
        ],
      ),
    );
  }
}