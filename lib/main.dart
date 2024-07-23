import 'package:flutter/material.dart';
import 'package:ha_mobile_application/views/splash_screen.dart';

void main() => runApp(const HAapp());

class HAapp extends StatelessWidget {
  const HAapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hurley & Associates', // Title displayed on the app bar
        // Define the root widget of the app
        theme: ThemeData(
          // Define the overall theme of the app
          primarySwatch: Colors.green, // Set the primary color swatch
        ),
        home: const SplashScreen());
  }
}
