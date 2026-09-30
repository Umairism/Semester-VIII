import 'dart:convert';

import 'package:http/http.dart' as http;

class Meal {
  final String id;
  final String name;
  final String thumbnail;

  Meal({required this.id, required this.name, required this.thumbnail});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }
}

Future<List<Meal>> fetchMeals(String query) async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    if (jsonMap['meals'] == null) return [];
    List<dynamic> mealsJson = jsonMap['meals'];
    return mealsJson.map((json) => Meal.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load meals: ${response.statusCode}');
  }
}
