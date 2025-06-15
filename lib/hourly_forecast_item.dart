import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String temperture;
  final IconData icon;
  final String time;
  const HourlyForecastItem({
    super.key,
    required this.icon,
    required this.temperture,
    required this.time,
    });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 8
            ),
            Icon(
              icon,
              size: 32
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              temperture,
            ),
          ],
        ),
      ),
    );
  }
}