import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ha_mobile_application/models/basis.dart';
import 'package:ha_mobile_application/views/landing_page.dart';
import 'package:ha_mobile_application/models/staticvalues.dart';
import '../models/http_helper.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPage();
}

class _ResultsPage extends State<ResultsPage> {
  late Future<List<Basis>> _basisListFuture;
  int _selectedButtonIndex = -1;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButtonIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _basisListFuture = calcCashPriceAfterDel();
  }

  Future<List<Basis>> calcCashPriceAfterDel() async {
    if (Staticvalues.centsPerMilePrice == '') {
      Staticvalues.centsPerMilePrice = '0.005';
    }

    List<Basis> baseList = await callBasisInfo();
    for (Basis item in baseList) {
      double costAfterDeliveryCharges = item.cashprice -
          (double.parse(Staticvalues.centsPerMilePrice) * item.distance);
      item.estCashPriceAfterDel = costAfterDeliveryCharges;
    }
    return baseList;
  }

  Future<List<Basis>> sortByEstPrice() async {
    List<Basis> basisList = await calcCashPriceAfterDel();
    basisList.sort(
        (a, b) => a.estCashPriceAfterDel.compareTo(b.estCashPriceAfterDel));
    return basisList;
  }

  Future<List<Basis>> sortByDistance() async {
    List<Basis> basisList = await calcCashPriceAfterDel();
    basisList.sort((a, b) => a.distance.compareTo(b.distance));
    return basisList;
  }

  Future<List<Basis>> callBasisInfo() async {
    HttpHelper helper = HttpHelper(); // Creating HttpHelper instance
    List<Basis> basisInfos =
        await helper.getBasisList(); // Fetching Basis data using HttpHelper
    return basisInfos; // Returning fetched Basis data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Setting background color of the page
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 105, 57),
        foregroundColor: Colors.white,
        title: const Text('Basis Locations'),
      ),
      body: Stack(children: [
        FutureBuilder<List<Basis>>(
          future: _basisListFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Basis>> snapshot) {
            if (snapshot.hasError) {
              // Checking if there's an error in fetching data
              return const Center(
                child: Text(
                  'Try a different zipcode!',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ), // Displaying error message
              );
            }

            if (!snapshot.hasData) {
              // Checking if data is still loading
              return const Center(
                  child:
                      CircularProgressIndicator()); // Showing a loading indicator
            }

            return ListView.builder(
              itemCount: snapshot.data?.length ??
                  0, // Setting number of list items based on fetched data
              itemBuilder: (BuildContext context, int position) {
                final item =
                    snapshot.data![position]; // Getting current Basis object
                String postingDateString = item.posting_date;
                DateTime postingDate =
                    DateTime.parse(postingDateString); // Formatting DateTime
                String formatDateTime = DateFormat('MM/dd/yyyy')
                    .format(postingDate); // Formatting DateTime
                // calcCashPriceAfterDel();
                // sortByEstPrice();
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0), // Setting margin for Card
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(
                        16.0), // Adding padding inside ListTile
                    title: Text(
                      item.full_name, // Displaying Basis full name
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Product: ${item.product_name}\nBasis Price: \$(${item.price.toStringAsFixed(2)}) \nFutures: \$${item.futuresprice.toStringAsFixed(2)} \nCash Price: \$${item.cashprice.toStringAsFixed(2)} \nFOB: \$${item.estCashPriceAfterDel.toStringAsFixed(2)} \nDistance: ${item.distance}mi \nPosting Date: $formatDateTime', // Displaying additional Basis information
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.place),
                      color: Colors.blue,
                      iconSize: 35,
                      onPressed: () {
                        setState(() {
                          MapsLauncher.launchCoordinates(
                              item.basisLatitude, item.basisLongitude);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 23, 105, 57),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all(
                      _selectedButtonIndex == 0
                          ? Colors.blueAccent
                          : Colors.black,
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(50, 25),
                    ),
                  ),
                  onPressed: () => {
                    setState(() {
                      _onButtonPressed(0);
                      _basisListFuture = sortByEstPrice();
                    })
                  },
                  child: const Text('Best FOB'),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      _selectedButtonIndex == 1
                          ? Colors.blueAccent
                          : Colors.black,
                    ),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    minimumSize:
                        WidgetStateProperty.all<Size>(const Size(50, 25)),
                  ),
                  onPressed: () {
                    setState(() {
                      _onButtonPressed(1);
                      _basisListFuture = sortByDistance();
                    });
                  },
                  child: const Text('Nearest Location'),
                ),
                const LogoutButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
