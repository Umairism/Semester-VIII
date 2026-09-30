import 'dart:convert';

import 'package:http/http.dart' as http;

import 'weather_model.dart';

class WeatherService {
  // 🔑 Free-tier API key — replace with your own from https://openweathermap.org/appid
  static const String _apiKey = 'ae24887d8ced427a1a21ec47b18d6c6f';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetch current weather by city name
  Future<WeatherModel> fetchWeatherByCity(String city) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('City "$city" not found. Please check the spelling.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please update the API key.');
      } else {
        throw Exception(
          'Failed to load weather (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  /// Fetch 5-day forecast by city name (returns list of WeatherModel)
  Future<List<WeatherModel>> fetchForecastByCity(String city) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric&cnt=5',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> list = json['list'] as List<dynamic>;
        return list
            .map(
              (item) => WeatherModel.fromJson({
                ...item as Map<String, dynamic>,
                'name': json['city']['name'],
                'sys': {
                  'country': json['city']['country'],
                  'sunrise': json['city']['sunrise'],
                  'sunset': json['city']['sunset'],
                },
              }),
            )
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('City "$city" not found.');
      } else {
        throw Exception(
          'Failed to load forecast (status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }
}
