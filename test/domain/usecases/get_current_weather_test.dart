import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myweather/domain/entities/weather.dart';
import 'package:myweather/domain/usecases/get_current_weather.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetCurrentWeather usecase;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeather(mockWeatherRepository);
  });

  const testWeatherDetail = Weather(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);

  const tCityName = 'Surabaya';

  test('should get current weather detail from the repository', () async {
    //arrange
    when(mockWeatherRepository.getCurrentWeather(tCityName)).thenAnswer((_) async => const Right(testWeatherDetail));

    //act
    final result = await usecase.execute(tCityName);

    //assert
    expect(result, equals(Right(testWeatherDetail)));
  });
}
