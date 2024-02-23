// ignore_for_file: file_names, library_private_types_in_public_api, sort_child_properties_last, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoadingResponse = false; // State variable for loading indicator
  List<Map<String, dynamic>> messages = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.add({
      "text": "Hi there! How can I help you today?\n\n"
          "Here are some things you can ask me:\n"
          "- Pricing Issue\n"
          "- Specification Error\n"
          "- Availability Info\n"
          "- Incorrect Listing",
      "isUser": false
    });
  }

  void _sendMessage(String text) async {
    setState(() {
      messages.add({"text": text, "isUser": true});
      isLoadingResponse = true; // Start loading when sending message
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:61575/App1/chatbot/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'User': text,
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String botResponse =
            responseData['User']; // Extract 'User' field from response
        messages.add({"text": botResponse, "isUser": false});
      } else {
        // Handle error or show an error message
        messages.add(
            {"text": "Error occurred in getting response", "isUser": false});
      }
      isLoadingResponse = false; // Stop loading after receiving response
    });

    _controller.clear();
  }

  Widget _buildQuickReplyButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton(
        onPressed: () {
          _sendMessage(
              // ignore: unnecessary_brace_in_string_interps
              "${title} in the Current E-Commerce websites"); // Send message when button is pressed
        },
        child: Text(title),
        style: OutlinedButton.styleFrom(
          primary: Colors.deepPurple,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          centerTitle: true,
          title: Text(
            'Factbot',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
                letterSpacing: 2),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                image: DecorationImage(
                    image: AssetImage("assets/Bg2.jpg"), fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length +
                        (isLoadingResponse
                            ? 1
                            : 0), // Increase count if loading
                    itemBuilder: (context, index) {
                      if (isLoadingResponse && index == messages.length) {
                        return const ListTile(
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      bool isUserMessage = messages[index]["isUser"];
                      return ListTile(
                        leading: isUserMessage
                            ? null
                            : const CircleAvatar(child: Icon(Icons.android)),
                        trailing: isUserMessage
                            ? const CircleAvatar(child: Icon(Icons.person))
                            : null,
                        title: Align(
                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: isUserMessage
                                    ? Colors.green[100]
                                    : Colors.blue[100],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: isUserMessage != true
                                      ? const Radius.circular(0)
                                      : const Radius.circular(20),
                                  bottomRight: isUserMessage
                                      ? const Radius.circular(0)
                                      : const Radius.circular(20),
                                )),
                            child: Text(
                              messages[index]["text"],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            _sendMessage(_controller.text.trim());
                          }
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Change the border color here
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Change the border color here
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        _sendMessage(text.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      _buildQuickReplyButton("Pricing Issue"),
                      _buildQuickReplyButton("Specification Error"),
                      _buildQuickReplyButton("Availability Info"),
                      _buildQuickReplyButton("Incorrect Specification"),
                      _buildQuickReplyButton("Refund Policy"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )));
  }
}
