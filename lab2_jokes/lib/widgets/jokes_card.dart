import 'package:flutter/material.dart';
import '../models/joke.dart';

class CustomCard extends StatelessWidget {
  final Joke joke;

  CustomCard({required this.joke});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE6E6FA), // light violet
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              joke.setup,
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFF4B0082), // dark violet
              ),
            ),
            SizedBox(height: 10),
            Text(
              joke.punchline,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B0082), // dark violet
              ),
            ),
          ],
        ),
      ),
    );
  }
}
