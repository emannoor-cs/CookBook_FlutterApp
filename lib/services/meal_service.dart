import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart'; // for Recipe model

class MealService {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  // Search meals by name
  Future<List<Recipe>> searchMeals(String query) async {
    final url = query.isEmpty
        ? '$_base/search.php?s=' // returns all when empty
        : '$_base/search.php?s=$query';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List?;
      if (meals == null) return [];
      return meals.map((m) => _toRecipe(m)).toList();
    }
    throw Exception('Failed to fetch meals');
  }

  // Filter by category
  Future<List<Recipe>> getMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_base/filter.php?c=$category'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List?;
      if (meals == null) return [];
      // Filter endpoint only returns thumbnail + id, fetch details for each
      return Future.wait(
        meals.take(10).map((m) => _getMealById(m['idMeal'])),
      ).then((list) => list.whereType<Recipe>().toList());
    }
    throw Exception('Failed to fetch category meals');
  }

  Future<Recipe?> _getMealById(String id) async {
    final response = await http.get(
      Uri.parse('$_base/lookup.php?i=$id'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) return null;
      return _toRecipe(meals[0]);
    }
    return null;
  }

  // Convert TheMealDB JSON → your Recipe model
  Recipe _toRecipe(Map<String, dynamic> m) {
    // Extract ingredients (API has strIngredient1...strIngredient20)
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ing = m['strIngredient$i'];
      final measure = m['strMeasure$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        final qty = (measure != null && measure.toString().trim().isNotEmpty)
            ? '${measure.toString().trim()} '
            : '';
        ingredients.add('$qty${ing.toString().trim()}');
      }
    }

    return Recipe(
      title: m['strMeal'] ?? 'Unknown',
      category: m['strCategory'] ?? 'Other',
      cookTime: 30, // API doesn't provide time, use default
      rating: 4.0,  // API doesn't provide rating, use default
      difficulty: 'Medium',
      imageUrl: m['strMealThumb'] ?? '',
      ingredients: ingredients,
      description: (m['strInstructions'] ?? '')
          .toString()
          .split('.')
          .first
          .trim(), // First sentence as description
    );
  }
}