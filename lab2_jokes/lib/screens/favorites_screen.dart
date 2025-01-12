import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/joke.dart';
import '../providers/joke_provider.dart';
import '../widgets/jokes_card.dart';

const Color offWhitePeach = Color(0xFFFFFBF0);

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jokes'),
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
