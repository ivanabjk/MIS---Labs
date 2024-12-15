import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/home_appbar.dart';
import '../widgets/home_card.dart';
import 'jokes_by_type_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(onRefresh: fetchJokeTypes),
          Expanded(
            child: Container(
              color: offWhitePeach,
              child: jokeTypes.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: jokeTypes.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return CustomCard(
                    jokeType: jokeTypes[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              JokesByTypeScreen(type: jokeTypes[index]),
                        ),
                      );
                    },
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
