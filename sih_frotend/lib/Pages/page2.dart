import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sih_frotend/Pages/cpage.dart'; // Ensure these pages are defined

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Educate",
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 2),
          ),
          bottom: const TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Color.fromARGB(179, 0, 0, 0),
            indicatorColor: Colors.amber,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Electro"),
              Tab(text: "Home"),
              Tab(text: "Fashion"),
              Tab(text: "Sports"),
              Tab(text: "Toys"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Electro(),
            Home(),
            Fashion(),
            Sports(),
            Toys(),
          ],
        ),
      ),
    );
  }
}
