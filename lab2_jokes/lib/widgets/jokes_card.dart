import 'package:flutter/material.dart';
import 'package:lab2_jokes/providers/joke_provider.dart';
import 'package:provider/provider.dart';

import '../models/joke.dart';

class CustomCard extends StatelessWidget {
  final Joke joke;
  final VoidCallback onFavoriteToggle;

  const CustomCard({super.key, 
    required this.joke,
    required this.onFavoriteToggle,
  });

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE6E6FA), // light violet
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 40, 16),
                  child: Text(
                    joke.setup,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF4B0082), // dark violet
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    joke.punchline,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B0082), // dark violet
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: IconButton(
                onPressed: () {
                  context.read<JokeProvider>().toggleFavorite(joke);
                },
                color: joke.isFavorite ? Colors.red : Colors.deepPurple,
                icon: const Icon(Icons.favorite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
