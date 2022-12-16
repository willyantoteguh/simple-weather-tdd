import 'package:dartz/dartz.dart';
import 'package:myweather/data/failure.dart';
import 'package:myweather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String city);
}
