import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/joke_provider.dart';
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

  @override
  void initState() {
    super.initState();
    Provider.of<JokeProvider>(context, listen: false).fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
              onRefresh: Provider.of<JokeProvider>(context, listen: false)
                  .fetchJokeTypes),
          Expanded(
            child: Container(
              color: offWhitePeach,
              child: Consumer<JokeProvider>(
                builder: (context, jokeProvider, child) {
                  return jokeProvider.jokeTypes.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: jokeProvider.jokeTypes.length,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            String jokeType = jokeProvider.jokeTypes[index];
                            return CustomCard(
                              jokeType: jokeProvider.jokeTypes[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JokesByTypeScreen(
                                        type: jokeType),
                                  ),
                                );
                              },
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
