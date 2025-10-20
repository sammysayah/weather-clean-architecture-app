import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather.dart';
import 'weather_animation.dart';

class WeatherContent extends StatelessWidget {
  final Weather weather;

  const WeatherContent({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Location and date with animation
          _buildLocationHeader(),
          const SizedBox(height: 20),

          // Weather animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: WeatherAnimation(iconCode: weather.iconCode),
          ),
          const SizedBox(height: 10),

          // Temperature with scale animation
          _buildTemperatureSection(),
          const SizedBox(height: 10),

          // Weather description
          _buildDescriptionSection(),
          const SizedBox(height: 30),

          // Weather details grid
          _buildWeatherDetails(),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: Column(
        children: [
          Text(
            weather.locationName,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 10, color: Colors.black.withOpacity(0.3)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('EEEE, MMM d • h:mm a').format(weather.lastUpdated),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + value * 0.5,
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                Text(
                  '${weather.temperature.round()}°',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionSection() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: 1.0,
      child: Column(
        children: [
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              letterSpacing: 1.5,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 900),
      opacity: 1.0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              'WEATHER DETAILS',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            _buildDetailGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    final details = [
      _buildDetailItem(
        'Humidity',
        '${weather.humidity}%',
        Icons.water_drop,
        Colors.blue,
      ),
      _buildDetailItem(
        'Wind',
        '${weather.windSpeed} m/s',
        Icons.air,
        Colors.green,
      ),
      _buildDetailItem(
        'Pressure',
        '${weather.pressure} hPa',
        Icons.compress,
        Colors.orange,
      ),
      _buildDetailItem(
        'Visibility',
        '${weather.visibility ~/ 1000} km',
        Icons.visibility,
        Colors.purple,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      children: details,
    );
  }

  Widget _buildDetailItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.all(4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
