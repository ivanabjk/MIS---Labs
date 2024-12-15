import 'package:flutter/material.dart';
import '../screens/random_joke_screen.dart';
import '../models/joke.dart';
import '../services/api_services.dart';

const Color darkViolet = Color(0xFF4B0082); // Custom dark violet color
const Color lightViolet = Color(0xFFE6E6FA); // Custom light violet color
const Color evenLighterOffWhitePeach = Color(0xFFFFFBF0); // Custom even lighter off-white peach color

class JokesByTypeScreen extends StatelessWidget {
  final String type;

  JokesByTypeScreen({required this.type});

  final ApiService apiService = ApiService();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
                '${capitalize(type)} Jokes',
                style: TextStyle(
                  color: darkViolet, // Custom dark violet for title text
                ),
              ),
              actions: [
                IconButton(
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
              ],
              centerTitle: true, // Center the title
              backgroundColor: lightViolet, // Custom light violet for AppBar background
              elevation: 0, // Remove default AppBar shadow
            ),
          ),
          Expanded(
            child: Container(
              color: evenLighterOffWhitePeach, // Set even lighter off-white peach background color for the body
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
                        Joke joke = snapshot.data![index];
                        return Card(
                          color: lightViolet, // Custom light violet for card background
                          //shadowColor: darkViolet, // Custom dark violet for card shadow
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
                                    color: darkViolet, // Custom dark violet for question text
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  joke.punchline,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold, // Bold for punchline
                                    color: darkViolet, // Custom dark violet for punchline text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
