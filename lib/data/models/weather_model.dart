import 'package:equatable/equatable.dart';
import 'package:myweather/domain/entities/weather.dart';

class WeatherModel extends Equatable {
  final String cityName;
  final String main;
  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;

  const WeatherModel({required this.cityName, required this.main, required this.description, required this.iconCode, required this.temperature, required this.pressure, required this.humidity});

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
      cityName: json['name'],
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      temperature: json['main']['temp'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity']);

  Map<String, dynamic> toJson() => {
        'weather': [
          {
            'main': main,
            'description': description,
            'icon': iconCode,
          }
        ],
        'main': {
          'temperature': temperature,
          'pressure': pressure,
          'humidity': humidity,
        },
        'name': 'Surabaya'
      };

  Weather toEntity() => Weather(cityName: cityName, main: main, description: description, iconCode: iconCode, temperature: temperature, pressure: pressure, humidity: humidity);

  @override
  // TODO: implement props
  List<Object?> get props => [cityName, main, description, iconCode, temperature, pressure, humidity];
}
