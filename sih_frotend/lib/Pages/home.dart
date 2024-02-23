// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sih_frotend/Pages/Chat.dart';
import 'package:sih_frotend/Pages/page1.dart';
import 'package:sih_frotend/Pages/page2.dart';
import 'package:sih_frotend/Pages/page3.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 0),
              _buildNavItem(Icons.open_in_new, 1),
              _buildNavItem(Icons.history, 2),
              _buildNavItem(Icons.chat_outlined, 3),
              _buildNavItem(Icons.notifications_active_outlined, 4),
            ],
          ),
        ));
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = index == widget.currentIndex;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.5);
    return GestureDetector(
      onTap: () {
        widget.onTap(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const FirstPage(),
    const SecondPage(),
    const ThirdPage(),
    const ChatPage(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentIndex == 0 ? Colors.blueGrey[50] : Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height *
                0.1, // Adjust the percentage to create space for the bottom navigation bar
            child: _pages[_currentIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
