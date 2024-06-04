import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import '../../../utils/api_endpoints.dart';

class MessageScreenEmp extends StatefulWidget {
  final String fullname, emptoken;
  final int id;
  const MessageScreenEmp({super.key, required this.fullname, required this.emptoken, required this.id,});

  @override
  State<MessageScreenEmp> createState() => _MessageScreenEmpState();
}

class _MessageScreenEmpState extends State<MessageScreenEmp> {
  final ScrollController _scrollController = ScrollController();
  final loadingIndicatorKey = const ValueKey('loading');
  final _textController = TextEditingController();
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.position.hasContentDimensions && data.isNotEmpty) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });
  }

  Future<void> loadData() async {
    try {
      await chat2(widget.id.toString(), widget.emptoken);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: ${e.toString()}')),
      );
    }
  }

  Future<void> chat1(String internshipApplicationId, String message, String messageFrom, String token) async {
    try {
      Response response = await post(
        Uri.parse('${ApiEndPoints.baseUrl}postMessage'),
        body: {
          'internshipApplicationId': internshipApplicationId,
          'message': message,
          'message_from': messageFrom,
          'token': token,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        var responseData = jsonDecode(response.body);
        print(responseData);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> chat2(String id, String token) async {
    try {
      final response = await get(
        Uri.parse('${ApiEndPoints.baseUrl}getChatByInternshipApplicationId/$id/E$token'),
      );
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
        });
      } else {
        var responseData = jsonDecode(response.body.toString());
        print(responseData);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        title: Text("Messages from all internships & jobs", style: TextStyle(fontSize: width * 0.045)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: Column(
          children: [
            SizedBox(height: height * 0.02),
            Row(
              children: [
                SizedBox(width: width * 0.02),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
                SizedBox(width: width * 0.03),
                CircularContainer(name: widget.fullname),
                SizedBox(width: width * 0.025),
                Expanded(child: Text(widget.fullname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.055),),),
                SizedBox(width: width * 0.02),
              ],
            ),
            SizedBox(height: height * 0.01),
            Divider(thickness: 1, color: Colors.grey[400]),
            SizedBox(height: height * 0.01),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final message = data[index]['message'] ?? '';
                  final messageFrom = data[index]['message_from'];
                  final createdAt = data[index]['created_at'];
        
                  return MessageBubble(
                    message: message,
                    messageFrom: messageFrom,
                    isMe: messageFrom == 'E',
                    createdAt: createdAt,
                  );
                },
              ),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(key: loadingIndicatorKey),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.07,
                width: width * 0.7,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a New Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.01),
              SizedBox(
                width: width * 0.2,
                height: height * 0.07,
                child: OutlinedButton(
                  onPressed: () async {
                    await chat1(widget.id.toString(), _textController.text, 'E', widget.emptoken);
                    await loadData();
                    _textController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(44, 56, 149, 1),
                    side: const BorderSide(color: Color.fromRGBO(44, 56, 149, 1)),
                    padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.01),
                  ),
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}

class CircularContainer extends StatelessWidget {
  final String name;

  const CircularContainer({super.key, required this.name});

  String getInitials() {
    final words = name.split(' ');
    return words.map((word) => word.isNotEmpty ? word[0] : '').join();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final initials = getInitials();
    return CircleAvatar(
      radius: width * 0.065,
      backgroundColor: const Color.fromRGBO(249, 143, 67, 1),
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          fontSize: width * 0.04,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String messageFrom;
  final bool isMe;
  final String createdAt;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.messageFrom,
    this.isMe = false,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final messageBubbleColor = isMe ? Colors.blueGrey.shade100 : Colors.grey[300];
    final time = '${createdAt.split(' ')[1].split(':')[0]}:${createdAt.split(' ')[1].split(':')[1]}';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 4, left: isMe ? width * 0.2 : 8, bottom: 4, right: isMe ? 8 : width * 0.2,),
        child: IntrinsicHeight(
          child: IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.03),
              decoration: BoxDecoration(
                color: messageBubbleColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(
                    message,
                    textStyle: TextStyle(fontSize: width * 0.04),
                  ),
                  SizedBox(height: height * 0.005),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        time,
                        style: TextStyle(fontSize: width * 0.03, color: Colors.black),
                      ),
                      SizedBox(width: width * 0.015),
                      Icon(
                        Icons.done_all,
                        size: width * 0.04,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}