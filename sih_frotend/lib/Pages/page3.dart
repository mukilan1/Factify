import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import for date formatting

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  Future<List<dynamic>> fetchData() async {
    final Uri url = Uri.parse('http://127.0.0.1:61575/App1/productsearch/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw 'No History Found';
    }
  }

  String formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final formatted = DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
      return formatted;
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'History',
          style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 2),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final data = snapshot.data!.reversed.toList();

              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(productData: item),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 236, 240, 255),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.history, color: Colors.white),
                        ),
                        title: Text(
                          item['name'] ?? 'Product Name',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          formatDateTime(item['CurrentDate'] ?? ''),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.deepPurple),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No data available',
                  style: GoogleFonts.poppins(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key? key, required this.productData})
      : super(key: key);

  final dynamic productData;

  Widget _buildDetailCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        // Set the border here
        border: Border.all(
          color: Colors.black, // This is the border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(20), // Border radius
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Match border radius
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          subtitle: Text(content),
        ),
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
    final FlutterTts flutterTts = FlutterTts();

    Future speak(String text) async {
      await flutterTts.speak(text);
    }

    Color feelColor = _getFeelColor(productData['feel']);
    double rating =
        (productData['Rating'] ?? 0) / 5.0; // Assuming the rating is out of 5

    // Prepare the text to be spoken
    String ttsText = """
      Product Name: ${productData['name'] ?? 'N/A'},
      Feel: ${productData['feel'] ?? 'N/A'},
      Transparency: ${productData['Transparency'] ?? 'N/A'},
      Misleading Data: ${productData['MisleadingData'] ?? 'N/A'},
      Cost: ${productData['Cost'] ?? 'N/A'},
      Wrong Data: ${productData['WrongData'] ?? 'N/A'},
      Suggestion: ${productData['Suggestion'] ?? 'N/A'},
      Omitted Data: ${productData['omitted'] ?? 'N/A'}
      E-Commerce Data: ${productData['ecommerce_specs'] ?? 'N/A'}
      Official Data: ${productData['official_specs'] ?? 'N/A'}.
      
    """;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Product Details',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => speak(ttsText),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData['name'] ?? 'Product Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Chip(
                  label: Text(
                    productData['feel'] ?? 'Unknown',
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
                _buildDetailCard(
                    'Transparency', productData['Transparency'] ?? 'N/A'),
                _buildDetailCard(
                    'Misleading Data', productData['MisleadingData'] ?? 'N/A'),
                _buildDetailCard('Cost', productData['Cost'] ?? 'N/A'),
                _buildDetailCard(
                    'Wrong Data', productData['WrongData'] ?? 'N/A'),
                _buildDetailCard(
                    'Suggestion', productData['Suggestion'] ?? 'N/A'),
                _buildDetailCard(
                    'Omitted Data', productData['omitted'] ?? 'N/A'),
                _buildDetailCard(
                    'E-Commerce Data', productData['ecommerce_specs'] ?? 'N/A'),
                _buildDetailCard(
                    'Official Data', productData['official_specs'] ?? 'N/A'),
              ],
            ),
          ),
        ));
  }
}
