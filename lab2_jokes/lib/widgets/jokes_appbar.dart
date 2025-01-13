import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/random_joke_screen.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onCasinoPress;

  CustomAppBar({required this.title, required this.onCasinoPress});

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
            icon: Icon(Icons.casino, color: Colors.deepPurple),
            onPressed: onCasinoPress,
          ),
          IconButton(
            onPressed: () {
              AuthService().logout(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: const Icon(Icons.logout),
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
