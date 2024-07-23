import 'package:flutter/material.dart';
import 'package:ha_mobile_application/views/landing_page.dart';
import 'package:ha_mobile_application/models/staticvalues.dart';
import 'package:ha_mobile_application/views/results_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

/// The LocationCornPage widget provides an interface for users to enter a zipcode
/// and choose between "Spot" or "New" options. It uses several custom widgets to achieve this.
class LocationCornPage extends StatefulWidget {
  const LocationCornPage({super.key});

  @override
  State<LocationCornPage> createState() => _LocationCornPageState();
}

/// The _LocationCornPageState manages the state for the LocationCornPage widget.
/// It includes logic for navigation and passing data between widgets.
class _LocationCornPageState extends State<LocationCornPage> {
  // Global key to access the state of the GetZipcode  and 'GeoLocation' Widget.
  final GlobalKey<_GetZipcodeState> _getZipcodeKey =
      GlobalKey<_GetZipcodeState>();
  final GlobalKey<_GetGeoLocationState> _getGeoLocationKey =
      GlobalKey<_GetGeoLocationState>();
  final bool _isLocationEnabled = false;
  final bool _isZipcodeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 23, 105, 57),
          foregroundColor: Colors.white,
          title: const Text('Corn'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Go back',
          ),
        ),
        body: Stack(
          children: [
            // Background image for the page.
            Positioned.fill(
              child: Semantics(
                image: true,
                label: 'A beautiful corn field',
                child: Image.asset(
                  'assets/cornpic.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Logout button positioned at the bottom right.
            const Align(
              alignment: Alignment.bottomRight,
              child:
                  Padding(padding: EdgeInsets.all(20), child: LogoutButton()),
            ),
            // // Zipcode input field positioned at the top center.
            Align(
              alignment: Alignment.topCenter,
              child: _SwitchforZipcode(
                getZipcodeKey: _getZipcodeKey,
                getGeoLocationKey: _getGeoLocationKey,
                isLocationEnabled: _isLocationEnabled,
                isZipcodeEnabled: _isZipcodeEnabled,
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: GetGeoLocation(),
            ),
            // Buttons for selecting "Spot" or "New" positioned at the center.
            Align(
              alignment: Alignment.center,
              child: IsSpotOrNew(
                getZipcodeKey: _getZipcodeKey,
                getGeoLocationKey: _getGeoLocationKey,
                isLocationEnabled: _isLocationEnabled,
                isZipcodeEnabled: _isZipcodeEnabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchforZipcode extends StatefulWidget {
  final GlobalKey<_GetZipcodeState> getZipcodeKey;
  final GlobalKey<_GetGeoLocationState> getGeoLocationKey;
  final bool isLocationEnabled;
  final bool isZipcodeEnabled;

  const _SwitchforZipcode({
    required this.getZipcodeKey,
    required this.getGeoLocationKey,
    required this.isLocationEnabled,
    required this.isZipcodeEnabled,
  });
  @override
  State<_SwitchforZipcode> createState() => ___SwitchforZipcodeState();
}

class ___SwitchforZipcodeState extends State<_SwitchforZipcode> {
  bool isZipcodeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiteRollingSwitch(
          onTap: () {},
          onDoubleTap: () {},
          onSwipe: () {},
          value: isZipcodeEnabled,
          textOn: 'ZipCode',
          textOff: 'Zipcode',
          colorOn: Colors.green,
          colorOff: Colors.red,
          iconOn: Icons.location_on,
          iconOff: Icons.location_off,
          onChanged: (bool val) async {
            setState(() {
              isZipcodeEnabled = val;
            });
          },
        ),
        if (isZipcodeEnabled) GetZipcode(key: widget.getZipcodeKey),
      ],
    );
  }
}

/// The GetZipcode widget provides a text field for the user to input their zipcode.
class GetZipcode extends StatefulWidget {
  const GetZipcode({super.key});

  @override
  _GetZipcodeState createState() => _GetZipcodeState();
}

/// The _GetZipcodeState manages the state for the GetZipcode widget.
/// It includes logic for form validation.
class _GetZipcodeState extends State<GetZipcode> {
  // Key to manage and validate the form.
  final _formKey = GlobalKey<FormState>();

  // Controller to manage the text input for the zipcode field.
  final TextEditingController _zipcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            // Zipcode input field.
            TextFormField(
                controller: _zipcodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Zipcode',
                  hintText: 'Enter the zipcode here',
                  labelStyle: TextStyle(fontSize: 30, color: Colors.black),
                ),
                validator: (enteredZipcode) {
                  if (enteredZipcode!.isEmpty) {
                    return 'Enter a zipcode here';
                  }
                  final number = int.tryParse(enteredZipcode);
                  if (number == null) {
                    return 'Enter a valid zipcode';
                  }
                  if (number.isNegative) {
                    return 'Enter a non-negative number';
                  } else {
                    return null;
                  }
                }),
            const SizedBox(height: 20),
          ],
        ));
  }
}

