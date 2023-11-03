import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screen/splashscreen.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final currentTimeinTime = int.parse(DateFormat.H().format(currentTime));
    final theme1 = currentTimeinTime > 12
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme1,
      home: const SplashScreen(),
    );
  }
}
