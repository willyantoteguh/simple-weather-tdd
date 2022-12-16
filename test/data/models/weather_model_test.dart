import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myweather/data/models/weather_model.dart';
import 'package:myweather/domain/entities/weather.dart';

import '../../helpers/json_reader.dart';

void main() {
  const tWeatherModel = WeatherModel(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);

  const tWeather = Weather(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);

  group('to entity', () {
    test('should be a subclass of weather entity', () async {
      final result = tWeatherModel.toEntity();
      expect(result, equals(tWeather));
    });
  });

  group('from json', () {
    test('should return a valid model from json', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(readJson('helpers/dummy_data/dummy_weather_response.json'));

      //act
      final result = WeatherModel.fromJson(jsonMap);

      //assert
      expect(result, equals(tWeatherModel));
    });
  });

  group('to json', () {
    test('should return a json map containing proper data', () async {
      //act
      final result = tWeatherModel.toJson();

      //assert
      final expectedJsonMap = {
        'weather': [
          {
            'main': 'Clouds',
            'description': 'few clouds',
            'icon': '01a',
          }
        ],
        'main': {
          'temperature': 203.11,
          'pressure': 1000,
          'humidity': 68,
        },
        'name': 'Surabaya',
      };

      expect(result, equals(expectedJsonMap));
    });
  });
}
