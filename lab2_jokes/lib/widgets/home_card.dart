import 'package:flutter/material.dart';
import '../screens/jokes_by_type_screen.dart';

class CustomCard extends StatelessWidget {
  final String jokeType;
  final VoidCallback onTap;

  CustomCard({required this.jokeType, required this.onTap});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE6E6FA), // light violet
      shadowColor: Colors.deepPurple, // Custom darker teal for card shadow
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              capitalize(jokeType),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Custom darker teal for text
              ),
            ),
          ),
        ),
      ),
    );
  }
}
