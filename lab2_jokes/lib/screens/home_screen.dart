import 'package:flutter/material.dart';
import '../screens/random_joke_screen.dart';
import '../services/api_services.dart';
import 'jokes_by_type_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const Color lightViolet = Color(0xFFE6E6FA); // light violet
// const Color lightTeal = Color(0xFFB2DFDB); // Custom dark violet
// const Color teal = Color(0xFF006064);
const Color offWhitePeach = Color(0xFFFFFBF0);

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
  }

  void fetchJokeTypes() async {
    try {
      List<String> types = await apiService.getJokeTypes();
      setState(() {
        jokeTypes = types;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joke types refreshed')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh joke types')),
      );
    }
  }

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
                  color: Colors.deepPurple,
                  width: 2.0,
                ),
              ),
            ),
            child: AppBar(
              title: Text(
                'Joke Types',
                style: TextStyle(
                  color: Colors.deepPurple, // Custom darker teal for title text
                ),
              ),
              centerTitle: true, // Center the title
              backgroundColor: lightViolet, // Custom lighter teal for AppBar background
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
              leading: IconButton(
                icon: Icon(Icons.refresh, color: Colors.deepPurple),
                onPressed: fetchJokeTypes,
              ),
              elevation: 0, // Remove default AppBar shadow
            ),
          ),
          Expanded(
            child: Container(
              color: offWhitePeach, // Set even lighter off-white peach background color for the body
              child: jokeTypes.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of cards in a row
                  childAspectRatio: 3 / 2, // Aspect ratio of each card
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: jokeTypes.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return Card(
                    color: lightViolet, // Custom lighter teal for card background
                    shadowColor: Colors.deepPurple, // Custom darker teal for card shadow
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JokesByTypeScreen(type: jokeTypes[index]),
                          ),
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            capitalize(jokeTypes[index]),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple, // Custom darker teal for text
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
