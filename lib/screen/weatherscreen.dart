// ignore_for_file: file_names

import 'dart:convert';
import 'dart:ui';
import 'package:dynamic_weather_icons/dynamic_weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/ForecastItem/additionalitem.dart';
import 'package:weather_app/ForecastItem/hourlyforecastitem.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/ForecastItem/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Vellore";
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey"),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "An unexpected error occured";
      }

      return data;

      // temp = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    String getIconBasedOnCondition(String condition) {
      switch (condition) {
        case 'Clear':
          return "wi-day-sunny";
        case 'Clouds':
          return "wi-cloudy";
        case 'Rain':
          return "wi-rain";
        default:
          return "wi-na";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          final double currentTempKelvin = currentWeather['main']['temp'];
          final currentSky = currentWeather['weather'][0]['main'];
          final currentTempCelsius = (currentTempKelvin - 273.15);
          final String currentTempCelsiusinString =
              currentTempCelsius.toStringAsFixed(0);
          final currentHumidity = currentWeather['main']['humidity'];
          final currentPressure = currentWeather['main']['pressure'];
          final currentWindSpeed = currentWeather['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          children: [
                            Text(
                              "$currentTempCelsiusinString °C",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                            Icon(
                              WeatherIcon.getIcon(
                                  getIconBasedOnCondition(currentSky)),
                              size: 65,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      final time =
                          DateTime.parse(data['list'][i + 1]['dt_txt']);
                      final timeforday = int.parse(DateFormat.H().format(time));
                      return HourlyForecast(
                        time: DateFormat.j().format(time),
                        temperature:
                            "${(data['list'][i + 1]['main']['temp'] - 273.15).toInt()} °C",
                        icon: WeatherIcon.getIcon(
                          (timeforday > 18 || timeforday < 6) &&
                                  (data['list'][i + 1]['weather'][0]['main'] !=
                                          "Clouds" ||
                                      data['list'][i + 1]['weather'][0]
                                              ['main'] !=
                                          "Rain")
                              ? "wi-night-clear"
                              : getIconBasedOnCondition(
                                  data['list'][i + 1]['weather'][0]['main'],
                                ),
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon1: Icons.water_drop,
                      text1: "Humidity",
                      text2: currentHumidity.toString(),
                    ),
                    AdditionalInfo(
                      icon1: Icons.air,
                      text1: "Wind Speed",
                      text2: currentWindSpeed.toString(),
                    ),
                    AdditionalInfo(
                      icon1: Icons.beach_access_outlined,
                      text1: "Pressure",
                      text2: currentPressure.toString(),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
