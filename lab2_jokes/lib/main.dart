import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:lab2_jokes/screens/login_screen.dart';
import 'package:lab2_jokes/screens/profile_screen.dart';
import 'package:lab2_jokes/screens/register_screen.dart';
import 'package:lab2_jokes/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'providers/joke_provider.dart';

//void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<JokeProvider>(
          create: (_) => JokeProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//
//   if (kIsWeb){
//     await Firebase.initializeApp(
//         options: FirebaseOptions(
//             apiKey: "AIzaSyBstNo_O5w2EXuPbtTpUH2o8Lz-JlxuFz0",
//             authDomain: "jokes-9cfe1.firebaseapp.com",
//             projectId: "jokes-9cfe1",
//             storageBucket: "jokes-9cfe1.firebasestorage.app",
//             messagingSenderId: "179887587323",
//             appId: "1:179887587323:web:f3e8789b88eaaf8dbe555e",
//             measurementId: "G-RJ5ZV6PT76")
//     );
//   } else{
//     await Firebase.initializeApp();
//   }
//
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JokeProvider(),
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
    final favoriteCount = context
        .watch<JokeProvider>()
        .favoriteJokes
        .where((p) => p.isFavorite)
        .length;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Badge(label: Text("$favoriteCount"), child: const Icon(Icons.favorite)),
              label: 'Favorites'),
          const NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedIndex: currentPageIndex,
      ),
      body: [
        HomeScreen(),
        FavoritesScreen(),
        const ProfilePage(),
      ][currentPageIndex],
    );
  }

}
