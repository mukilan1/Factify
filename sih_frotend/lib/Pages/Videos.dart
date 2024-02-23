// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoItem {
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;

  VideoItem({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
  });
}

class Video extends StatelessWidget {
  final List<VideoItem> videos = [
    // Populate with your video data
    VideoItem(
      title: "eCommerce",
      description:
          "Learn what is eCommerce and different types of eCommerce - B2B, B2C, C2B and C2C.\nAlso learn about Mobile Commerce and Social Media Commerce.",
      videoUrl: "https://www.youtube.com/watch?v=Zzs6kLlkAUQ",
      thumbnailUrl:
          "https://uncannycs.com/wp-content/uploads/2022/09/maxresdefault.jpg",
    ),
    VideoItem(
      title: "E-commerce Law",
      description:
          "Prof. Mark Grabowski's brief primer on some of the key legal issues facing online businesses and merchants, including taxes, ADA compliance, defamation and negative online reviews and more. Anti-trust issues involving big tech companies is also discussed.",
      videoUrl: "https://www.youtube.com/watch?v=LOh2QoTqa2c",
      thumbnailUrl: "https://img.youtube.com/vi/LOh2QoTqa2c/sddefault.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Videos',
          style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 2),
        ),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          var video = videos[index];
          return Container(
            margin: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 8), // Increased vertical margin
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          video.description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () async {
                            if (await canLaunch(video.videoUrl)) {
                              await launch(video.videoUrl);
                            }
                          },
                          child: Text(
                            'Watch Video',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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
}
