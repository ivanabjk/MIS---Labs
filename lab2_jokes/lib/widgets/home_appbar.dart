import 'package:flutter/material.dart';
import '../screens/random_joke_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;

  CustomAppBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.deepPurple,
            width: 2.0,
          ),
        ),
      ),
      child: AppBar(
        title: Text(
          'Joke Types',
          style: TextStyle(
            color: Colors.deepPurple,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFE6E6FA), // light violet
        actions: [
          IconButton(
            icon: Icon(Icons.casino, color: Colors.deepPurple),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomJokeScreen(),
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.refresh, color: Colors.deepPurple),
          onPressed: onRefresh,
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}