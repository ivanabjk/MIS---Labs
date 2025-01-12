import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/joke.dart';

class ApiService {
  static const String baseUrl = 'https://official-joke-api.appspot.com';

  Future<List<String>> getJokeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));
    if (response.statusCode == 200) {
      List<String> types = List<String>.from(json.decode(response.body));
      return types;
    } else {
      throw Exception('Failed to load joke types');
    }
  }

  Future<List<Joke>> getJokesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/$type/ten'));
    if (response.statusCode == 200) {
      List<Joke> jokes = List<Joke>.from(
          json.decode(response.body).map((joke) => Joke.fromJson(joke)));
      return jokes;
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  Future<Joke> getRandomJoke() async {
    final response = await http.get(Uri.parse('$baseUrl/random_joke'));
    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load random joke');
    }
  }
}
