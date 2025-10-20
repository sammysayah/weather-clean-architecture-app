import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_clean_app/core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_location_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetLocationWeather getLocationWeather;

  WeatherBloc({
    required this.getCurrentWeather,
    required this.getLocationWeather,
  }) : super(WeatherInitial()) {
    on<FetchWeatherByCity>(_onFetchWeatherByCity);
    on<FetchWeatherByLocation>(_onFetchWeatherByLocation);
  }

  Future<void> _onFetchWeatherByCity(
    FetchWeatherByCity event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    final failureOrWeather = await getCurrentWeather(event.cityName);

    failureOrWeather.fold(
      (failure) => emit(WeatherError(_mapFailureToMessage(failure))),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }

  Future<void> _onFetchWeatherByLocation(
    FetchWeatherByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    final failureOrWeather = await getLocationWeather(NoParams());

    failureOrWeather.fold(
      (failure) => emit(WeatherError(_mapFailureToMessage(failure))),
      (weather) => emit(WeatherLoaded(weather)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case LocationFailure:
        return 'Location error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
