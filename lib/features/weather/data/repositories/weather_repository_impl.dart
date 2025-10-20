import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    try {
      final weatherModel = await remoteDataSource.getCurrentWeather(cityName);
      return Right(weatherModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Weather>> getCurrentWeatherByLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(
          LocationFailure(
            'Location services are disabled. Please enable them.',
          ),
        );
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(LocationFailure('Location permissions are denied'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Left(
          LocationFailure(
            'Location permissions are permanently denied. Please enable them in app settings.',
          ),
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      final weatherModel = await remoteDataSource.getCurrentWeatherByPosition(
        position.latitude,
        position.longitude,
      );

      return Right(weatherModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('Failed to get location: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> getWeatherForecast(String cityName) {
    // TODO: Implement forecast functionality
    throw UnimplementedError();
  }
}
