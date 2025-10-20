import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/weather_bloc.dart';
import '../widgets/weather_content.dart';
import '../widgets/weather_search.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background that changes based on weather/time
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.lightBlue.shade400,
              Colors.blue.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Animated AppBar
                _buildAnimatedAppBar(context),
                const SizedBox(height: 20),

                // Search with animation
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: WeatherSearch(),
                ),
                const SizedBox(height: 30),

                // Main content with smooth transitions
                Expanded(
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: _buildStateContent(state, context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Floating Action Button for location
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildAnimatedAppBar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // App icon with animation
          Hero(
            tag: 'weather_icon',
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wb_sunny, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),

          // App title with gradient
          Expanded(
            child: Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.7)],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 0)),
              ),
            ),
          ),

          // Location button with pulse animation
          _buildPulseLocationButton(context),
        ],
      ),
    );
  }

  Widget _buildPulseLocationButton(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.my_location, color: Colors.white),
              onPressed: () {
                BlocProvider.of<WeatherBloc>(
                  context,
                ).add(FetchWeatherByLocation());
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStateContent(WeatherState state, BuildContext context) {
    switch (state.runtimeType) {
      case WeatherInitial:
        return _buildInitialState();
      case WeatherLoading:
        return _buildLoadingState();
      case WeatherLoaded:
        return WeatherContent(weather: (state as WeatherLoaded).weather);
      case WeatherError:
        return _buildErrorState(
          state as WeatherError,
          context,
        ); // Pass context here
      default:
        return const SizedBox();
    }
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated sun icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),

          // Welcome text with typing animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: 1.0,
            child: Column(
              children: [
                Text(
                  'Welcome to Weather',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Search for a city or use your current location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsing loading animation using AnimationController replacement
          _buildPulsingLoadingAnimation(),
          const SizedBox(height: 20),

          // Loading text with fade animation
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: Text(
              'Fetching weather data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Replace the problematic TweenAnimationBuilder with this
  Widget _buildPulsingLoadingAnimation() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            );
          },
          onEnd: () {
            // This creates the pulsing effect by rebuilding with reversed values
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                setState(() {});
              }
            });
          },
        );
      },
    );
  }

  // Updated to accept context parameter
  Widget _buildErrorState(WeatherError state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon with shake animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: -0.1, end: 0.1),
            duration: const Duration(milliseconds: 100),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value * 10, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Error message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Retry button - now context is available
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<WeatherBloc>(
                  context,
                ).add(FetchWeatherByLocation());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text('Try Again'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(bottom: 20, right: 20),
      child: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<WeatherBloc>(context).add(FetchWeatherByLocation());
        },
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        elevation: 8,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
