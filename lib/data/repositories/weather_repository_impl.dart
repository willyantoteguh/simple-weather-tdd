import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:myweather/data/datasources/remote_data_source.dart';
import 'package:myweather/data/exception.dart';
import 'package:myweather/domain/entities/weather.dart';
import 'package:myweather/data/failure.dart';
import 'package:myweather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    try {
      final result = await remoteDataSource.getCurrentWeather(cityName);

      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
