import 'package:flutter/material.dart';
import 'package:lab2_jokes/screens/random_joke_screen.dart';
import 'package:provider/provider.dart';

import '../models/joke.dart';
import '../providers/joke_provider.dart';
import '../services/auth_service.dart';
import '../widgets/jokes_card.dart';
import 'login_screen.dart';

const Color offWhitePeach = Color(0xFFFFFBF0);

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.deepPurple,
                width: 2.0,
              ),
            ),
          ),
          child: AppBar(
            title: Center(
              child: Text(
                'Favorite Jokes',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  AuthService().logout(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                icon: const Icon(Icons.logout),
              ),
            ],
            leading: IconButton(
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
          ),
        ),
      ),
      body: Container(
        color: offWhitePeach,
        child: Consumer<JokeProvider>(
          builder: (context, jokeProvider, child) {
            if (jokeProvider.favoriteJokes.isEmpty) {
              return Center(child: Text('No favorite jokes yet.'));
            } else {
              return ListView.builder(
                itemCount: jokeProvider.favoriteJokes.length,
                itemBuilder: (context, index) {
                  Joke joke = jokeProvider.favoriteJokes[index];
                  return CustomCard(
                    joke: joke,
                    onFavoriteToggle: () {
                      jokeProvider.toggleFavorite(joke);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
