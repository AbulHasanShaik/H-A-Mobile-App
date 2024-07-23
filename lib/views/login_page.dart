import 'package:flutter/material.dart';
import 'package:ha_mobile_application/models/apiclient.dart';
import 'package:ha_mobile_application/views/landing_page.dart';

/// The `LoginPage` widget provides a login interface for users to enter their credentials.
/// Upon successful login, it navigates to the `LandingPage`.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// The `_LoginPageState` manages the state for the `LoginPage` widget.
/// It includes logic for form validation and handling user inputs.
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Gesturecontrol to take the keyboard away when the anyothe rpart of the screenis touched
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 23, 105, 57),
          foregroundColor: Colors.white,
          title: const Center(child: Text('Hurley & Associates')),
        ),
        body: Stack(
          children: [
            // Background image for the login screen.
            Positioned.fill(
              child: Semantics(
                image: true,
                label: 'A beautiful corn field',
                child: Image.asset(
                  'assets/sunset.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Login form overlay.
            // _buildLoginForm(),
            Align(
              alignment: Alignment.bottomCenter,
              child: _LoginFields(),
            )
          ],
        ),
      ),
    );
  }
}

class _LoginFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyloginState>();
    String userName = "";
    String password = "";

    var api = ApiClient();

    void login() async {
      var rtn = await api.login(userName, password);
      if (rtn.length > 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LandingPage(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Incorrect username or password'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email input field.
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Username',
              hintText: 'Enter your username',
              labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onChanged: (text) {
              userName = text;
            },
          ),
          const SizedBox(height: 15),
          // Password input field.
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Password',
              hintText: 'Enter the password here',
              labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onChanged: (text) {
              password = text;
            },
          ),
          const SizedBox(height: 20),
          // Submit button.
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
            ),
            onPressed: () {
              login();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
