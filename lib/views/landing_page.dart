import 'package:flutter/material.dart';
import 'package:ha_mobile_application/views/location_corn_page.dart';
import 'package:ha_mobile_application/views/location_soybean_page.dart';
import 'package:ha_mobile_application/views/login_page.dart';
import 'package:ha_mobile_application/views/set_cost_permile.dart';
import '../models/staticvalues.dart';

/// The `LandingPage` widget is the main landing page after a user logs in.
/// It allows users to choose between Corn and Soybean products.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

/// The `_LandingPageState` manages the state for the `LandingPage` widget.
class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 105, 57),
        foregroundColor: Colors.white,
        title: const Text('Hurley & Associates'),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 23, 105, 57),
            ),
            child: Text('Main Menu'),
          ),
          ListTile(
            title: const Text('Set Cost per Mile'),
            tileColor: Colors.blue,
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SetCostPerMile()),
              );
            },
          ),
          ListTile(
            title: const Text('Calculate Cost per Mile'),
            tileColor: Colors.blueGrey,
            textColor: Colors.white,
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout'),
            tileColor: Colors.red,
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) =>
                      false); //it removes all of the routes except for the new /login route I pushed.
            },
          )
        ],
      )),
      body: Stack(
        children: [
          // Background image for the landing page.
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
          // Centered product choice buttons.
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  top:
                      100), // Adjust the top padding to move the buttons up or down.
              child: ProductChoice(),
            ),
          ),
          // Logout button positioned at the bottom right.
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20, bottom: 20),
              child: LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}

/// The `ProductChoice` widget provides buttons for the user to select either "Corn" or "SoyBean".
class ProductChoice extends StatelessWidget {
  const ProductChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Button for selecting Corn.
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 23, 105, 57)),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            minimumSize: WidgetStateProperty.all<Size>(
                const Size(150, 50)), // Increase button size.
          ),
          onPressed: () {
            // Setting the product ID for Corn.
            Staticvalues.ProductId =
                Staticvalues.cornProdID; //Corn Product ID set in static class
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LocationCornPage()));
          },
          child: const Text('Corn'),
        ),
        const SizedBox(height: 25),
        // Button for selecting SoyBean.
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 23, 105, 57)),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            minimumSize: WidgetStateProperty.all<Size>(
                const Size(150, 50)), // Increase button size.
          ),
          onPressed: () {
            // Setting the product ID for SoyBean.
            Staticvalues.ProductId = Staticvalues
                .soybeanProdID; //Soybean Product ID set in static class
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LocationSoybeanPage()));
          },
          child: const Text('Soybean'),
        ),
      ],
    );
  }
}

/// The `LogoutButton` widget provides a button to logout and navigate back to the login page.
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        minimumSize: WidgetStateProperty.all<Size>(
            const Size(50, 25)), // Increase button size.
      ),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) =>
                false); //it removes all of the routes except for the new /login route I pushed.
      },
      child: const Text('Logout'),
    );
  }
}
