import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:weather_clean_app/features/weather/data/datasources/weather_remote_data_source.dart';

import 'package:weather_clean_app/features/weather/data/repositories/weather_repository_impl.dart';

import 'package:weather_clean_app/features/weather/domain/repositories/weather_repository.dart';

import 'package:weather_clean_app/features/weather/domain/usecases/get_current_weather.dart';

import 'package:weather_clean_app/features/weather/domain/usecases/get_location_weather.dart';

import 'package:weather_clean_app/features/weather/presentation/blocs/weather_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External - Remove GeolocatorPlatform registration
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Blocs
  sl.registerFactory(
    () => WeatherBloc(getCurrentWeather: sl(), getLocationWeather: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => GetLocationWeather(sl()));

  // Repository - Remove geolocator parameter
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );
}
