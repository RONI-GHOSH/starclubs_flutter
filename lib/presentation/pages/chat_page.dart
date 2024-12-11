import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../constants.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController message = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Chat Page"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      itemCount: ChatController.chatList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: userChatCard(ChatController.chatList[index]),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                            hintText: 'Enter Message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (message.text.isNotEmpty) {
                            sendMessage();
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    try {
      final url = Uri.parse("$baseUrl/sendMessage.php");
      final id = await UserInfo.getUserInfo() ?? '';
      final body = {"member_id": id, "message": message.text.toString()};
      print(url);
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        // "X-Requested-With": "XMLHttpRequest",
      };

      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map();
        // Successful request, process the response
        try {
          // Process data
          data = jsonDecode(response.body);
          if (data['status'].toString().compareTo("success") == 0) {
            // Parse message list
            final List<dynamic> messageListJson = data['MessageList'];
            final List<UserMessageModel> messages = messageListJson
                .map((json) => UserMessageModel.fromJson(json))
                .toList();

            // Add messages to chatList
            ChatController.chatList.addAll(messages);

            print('Chat List: ${ChatController.chatList}');
          } else {
            print('Failed status: ${data['status']}');
          }
          message.clear();
          // _WalletController.walletHistory.addAll(iterable)
          // Get.snackbar('Status', 'Bank Successfully committed',
          //     backgroundColor: Colors.green);
        } catch (e) {
          print('Error decoding JSON: $e');
          CustomAlert.error("Error", "Failed to decode data");
        }
      } else {
        // Handle server errors
        CustomAlert.error("Alert", "Your detail went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
  }

  Future<void> getMessage() async {
    ChatController.chatList.clear();
    try {
      final url = Uri.parse("$baseUrl/getMessages.php");
      final id = await UserInfo.getUserInfo() ?? '';
      final body = {
        "memberid": id,
      };
      print(url);
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        // "X-Requested-With": "XMLHttpRequest",
      };

      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map();
        // Successful request, process the response
        try {
          // Process data
          print(response.body);
          data = jsonDecode(response.body);
          if (data['status'].toString().compareTo("success") == 0) {
            final list = data['MessageList'] as List;
            final messages =
                list.map((e) => UserMessageModel.fromJson(e)).toList();
            ChatController.chatList.addAll(messages);
            Timer(
              Duration(seconds: 2),
              () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
            );
          }
          // Get.snackbar('Status', 'Bank Successfully committed',
          //     backgroundColor: Colors.green);
        } catch (e) {
          print('Error decoding JSON: $e');
          CustomAlert.error("Error", "Failed to decode data");
        }
      } else {
        // Handle server errors
        CustomAlert.error("Alert", "Your detail went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
  }

  Widget userChatCard(UserMessageModel model) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              model.content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4),
            Text(
              model.timestamp,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatController extends GetxController {
  static RxList chatList = [].obs;
}

class UserMessageModel {
  final String content;
  final String timestamp;

  UserMessageModel({
    required this.content,
    required this.timestamp,
  });

  factory UserMessageModel.fromJson(Map<String, dynamic> json) {
    return UserMessageModel(
        content: json['content'], timestamp: json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    return {"content": content, "timestamp": timestamp};
  }
}
