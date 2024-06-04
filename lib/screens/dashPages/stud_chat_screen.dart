// import 'package:flutter/material.dart';
// import 'package:ig/widgets/input_for_chat.dart';




// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final TextEditingController _textController = TextEditingController();

//   void _handleSubmitted(String text) {
//     _textController.clear();
//     ChatMessage message = ChatMessage(text: text);
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }

//   Widget _buildTextComposer() {
//     return IconTheme(
//       data: const IconThemeData(color: Colors.blue),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Row(
//           children: <Widget>[
//             const Flexible(
//               child: ChatTextFieldWidget(
//                 hintText: 'Type a New Message',
//                 // controller: _textController,
//                 // onSubmitted: _handleSubmitted,
//                 //  decoration:
//               // const InputDecoration.collapsed(hintText: 'Type a New Message'),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: () {
//                   _handleSubmitted(_textController.text);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
//           title: const Text('Chat Screen'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Flexible(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 reverse: true,
//                 itemBuilder: (_, int index) => _messages[index],
//                 itemCount: _messages.length,
//               ),
//             ),
//             const Divider(height: 1.0),
//             Container(
//               decoration: BoxDecoration(color: Theme.of(context).cardColor),
//               child: _buildTextComposer(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatMessage extends StatelessWidget {
//   final String text;

//   const ChatMessage({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(right: 16.0),
//             child: const CircleAvatar(
//               child: Text('User'),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('User', style: Theme.of(context).textTheme.titleMedium),
//                 Container(
//                   margin: const EdgeInsets.only(top: 5.0),
//                   child: Text(text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const baseUrl = 'http://<base_url>';

//   Future<Map<String, dynamic>> postMessage(Map<String, dynamic> data) async {
//     final response = await http.post(Uri.parse('$baseUrl/api/postMessage'), body: jsonEncode(data));
//     return jsonDecode(response.body);
//   }

//   Future<List<dynamic>> getChatByInternshipApplicationId(int internshipId, String token) async {
//     final response = await http.get(Uri.parse('$baseUrl/api/getChatByInternshipApplicationId/$internshipId/$token'));
//     return jsonDecode(response.body);
//   }

//   // Add other API methods as needed
// }
// // chat_controller.dart


// class ChatController extends GetxController {
//   final ApiService apiService = ApiService();
//   var chatMessages = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
    
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch initial chat data
//     fetchChat(internshipId, token);
//   }

//   Future<void> fetchChat(int internshipId, String token) async {
//     final result = await apiService.getChatByInternshipApplicationId(internshipId, token);
//     // chatMessages.value = result ?? [];
//   }

//   Future<void> postMessage(Map<String, dynamic> data) async {
//     final result = await apiService.postMessage(data);
//     if (result['message'] == 'message posted') {
//       // Assuming success, you might want to handle errors accordingly
//       await fetchChat(data['internship_application_id'], data['token']);
//     }
//   }

//   // Add other methods for interview scheduling, getting initiated chats, etc.
// }
// // chat_screen.dart




// class ChatScreen extends StatelessWidget {
//   final ChatController chatController = Get.put(ChatController());
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Screen'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(
//               () => ListView.builder(
//                 itemCount: chatController.chatMessages.length,
//                 itemBuilder: (context, index) {
//                   final message = chatController.chatMessages[index];
//                   return ListTile(
//                     title: Text(message['message']),
//                     subtitle: Text(message['created_at']),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Post a new message
//                     final data = {
//                       'internship_application_id': internshipId,
//                       'message': _messageController.text,
//                       'message_from': 'E', // Assuming employer for this example
//                       'token': token,
//                     };
//                     chatController.postMessage(data);
//                     _messageController.clear();
//                   },
//                   child: const Text('Post'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/api_endpoints.dart';

class ChatScreen extends StatefulWidget {
  final int internshipApplicationId;
  final String userType; // "S" for student, "E" for employer
  final String userToken;

  const ChatScreen({super.key, 
    required this.internshipApplicationId,
    required this.userType,
    required this.userToken, required email,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _chatTranscript = [];

  @override
  void initState() {
    super.initState();
    // Fetch initial chat data
    _getChatMessages();
  }

  void _getChatMessages() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndPoints.baseUrl}getChatByInternshipApplicationId/${widget.internshipApplicationId}/${widget.userType}${widget.userToken}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _chatTranscript =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        // Handle error
        print('Error fetching chat messages');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  void _postChatMessage() async {
    String clientMessage = _messageController.text;

    try {
      final response = await http.post(
        Uri.parse('${ApiEndPoints.baseUrl}postMessage'),
        body: jsonEncode({
          'internship_application_id': widget.internshipApplicationId,
          'message': clientMessage,
          'message_from': widget.userType,
          'token': widget.userToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('success');
       
        _getChatMessages();
      } else {
        
        print('Error posting chat message');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatTranscript.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_chatTranscript[index]['message']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _postChatMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:internshipgate/screens/dashPages/stud_message_screen.dart';
import '../../../utils/api_endpoints.dart';

class ChatScreenStu extends StatefulWidget {
  final int id;
  final String stutoken;
  const ChatScreenStu({super.key, required this.id, required this.stutoken});

  @override
  State<ChatScreenStu> createState() => _ChatScreenStuState();
}

class DropdownItem {
  final String id;
  final String internshipDetails;

  DropdownItem({required this.id, required this.internshipDetails});
}

class _ChatScreenStuState extends State<ChatScreenStu> {
  final _text1Controller = TextEditingController();
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
    chat3(widget.id.toString(), widget.stutoken.toString());
  }

  Future<void> chat3(String id, token) async {
    try{
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getStudentInternshipListWithChat/$id/S$token'),
      );
      if(response.statusCode == 200) {
        setState(() {
          var data = jsonDecode(response.body.toString());
          //print(data);
          chatList = List<Map<String, dynamic>>.from(
              data ?? []);
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
              height: height * 0.06,
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
                  if (searchText.isNotEmpty && !chatData['companyname'].toLowerCase().contains(searchText.toLowerCase())) {
                    return Container();
                  }
                  return Mes(
                      chatData['companyname'],
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
        Get.to(() => MessageScreenStu(fullname: text1, stutoken: widget.stutoken, id: id,));
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