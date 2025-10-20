// lib/features/weather/data/datasources/weather_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<WeatherModel> getCurrentWeatherByPosition(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;
  static const String _baseUrl = 'api.openweathermap.org';
  static const String _apiKey =
      '47f6f5ef7983b49070e05128c06b1432'; // Get from https://openweathermap.org/

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final url = Uri.https(_baseUrl, '/data/2.5/weather', {
      'q': cityName,
      'units': 'metric',
      'appid': _apiKey,
    });

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return WeatherModel.fromJson(jsonResponse);
    } else if (response.statusCode == 404) {
      throw ServerException('City "$cityName" not found');
    } else if (response.statusCode == 401) {
      throw ServerException(
        'Invalid API key. Please check your OpenWeatherMap API key.',
      );
    } else if (response.statusCode == 429) {
      throw ServerException('API rate limit exceeded. Please try again later.');
    } else {
      throw ServerException(
        'Failed to load weather data: ${response.statusCode}',
      );
    }
  }

  @override
  Future<WeatherModel> getCurrentWeatherByPosition(
    double lat,
    double lon,
  ) async {
    final url = Uri.https(_baseUrl, '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': 'metric',
      'appid': _apiKey,
    });

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return WeatherModel.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      throw ServerException('Invalid location coordinates');
    } else if (response.statusCode == 401) {
      throw ServerException(
        'Invalid API key. Please check your OpenWeatherMap API key.',
      );
    } else if (response.statusCode == 429) {
      throw ServerException('API rate limit exceeded. Please try again later.');
    } else {
      throw ServerException(
        'Failed to load weather data: ${response.statusCode}',
      );
    }
  }
}
