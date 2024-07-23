import 'package:flutter/material.dart';
import 'package:ha_mobile_application/models/staticvalues.dart';
import 'package:ha_mobile_application/views/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetCostPerMile extends StatefulWidget {
  const SetCostPerMile({super.key});

  @override
  State<SetCostPerMile> createState() => _SetCostPerMileState();
}

class _SetCostPerMileState extends State<SetCostPerMile> {
  double _currentSliderValue = 0.005;

  @override
  void initState() {
    super.initState();
    _loadSliderValue();
  }

  _loadSliderValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentSliderValue = (prefs.getDouble('sliderValue') ?? 0.005);
    });
  }

  _saveSliderValue(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sliderValue', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Set Cost per Mile'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Slider(
                value: _currentSliderValue,
                min: 0.005,
                max: 1.0,
                divisions: 199,
                label: (_currentSliderValue * 100).toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    Staticvalues.centsPerMilePrice = value.toString();
                    _saveSliderValue(value);
                  });
                },
              ),
              Text(
                'Cost per Mile: \$${_currentSliderValue.toStringAsFixed(3)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: SubmitBtn(),
          ),
        ],
      ),
    );
  }
}

class SubmitBtn extends StatefulWidget {
  const SubmitBtn({super.key});

  @override
  State<SubmitBtn> createState() => SubmitBtnState();
}

class SubmitBtnState extends State<SubmitBtn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          child: const Text('Submit'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LandingPage()));
          },
        ),
      ],
    );
  }
}
