import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/api_services.dart';

const Color darkViolet = Color(0xFF4B0082); // Custom dark violet color
const Color lightViolet = Color(0xFFE6E6FA); // Custom light violet color
const Color evenLighterOffWhitePeach = Color(0xFFFFFBF0); // Custom even lighter off-white peach color

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
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: darkViolet,
                  width: 2.0,
                ),
              ),
            ),
            child: AppBar(
              title: Text(
                'Random Joke',
                style: TextStyle(
                  color: darkViolet, // Custom dark violet for title text
                ),
              ),
              centerTitle: true, // Center the title
              backgroundColor: lightViolet, // Custom light violet for AppBar background
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, color: darkViolet),
                  onPressed: refreshJoke, // Refresh only the joke text
                ),
              ],
              elevation: 0, // Remove default AppBar shadow
            ),
          ),
          Expanded(
            child: Container(
              color: evenLighterOffWhitePeach, // Set even lighter off-white peach background color for the body
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
                    Joke joke = snapshot.data!;
                    return Center(
                      child: IntrinsicHeight(
                        child: Card(
                          color: lightViolet, // Custom light violet for card background
                          elevation: 0, // Remove shadow from card
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
                                    color: darkViolet, // Custom dark violet for question text
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  joke.punchline,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold, // Bold for punchline
                                    color: darkViolet, // Custom dark violet for punchline text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
