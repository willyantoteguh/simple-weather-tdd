import 'package:dartz/dartz.dart';
import 'package:myweather/data/failure.dart';
import 'package:myweather/domain/entities/weather.dart';
import 'package:myweather/domain/repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Either<Failure, Weather>> execute(String cityName) {
    return repository.getCurrentWeather(cityName);
  }
}
