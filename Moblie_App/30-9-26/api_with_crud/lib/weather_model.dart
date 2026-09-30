class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDegree;
  final String description;
  final String icon;
  final String mainCondition;
  final int visibility;
  final int cloudiness;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.visibility,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: (json['wind']['deg'] ?? 0) as int,
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      mainCondition: json['weather'][0]['main'] ?? '',
      visibility: (json['visibility'] ?? 10000) as int,
      cloudiness: json['clouds']['all'] as int,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunrise'] as int) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunset'] as int) * 1000),
    );
  }

  /// Returns temperature in Celsius (API returns Kelvin by default; we request metric)
  String get tempString => '${temperature.round()}°C';
  String get feelsLikeString => '${feelsLike.round()}°C';
  String get tempMinString => '${tempMin.round()}°C';
  String get tempMaxString => '${tempMax.round()}°C';

  String get windSpeedString => '${windSpeed.round()} m/s';
  String get visibilityString => '${(visibility / 1000).toStringAsFixed(1)} km';

  String get sunriseString =>
      '${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}';
  String get sunsetString =>
      '${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}';

  /// Returns full icon URL for OpenWeatherMap icon
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
