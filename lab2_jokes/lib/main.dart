import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab2_jokes/screens/profile_screen.dart';
import 'package:lab2_jokes/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'firebase_options.dart';
import 'providers/joke_provider.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';

//void main() => runApp(MyApp());

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  tz.initializeTimeZones();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    setupForegroundNotificationHandling();
    initializeLocalNotifications();
    showWelcomeNotification();
  }

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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Jokes',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: RegisterPage(),
  //   );
  // }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void setupForegroundNotificationHandling() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              channelDescription: 'your_channel_description',
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void initializeLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showWelcomeNotification() {
    flutterLocalNotificationsPlugin.show(
      0,
      'Welcome!',
      'Check out the new Joke of the Day!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'welcome_channel_id',
          'Welcome Notifications',
          channelDescription: 'Channel for welcome notifications',
          icon: 'launch_background',
        ),
      ),
    );
  }

// void initializeLocalNotifications() {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// void scheduleDailyNotification() {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'daily_notification_channel_id',
//     'Daily Notifications',
//     channelDescription: 'Channel for daily notifications',
//   );
//   var platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     'Joke of the Day',
//     'Check out the new joke of the day!',
//     _nextInstanceOfTenAM(),
//     platformChannelSpecifics,
//     //androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//     androidScheduleMode: AndroidScheduleMode.exact,
//   );
// }
//
// tz.TZDateTime _nextInstanceOfTenAM() {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduledDate =
//       tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
//   if (scheduledDate.isBefore(now)) {
//     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   }
//   return scheduledDate;
// }
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
    final favoriteCount = context
        .watch<JokeProvider>()
        .favoriteJokes
        .where((p) => p.isFavorite)
        .length;

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
            NavigationDestination(
                icon: Badge(
                    label: Text("$favoriteCount"),
                    child: const Icon(Icons.favorite)),
                label: 'Favorites'),
            const NavigationDestination(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedIndex: currentPageIndex,
        ),
      ),
      body: [
        HomeScreen(),
        FavoritesScreen(),
        const ProfilePage(),
      ][currentPageIndex],
    );
  }
}
