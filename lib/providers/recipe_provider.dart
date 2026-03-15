import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import '../services/meal_service.dart';

class RecipeProvider with ChangeNotifier {
  final MealService _service = MealService();

  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedCategory = 'All';

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;

  RecipeProvider() {
    loadFavorites();
    fetchMeals();
  }

  Future<void> fetchMeals({String query = ''}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      _recipes = await _service.searchMeals(query);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchByCategory(String category) async {
    _selectedCategory = category;
    if (category == 'All') {
      fetchMeals();
      return;
    }
    _isLoading = true;
    _error = '';
    notifyListeners();
    try {
      _recipes = await _service.getMealsByCategory(category);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // ── Favorites ──────────────────────────

  void toggleFavorite(Recipe recipe) {
    final exists = _favorites.any((r) => r.title == recipe.title);
    if (exists) {
      _favorites.removeWhere((r) => r.title == recipe.title);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
    _saveFavorites();
  }

  bool isFavorite(Recipe recipe) =>
      _favorites.any((r) => r.title == recipe.title);

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(
      _favorites.map((r) => {
        'title': r.title,
        'category': r.category,
        'cookTime': r.cookTime,
        'rating': r.rating,
        'difficulty': r.difficulty,
        'imageUrl': r.imageUrl,
        'ingredients': r.ingredients,
        'description': r.description,
      }).toList(),
    );
    await prefs.setString('favorites', encoded);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('favorites');
    if (encoded != null) {
      final List list = json.decode(encoded);
      _favorites = list.map((m) => Recipe(
        title: m['title'],
        category: m['category'],
        cookTime: m['cookTime'],
        rating: (m['rating'] as num).toDouble(),
        difficulty: m['difficulty'],
        imageUrl: m['imageUrl'],
        ingredients: List<String>.from(m['ingredients']),
        description: m['description'],
      )).toList();
      notifyListeners();
    }
  }
}