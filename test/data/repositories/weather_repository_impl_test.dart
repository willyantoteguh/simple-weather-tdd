import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myweather/data/exception.dart';
import 'package:myweather/data/failure.dart';
import 'package:myweather/data/models/weather_model.dart';
import 'package:myweather/data/repositories/weather_repository_impl.dart';
import 'package:myweather/domain/entities/weather.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late WeatherRepositoryImpl weatherRepositoryImpl;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    weatherRepositoryImpl = WeatherRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tWeatherModel = WeatherModel(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);
  const tWeather = Weather(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);

  group('get current weather', () {
    const tCityName = 'Surabaya';

    //// Mengembalikan current weather data saat request ke API sukses
    test('should return current weather when a call to data source is successful', () async {
      //// arrange
      when(mockRemoteDataSource.getCurrentWeather(tCityName)).thenAnswer((_) async => tWeatherModel);

      //// act
      final result = await weatherRepositoryImpl.getCurrentWeather(tCityName);

      //// assert
      verify(mockRemoteDataSource.getCurrentWeather(tCityName));
      expect(result, equals(Right(tWeather)));
    });

    //// Mengembalikan ServerFailure saat request ke API gagal
    test('should return server failure when a call to data source is unsuccessful', () async {
      //// arrange
      when(mockRemoteDataSource.getCurrentWeather(tCityName)).thenThrow(ServerException());

      //// act
      final result = await weatherRepositoryImpl.getCurrentWeather(tCityName);

      //// assert
      verify(mockRemoteDataSource.getCurrentWeather(tCityName));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    //// Mengembalikan ConnectionFailure saat tidak konek ke internet
    test('should return connection failure when the device has no internet', () async {
      //// arrange
      when(mockRemoteDataSource.getCurrentWeather(tCityName)).thenThrow(const SocketException('Failed to connect to the network'));

      //// act
      final result = await weatherRepositoryImpl.getCurrentWeather(tCityName);

      //// assert
      verify(mockRemoteDataSource.getCurrentWeather(tCityName));
      expect(result, equals(const Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
}
