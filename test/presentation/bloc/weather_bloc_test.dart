import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myweather/data/failure.dart';
import 'package:myweather/domain/entities/weather.dart';
import 'package:myweather/domain/usecases/get_current_weather.dart';
import 'package:myweather/presentation/bloc/weather_bloc.dart';
import 'package:myweather/presentation/bloc/weather_event.dart';
import 'package:myweather/presentation/bloc/weather_state.dart';

import 'weather_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeather])
void main() {
  late MockGetCurrentWeather mockGetCurrentWeather;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeather();
    weatherBloc = WeatherBloc(mockGetCurrentWeather);
  });

  const tWeather = Weather(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);

  const tCityName = 'Surabaya';

  test('initial state should be empty', () {
    expect(weatherBloc.state, WeatherEmpty());
  });

  blocTest<WeatherBloc, WeatherState>('should emit [loading, has data] when data is gotten successfully',
      build: () {
        when(mockGetCurrentWeather.execute(tCityName)).thenAnswer((_) async => Right(tWeather));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(OnCityChanged(tCityName)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            WeatherLoading(),
            WeatherHasData(tWeather),
          ],
      verify: (bloc) => verify(mockGetCurrentWeather.execute(tCityName)));

  blocTest<WeatherBloc, WeatherState>('should emit [loading, error] when get data is unsuccessful',
      build: () {
        when(mockGetCurrentWeather.execute(tCityName)).thenAnswer((_) async => Left(ServerFailure('Server failure')));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(OnCityChanged(tCityName)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            WeatherLoading(),
            WeatherError('Server failure'),
          ],
      verify: (bloc) => verify(mockGetCurrentWeather.execute(tCityName)));
}
