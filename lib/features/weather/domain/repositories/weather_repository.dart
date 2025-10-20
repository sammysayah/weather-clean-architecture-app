import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName);
  Future<Either<Failure, Weather>> getCurrentWeatherByLocation();
  Future<Either<Failure, List<Weather>>> getWeatherForecast(String cityName);
}
