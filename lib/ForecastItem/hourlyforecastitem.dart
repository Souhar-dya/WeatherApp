import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyForecast({
    Key? key,
    required this.time,
    required this.temperature,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        width: 100,
        height: 250,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 42,
            ),
            const SizedBox(height: 20),
            Text(
              temperature,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
