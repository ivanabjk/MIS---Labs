import 'package:flutter/material.dart';
import '../models/joke.dart';

class CustomCard extends StatelessWidget {
  final Joke joke;

  const CustomCard({super.key, required this.joke});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE6E6FA), // light violet
      elevation: 0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              joke.setup,
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xFF4B0082), // dark violet
              ),
            ),
            SizedBox(height: 20),
            Text(
              joke.punchline,
              style: TextStyle(
                fontSize: 24.0,
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
