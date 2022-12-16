import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myweather/presentation/bloc/weather_bloc.dart';
import 'package:myweather/presentation/pages/weather_page.dart';
import 'injection.dart' as d;

void main() {
  d.init();
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => d.locator<WeatherBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.yellow),
          home: WeatherPage(),
        ));
  }
}
