import 'dart:async';

import 'package:dynamic_weather_icons/dynamic_weather_icons.dart';
import 'package:flutter/material.dart';

import 'package:weather_app/screen/weatherscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WeatherScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          size: 84,
          WeatherIcon.getIcon(
            "wi-day-cloudy",
          ),
        ),
      ),
    );
  }
}
