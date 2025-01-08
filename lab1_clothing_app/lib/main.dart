import 'package:flutter/material.dart';
import 'clothes.dart'; // Import the Clothes class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '211115'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  final List<Clothes> clothingItems = [
    Clothes(
      name: 'T-Shirt',
      imagePath: 'assets/tshirt.jfif',
      description: 'Comfortable T-Shirt',
      price: 19.99,
    ),
    Clothes(
      name: 'Jeans',
      imagePath: 'assets/jeans.jpg',
      description: 'Modern jeans',
      price: 49.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: clothingItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(clothingItems[index].imagePath),
              title: Text(clothingItems[index].name),
              subtitle: Text('\$${clothingItems[index].price}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(item: clothingItems[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final Clothes item;

  DetailsScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(item.imagePath),
            SizedBox(height: 16),
            Text(
              item.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(item.description),
            SizedBox(height: 8),
            Text('\$${item.price}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
