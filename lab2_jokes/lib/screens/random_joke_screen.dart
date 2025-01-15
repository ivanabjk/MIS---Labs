import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/joke.dart';
import '../providers/joke_provider.dart';
import '../services/api_services.dart';
import '../widgets/random_appbar.dart';
import '../widgets/random_card.dart';

const Color evenLighterOffWhitePeach = Color(0xFFFFFBF0);

class RandomJokeScreen extends StatefulWidget {
  const RandomJokeScreen({super.key});

  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Joke Of The Day',
            //onRefresh: refreshJoke,
          ),
          Expanded(
            child: Container(
              color: evenLighterOffWhitePeach,
              child: Consumer<JokeProvider>(
                builder: (context, jokeProvider, child) {
                  if (jokeProvider.jokeOfTheDay == null) {
                    jokeProvider.fetchRandomJoke(); // Ensure the joke is fetched once
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: IntrinsicHeight(
                        child: CustomCard(joke: jokeProvider.jokeOfTheDay!),
                      ),
                    );
                  }
                },

              ),
            ),
          ),
        ],
      ),
    );
  }
}
