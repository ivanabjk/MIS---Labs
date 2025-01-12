import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onRefresh;

  CustomAppBar({required this.title, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF4B0082), // dark violet
            width: 2.0,
          ),

        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF4B0082), // dark violet
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF4B0082)), // dark violet
            onPressed: onRefresh,
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0xFFE6E6FA), // light violet
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
