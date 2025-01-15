import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab4_student_calendar/pages/home_page.dart';
import 'package:lab4_student_calendar/pages/profile_page.dart';
import 'package:lab4_student_calendar/pages/register_page.dart';
import 'package:lab4_student_calendar/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Jokes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RegisterPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.deepPurple,
              width: 2.0,
            ),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: [
            const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            // NavigationDestination(
            //     icon: Badge(
            //         label: Text("$favoriteCount"),
            //         child: const Icon(Icons.favorite)),
            //     label: 'Favorites'),
            const NavigationDestination(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedIndex: currentPageIndex,
        ),
      ),
      body: [
        HomePage(),
        //FavoritesScreen(),
        const ProfilePage(),
      ][currentPageIndex],
    );
  }
}
