import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/api_services.dart';
import '../widgets/random_appbar.dart';
import '../widgets/random_card.dart';

const Color evenLighterOffWhitePeach = Color(0xFFFFFBF0);

class RandomJokeScreen extends StatefulWidget {
  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  final ApiService apiService = ApiService();
  late Future<Joke> randomJoke;

  @override
  void initState() {
    super.initState();
    randomJoke = apiService.getRandomJoke();
  }

  void refreshJoke() {
    setState(() {
      randomJoke = apiService.getRandomJoke();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Random Joke',
            onRefresh: refreshJoke,
          ),
          Expanded(
            child: Container(
              color: evenLighterOffWhitePeach,
              child: FutureBuilder<Joke>(
                future: randomJoke,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load joke'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No joke found'));
                  } else {
                    return Center(
                      child: IntrinsicHeight(
                        child: CustomCard(joke: snapshot.data!),
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
