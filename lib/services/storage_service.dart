import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite.dart';
import '../utils/constants.dart';

class StorageService extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkTheme = true;
  String _endpoint = AppConstants.defaultEndpoint;
  String _model = AppConstants.defaultModel;
  List<Favorite> _favorites = [];
  bool _onboardingCompleted = false;

  bool get isDarkTheme => _isDarkTheme;
  String get endpoint => _endpoint;
  String get model => _model;
  List<Favorite> get favorites => List.unmodifiable(_favorites);
  bool get onboardingCompleted => _onboardingCompleted;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkTheme = _prefs.getBool(AppConstants.themeKey) ?? true;
    _endpoint = _prefs.getString(AppConstants.endpointKey) ?? AppConstants.defaultEndpoint;
    _model = _prefs.getString(AppConstants.modelKey) ?? AppConstants.defaultModel;
    _onboardingCompleted = _prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;
    _loadFavorites();
    notifyListeners();
  }

  void _loadFavorites() {
    final raw = _prefs.getStringList(AppConstants.favoritesKey) ?? [];
    _favorites = raw.map((e) {
      try {
        return Favorite.fromJson(jsonDecode(e) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<Favorite>().toList();
  }

  Future<void> _saveFavorites() async {
    final raw = _favorites.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(AppConstants.favoritesKey, raw);
  }

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _prefs.setBool(AppConstants.themeKey, _isDarkTheme);
    notifyListeners();
  }

  Future<void> setEndpoint(String value) async {
    _endpoint = value;
    await _prefs.setString(AppConstants.endpointKey, value);
    notifyListeners();
  }

  Future<void> setModel(String value) async {
    _model = value;
    await _prefs.setString(AppConstants.modelKey, value);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    await _prefs.setBool(AppConstants.onboardingCompletedKey, true);
    notifyListeners();
  }

  Future<void> addFavorite(Favorite fav) async {
    _favorites.insert(0, fav);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((f) => f.id == id);
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorited(String id) {
    return _favorites.any((f) => f.id == id);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    _isDarkTheme = true;
    _endpoint = AppConstants.defaultEndpoint;
    _model = AppConstants.defaultModel;
    _favorites = [];
    _onboardingCompleted = false;
    notifyListeners();
  }
}
