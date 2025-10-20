import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

class WeatherModel extends Equatable {
  final String locationName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final String description;
  final String iconCode;
  final double windSpeed;
  final int visibility;
  final DateTime lastUpdated;

  const WeatherModel({
    required this.locationName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.windSpeed,
    required this.visibility,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      locationName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      visibility: json['visibility'] as int,
      lastUpdated: DateTime.now(),
    );
  }

  Weather toEntity() {
    return Weather(
      locationName: locationName,
      temperature: temperature,
      feelsLike: feelsLike,
      humidity: humidity,
      pressure: pressure,
      description: description,
      iconCode: iconCode,
      windSpeed: windSpeed,
      visibility: visibility,
      lastUpdated: lastUpdated,
    );
  }

  @override
  List<Object> get props => [
    locationName,
    temperature,
    feelsLike,
    humidity,
    pressure,
    description,
    iconCode,
    windSpeed,
    visibility,
    lastUpdated,
  ];
}
