import 'package:flutter/material.dart';

class WeatherAnimation extends StatelessWidget {
  final String iconCode;

  const WeatherAnimation({super.key, required this.iconCode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Image.network(
        'https://openweathermap.org/img/wn/$iconCode@4x.png',
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon();
        },
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(_getWeatherIcon(), size: 80, color: _getWeatherColor());
  }

  IconData _getWeatherIcon() {
    if (iconCode.contains('01')) return Icons.wb_sunny;
    if (iconCode.contains('02')) return Icons.wb_cloudy;
    if (iconCode.contains('03') || iconCode.contains('04')) return Icons.cloud;
    if (iconCode.contains('09') || iconCode.contains('10'))
      return Icons.beach_access;
    if (iconCode.contains('11')) return Icons.flash_on;
    if (iconCode.contains('13')) return Icons.ac_unit;
    if (iconCode.contains('50')) return Icons.blur_on;
    return Icons.wb_sunny;
  }

  Color _getWeatherColor() {
    if (iconCode.contains('01')) return Colors.orange;
    if (iconCode.contains('02')) return Colors.blueGrey;
    if (iconCode.contains('03') || iconCode.contains('04')) return Colors.grey;
    if (iconCode.contains('09') || iconCode.contains('10')) return Colors.blue;
    if (iconCode.contains('11')) return Colors.deepPurple;
    if (iconCode.contains('13')) return Colors.cyan;
    if (iconCode.contains('50')) return Colors.grey;
    return Colors.orange;
  }
}
