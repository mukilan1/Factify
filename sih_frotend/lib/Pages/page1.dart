// ignore_for_file: use_build_context_synchronously, avoid_print, unused_element, deprecated_member_use

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sih_frotend/Pages/Blog.dart';
import 'package:sih_frotend/Pages/Videos.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController urlController = TextEditingController();
  Timer? timer; // Define the timer here
  int messageIndex = 0;
  List<String> messages = [
    "Processing...",
    "Getting Official Data",
    "Making Comparison",
    "Generating Results ...",
  ];

  @override
  void dispose() {
    urlController.dispose();
    timer?.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  Future<void> sendLinkToDjango(String link, BuildContext context) async {
    List<String> messages = [
      "Processing...",
      "Getting Official Data",
      "Making Comparison",
      "Generating Results ...",
      "Processing Pleas wait...",
    ];
    int messageIndex = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Timer? timer; // Declare the timer here so it can be cancelled later
        return StatefulBuilder(
          builder: (context, setState) {
            timer = Timer.periodic(const Duration(seconds: 13), (Timer t) {
              if (!mounted) return; // Check if the widget is still mounted
              if (messageIndex < messages.length - 1) {
                setState(() {
                  messageIndex++;
                });
              } else {
                timer?.cancel(); // Cancel the timer when it's no longer needed
              }
            });

            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 20),
                    Expanded(child: Text(messages[messageIndex])),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => timer
        ?.cancel()); // Ensure the timer is cancelled when the dialog is closed

    final url = Uri.parse('http://127.0.0.1:61575/App1/process/');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({"link": link});

    try {
      final response = await http.post(url, headers: headers, body: body);
      Navigator.pop(context); // Close the dialog
      timer?.cancel(); // Cancel the timer

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPage(responseData: response.body),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                  'Failed to process the request. Status code: ${response.statusCode}\nDetails: ${responseData['message'] ?? 'No details provided.'}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close the dialog
      timer?.cancel(); // Cancel the timer

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
    }

    urlController.clear(); // Clear the text field
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to \nFactify",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 250, // Adjust width as needed
                            child: TyperAnimatedTextKit(
                              isRepeatingAnimation:
                                  false, // Set to true for repeating animation
                              speed: const Duration(
                                  milliseconds: 100), // Adjust typing speed
                              textStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                                color: Colors.blueGrey[300]!,
                              ),
                              text: const [
                                "Paste your URL here to get started!"
                              ],
                              textAlign: TextAlign
                                  .start, // Align text to start of widget
                            ),
                          )
                        ]),
                    Expanded(child: Container()),
                    const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromARGB(255, 223, 198, 95),
                            child: Icon(
                              Icons.android,
                              color: Colors.white,
                              size: 30,
                            ))),
                  ]),
                  const SizedBox(height: 20),
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: "Enter URL here",
                      hintStyle:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                      fillColor: Colors.blueGrey[50]!,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Change the border color here
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Change the border color here
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      prefixIcon: const Icon(Icons.link, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (urlController.text.isNotEmpty) {
                        sendLinkToDjango(urlController.text, context);
                      } else {
                        print("Please enter a URL");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Analyze URL',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Stack(children: [
              Container(
                  decoration: BoxDecoration(
                color: Colors.blueGrey[50]!,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(1000),
                    topRight: Radius.circular(20)),
              )),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [buildColorfulGrid(context)]),
              )
            ]))
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.up,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.deepPurple,
        animatedIconTheme: const IconThemeData(
            color: Colors.white), // Change the animated icon color here
        children: [
          SpeedDialChild(
            child: const Icon(Icons.shopping_cart),
            label: 'Amazon',
            onTap: () => _launchURL('https://www.amazon.com'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_bag),
            label: 'Flipkart',
            onTap: () => _launchURL('https://www.flipkart.com'),
          ),
        ],
      ),
    );
  }

  Widget buildColorfulGrid(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        'title': 'Videos',
        'icon': Icons.video_collection,
        'color': const Color.fromARGB(255, 216, 66, 243),
        'destination': Video(),
      },
      {
        'title': 'Blogs',
        'icon': Icons.book,
        'color': const Color.fromARGB(255, 97, 181, 250),
        'destination': PostsPage(),
      },
      {
        'title': 'About',
        'icon': Icons.error_outline,
        'color': const Color.fromARGB(255, 97, 250, 156),
        'destination': const FirstPage(),
      },
      {
        'title': 'Privacy Policy',
        'icon': Icons.policy,
        'color': const Color.fromARGB(255, 255, 102, 99),
        'destination': const FirstPage(),
      },
      // Add more items as needed
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // if you want to disable scrolling in the GridView
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 30,
          childAspectRatio: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item['destination']),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [item['color'], item['color'].withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 8),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    item['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _drawerItem({IconData? icon, String? text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text ?? ''),
      onTap: onTap,
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({Key? key, required this.responseData}) : super(key: key);

  final String responseData;

  Widget _buildDetailCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Color _getFeelColor(String? feel) {
    switch (feel) {
      case 'Good':
        return Colors.green;
      case 'Bad':
        return Colors.red;
      case 'Fair':
        return Colors.amber;
      default:
        return Colors.grey; // Default color for undefined or null 'feel'
    }
  }

  Color _getRatingColor(double rating) {
    if (rating > 0.7) {
      return Colors.green;
    } else if (rating > 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = json.decode(responseData);
    Color feelColor = _getFeelColor(data['feel']);
    double rating =
        (data['Rating'] ?? 0) / 5.0; // Assuming the rating is out of 5

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Response Data',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: 20,
            )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'] ?? 'Product Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(
                data['feel'] ?? 'Unknown',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: feelColor,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: rating,
              backgroundColor: Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getRatingColor(rating)),
            ),
            const SizedBox(height: 20),

            _buildDetailCard('Transparency', data['Transparency'] ?? 'N/A'),
            // _buildDetailCard(
            //     'Not Similar Data', data['NotsimilarData'] ?? 'N/A'),
            _buildDetailCard(
                'Misleading Data', data['MisleadingData'] ?? 'N/A'),
            _buildDetailCard('Cost', data['Cost'] ?? 'N/A'),
            _buildDetailCard('Wrong Data', data['WrongData'] ?? 'N/A'),
            _buildDetailCard('Suggestion', data['Suggestion'] ?? 'N/A'),
            _buildDetailCard('omitted Data', data['omitted'] ?? 'N/A'),
            _buildDetailCard(
                'E-Commerce Data', data['ecommerce_specs'] ?? 'N/A'),
            _buildDetailCard('Official Data', data['official_specs'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}
