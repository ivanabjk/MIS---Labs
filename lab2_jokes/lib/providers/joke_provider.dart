import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/joke.dart';
import '../services/api_services.dart';

class JokeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<String> _jokeTypes = [];
  final List<Joke> _favoriteJokes = [];
  final Map<String, List<Joke>> _cachedJokesByType = {};

  Joke? _jokeOfTheDay = null;
  bool isFetching = false;

  bool _isObscure = true;
  File? _img;

  List<String> get jokeTypes => _jokeTypes;

  List<Joke> get favoriteJokes => _favoriteJokes;

  bool get isObscure => _isObscure;

  File? get image => _img;

  Joke? get jokeOfTheDay => _jokeOfTheDay;

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

  Future<void> fetchRandomJoke() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jokeData = prefs.getString('jokeOfTheDay');
    final String? jokeDate = prefs.getString('jokeDate');
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (jokeData != null && jokeDate == today) {
      _jokeOfTheDay = Joke.fromJson(json.decode(jokeData));
    } else{
      try {
        Joke joke = await _apiService.getRandomJoke();
        _jokeOfTheDay = joke;
        prefs.setString('jokeOfTheDay', json.encode(joke.toJson()));
        prefs.setString('jokeDate', today);
      } catch (e) {
        print('Failed to fetch random joke: $e');
      }
    }
    notifyListeners();
  }

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void toggleFavorite(Joke joke) {
    joke.isFavorite = !joke.isFavorite;
    if (joke.isFavorite) {
      _favoriteJokes.add(joke);
    } else {
      _favoriteJokes.removeWhere((element) => element.setup == joke.setup);
    }
    notifyListeners();
  }

  bool isFavorite(Joke joke) {
    return joke.isFavorite;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _img = File(pickedFile.path);
        print(_img!.path);
        notifyListeners();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage() async {
    if (_img == null) return;
    notifyListeners();
    try {
      String fileName = path.basename(_img!.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      await storageRef.putFile(_img!);
      String downloadUrl = await storageRef.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      notifyListeners();
    }
  }
}
