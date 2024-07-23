import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ha_mobile_application/views/login_page.dart';

/// The `SplashScreen` widget serves as the initial screen of the application.
/// It displays a splash image and transitions to the login page after a delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// The `_SplashScreenState` manages the state for `SplashScreen`.
/// It handles the UI logic and transition to the next screen.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    // Sets the system UI to immersive mode, hiding system bars for full-screen experience.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigates to the login page after a 5-second delay.
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main content of the splash screen.
      body: Container(
        width: double.infinity,  // Makes the container take up the full width of the screen.
        decoration: const BoxDecoration(
          // Applies a linear gradient background to the container.
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 23, 105, 57), Color.fromARGB(255, 23, 105, 57)],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centers the child widgets vertically.
          children: [
            Center(
              // Displays the splash image in the center of the screen.
              child: ImageIcon(
                AssetImage("assets/splash.png"),
                size: 700,
                color: Colors.white
              ),
            ),
            SizedBox(height: 20),  // Adds vertical space below the image.
          ],
        ),
      ),
    );
  }
}