class GetGeoLocation extends StatefulWidget {
  const GetGeoLocation({super.key});

  @override
  _GetGeoLocationState createState() => _GetGeoLocationState();
}

class _GetGeoLocationState extends State<GetGeoLocation> {
  String lat = '';
  String long = '';
  bool _isLoading = false;
  bool _isLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiteRollingSwitch(
          onTap: () {},
          onDoubleTap: () {},
          onSwipe: () {},
          value: _isLocationEnabled,
          textOn: 'Live Location',
          textOff: 'Live Location',
          colorOn: Colors.green,
          colorOff: Colors.red,
          iconOn: Icons.location_on,
          iconOff: Icons.location_off,
          onChanged: (bool val) async {
            setState(() {
              _isLoading = true;
            });
            if (val) {
              try {
                Position myPos = await getPosition();
                setState(() {
                  lat = myPos.latitude.toString();
                  long = myPos.longitude.toString();
                  Staticvalues.latitude = lat;
                  Staticvalues.longitude = long;
                });
              } catch (e) {
                print('Failed to get location: $e');
                // Handle the error accordingly
              }
            } else {
              setState(() {
                lat = '';
                long = '';
                Staticvalues.latitude = lat;
                Staticvalues.longitude = long;
              });
            }
            setState(() {
              _isLoading = false;
              _isLocationEnabled = val;
              Staticvalues.locationSwitch = val;
            });
          },
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device
    return await Geolocator.getCurrentPosition();
  }
}

/// The IsSpotOrNew widget provides buttons for the user to select either "Spot" or "New" option.
class IsSpotOrNew extends StatelessWidget {
  final GlobalKey<_GetZipcodeState> getZipcodeKey;
  final GlobalKey<_GetGeoLocationState> getGeoLocationKey;
  final bool isLocationEnabled;
  final bool isZipcodeEnabled;

  const IsSpotOrNew({
    required this.getZipcodeKey,
    required this.getGeoLocationKey,
    required this.isLocationEnabled,
    required this.isZipcodeEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 23, 105, 57)),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            minimumSize: WidgetStateProperty.all<Size>(
                const Size(150, 50)), // Increase button size
          ),
          onPressed: () {
            Staticvalues.is_spot = true;
            if ((getZipcodeKey
                    .currentState?._zipcodeController.text.isNotEmpty ??
                false)) {
              Staticvalues.latitude = '';
              Staticvalues.longitude = '';
              Staticvalues.Zip =
                  getZipcodeKey.currentState!._zipcodeController.text;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResultsPage()));
            } else if (Staticvalues.locationSwitch == true) {
              Staticvalues.Zip = '';
              // Staticvalues.locationSwitch = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResultsPage()));
            } else if ((getZipcodeKey
                        .currentState?._zipcodeController.text.isNotEmpty ??
                    false) &&
                (Staticvalues.locationSwitch == false)) {
              _showAlert(context);
            } else {
              _showAlert(context);
            }
          },
          child: const Text('Spot'),
        ),
        const SizedBox(height: 25),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 23, 105, 57)),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            minimumSize: WidgetStateProperty.all<Size>(
                const Size(150, 50)), // Increase button size
          ),
          onPressed: () {
            Staticvalues.is_spot = false;
            if ((getZipcodeKey
                    .currentState?._zipcodeController.text.isNotEmpty ??
                false)) {
              Staticvalues.latitude = '';
              Staticvalues.longitude = '';
              Staticvalues.Zip =
                  getZipcodeKey.currentState!._zipcodeController.text;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResultsPage()));
            } else if (Staticvalues.locationSwitch == true) {
              Staticvalues.Zip = '';
              // Staticvalues.locationSwitch = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ResultsPage()));
            } else if ((getZipcodeKey
                        .currentState?._zipcodeController.text.isNotEmpty ??
                    false) &&
                (Staticvalues.locationSwitch == false)) {
              _showAlert(context);
            } else {
              _showAlert(context);
            }
          },
          child: const Text('New Crop'),
        ),
      ],
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Attention'),
            content: const Text(
                'Please enable and enter Zipcode, or enable Live Location switch.'),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
}
