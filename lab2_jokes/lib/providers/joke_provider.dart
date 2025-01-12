import 'package:flutter/material.dart';

import '../models/joke.dart';
import '../services/api_services.dart';

class JokeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<String> _jokeTypes = [];
  List<Joke> _favoriteJokes = [];
  Map<String, List<Joke>> _cachedJokesByType = {};

  List<String> get jokeTypes => _jokeTypes;

  List<Joke> get favoriteJokes => _favoriteJokes;

  JokeProvider() {
    fetchJokeTypes();
  }

  Future<void> fetchJokeTypes() async {
    try {
      List<String> types = await _apiService.getJokeTypes();
      _jokeTypes = types;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch joke types: $e');
    }
  }

  Future<List<Joke>> getJokesByType(String type) async {
    if (_cachedJokesByType.containsKey(type)) {
      return _cachedJokesByType[type]!;
    } else {
      List<Joke> jokes = await _apiService.getJokesByType(type);
      _cachedJokesByType[type] = jokes;
      notifyListeners();
      return jokes;
    }
  }

  void toggleFavorite(Joke joke) {
    joke.isFavorite = !joke.isFavorite;
    if (joke.isFavorite) {
      _favoriteJokes.add(joke);
    } else {
      _favoriteJokes.removeWhere((element) => element.setup == joke.setup);
    }
    // if (_favoriteJokes.contains(joke)) {
    //   _favoriteJokes.remove(joke);
    // } else {
    //   _favoriteJokes.add(joke);
    // }
    notifyListeners();
  }

  bool isFavorite(Joke joke) {
    return joke.isFavorite;
  }
}
