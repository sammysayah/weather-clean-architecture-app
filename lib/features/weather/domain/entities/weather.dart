import 'package:equatable/equatable.dart';

class Weather extends Equatable {
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

  const Weather({
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
