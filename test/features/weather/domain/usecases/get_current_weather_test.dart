import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_clean_app/features/weather/domain/entities/weather.dart';
import 'package:weather_clean_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_clean_app/features/weather/domain/usecases/get_current_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeather usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeather(mockWeatherRepository);
  });

  const testCityName = 'London';
  final testWeather = Weather(
    locationName: 'London',
    temperature: 15.0,
    feelsLike: 14.0,
    humidity: 65,
    pressure: 1013,
    description: 'clear sky',
    iconCode: '01d',
    windSpeed: 3.6,
    visibility: 10000,
    lastUpdated: DateTime(2024, 1, 1, 12, 0),
  );

  test('should get weather for a city from the repository', () async {
    // arrange
    when(
      mockWeatherRepository.getCurrentWeather(testCityName),
    ).thenAnswer((_) async => Right(testWeather));

    // act
    final result = await usecase(testCityName);

    // assert
    expect(result, Right(testWeather));
    verify(mockWeatherRepository.getCurrentWeather(testCityName));
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
