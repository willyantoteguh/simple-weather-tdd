import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:myweather/data/constants.dart';
import 'package:myweather/data/datasources/remote_data_source.dart';
import 'package:myweather/data/exception.dart';
import 'package:myweather/data/models/weather_model.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late RemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl = RemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get current weather', () {
    const tCityName = 'Surabaya';
    final tWeatherModel = WeatherModel.fromJson(json.decode(readJson('helpers/dummy_data/dummy_weather_response.json')));

    test('should return weather model then response code is 200', () async {
      //// arrange
      when(
        mockHttpClient.get(Uri.parse(Urls.currentWeatherByCity(tCityName))),
      ).thenAnswer((_) async => http.Response(readJson('helpers/dummy_data/dummy_weather_response.json'), 200));

      //// act
      final result = await remoteDataSourceImpl.getCurrentWeather(tCityName);

      // assert
      expect(result, equals(tWeatherModel));
    });

    test('should throw a server exception when the response code is 404 or other', () async {
      // when
      when(mockHttpClient.get(Uri.parse(Urls.currentWeatherByCity(tCityName)))).thenAnswer((_) async => http.Response('Not found', 404));

      // act
      final call = remoteDataSourceImpl.getCurrentWeather(tCityName);

      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
