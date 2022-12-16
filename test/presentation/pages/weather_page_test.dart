import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myweather/data/constants.dart';
import 'package:myweather/domain/entities/weather.dart';
import 'package:myweather/presentation/bloc/weather_bloc.dart';
import 'package:myweather/presentation/bloc/weather_event.dart';
import 'package:myweather/presentation/bloc/weather_state.dart';
import 'package:myweather/presentation/pages/weather_page.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState> implements WeatherBloc {}

class FakeWeatherState extends Fake implements WeatherState {}

class FakeWeatherEvent extends Fake implements WeatherEvent {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUpAll(() async {
    HttpOverrides.global = null;
    registerFallbackValue(FakeWeatherState());
    registerFallbackValue(FakeWeatherEvent());

    final d = GetIt.instance;
    d.registerFactory(() => MockWeatherBloc());
  });

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  const tWeather = Weather(cityName: 'Surabaya', main: 'Clouds', description: 'few clouds', iconCode: '01a', temperature: 203.11, pressure: 1000, humidity: 68);

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>.value(
      value: mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('text should trigger state to change from empty to loading', (WidgetTester widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

    // act
    await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
    await widgetTester.enterText(find.byType(TextField), 'Surabaya');
    await widgetTester.testTextInput.receiveAction(TextInputAction.done);
    await widgetTester.pumpAndSettle();

    //assert
    verify(() => mockWeatherBloc.add(OnCityChanged('Surabaya'))).called(1);
    expect(find.byType(TextField), equals(findsOneWidget));
  });

  testWidgets('should show progress indicator when state is loading', (WidgetTester widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

    // act
    await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));

    // assert
    expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
  });

  testWidgets('should show widget contain weather data when state is has data', (WidgetTester widgetTester) async {
    // arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherHasData(tWeather));

    // act
    await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
    await widgetTester.runAsync(() async {
      final HttpClient client = HttpClient();
      await client.getUrl(Uri.parse(Urls.weatherIcon('01a')));
    });
    await widgetTester.pumpAndSettle();

    // assert
    expect(find.byKey(const Key('weather_data')), equals(findsOneWidget));
  });
}
