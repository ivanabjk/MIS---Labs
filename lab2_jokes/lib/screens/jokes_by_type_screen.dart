import 'package:flutter/material.dart';
import 'package:lab2_jokes/screens/random_joke_screen.dart';
import '../models/joke.dart';
import '../services/api_services.dart';
import '../widgets/jokes_appbar.dart';
import '../widgets/jokes_card.dart';

const Color evenLighterOffWhitePeach = Color(0xFFFFFBF0);

class JokesByTypeScreen extends StatelessWidget {
  final String type;
  final ApiService apiService = ApiService();

  JokesByTypeScreen({required this.type});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: '${capitalize(type)} Jokes',
            onCasinoPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomJokeScreen(),
                ),
              );
            },
          ),
          Expanded(
            child: Container(
              color: evenLighterOffWhitePeach,
              child: FutureBuilder<List<Joke>>(
                future: apiService.getJokesByType(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load jokes'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No jokes found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CustomCard(joke: snapshot.data![index]);
                      },
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
