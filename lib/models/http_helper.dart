import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ha_mobile_application/models/basis.dart';
import 'dart:convert';
import 'staticvalues.dart';

class HttpHelper {
  final String authority = 'WEBSERVICE URL'; // API base URL
  String path = '';

  void checkpath() {
    String checkzip = Staticvalues.Zip;
    String lat = Staticvalues.latitude;
    String long = Staticvalues.longitude;

    if (checkzip != '') {
      final String pathUsingZip =
          'BasisInfo/BasisZipcodeProduct?zipcode=${Staticvalues.Zip}&productID=${Staticvalues.ProductId}&is_spot=${Staticvalues.is_spot}';
      path = pathUsingZip;
    } else if (lat != '' && long != '') {
      // Staticvalues.latitude = '44.31136'; //Debugging Statements
      // Staticvalues.longitude = '-96.79839'; //Debugging Statements
      final String pathUsingLatandLong =
          'BasisInfo/BasisInfoByLogitudeAndLongitudeProduct?latitude=${Staticvalues.latitude}&longitude=${Staticvalues.longitude}&productID=${Staticvalues.ProductId}&is_spot=${Staticvalues.is_spot}';
      path = pathUsingLatandLong;
    }
  }

  // API endpoint path with query parameters using Staticvalues data

  Future<List<Basis>> getBasisList() async {
    checkpath(); //calling the checkpath function to get the correct path
    String fullpath = authority + path;
    final Uri url = Uri.parse(fullpath);
    final http.Response result =
        await http.get(url); // Making GET request to API
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body); // Parsing JSON response
      List<Basis> basisInfo = jsonResponse
          .map<Basis>((i) => Basis.fromJson(i))
          .toList(); // Mapping JSON to List of Basis objects
      return basisInfo; // Returning list of Basis objects
    } else {
      return []; // Returning empty list if request fails
    }
  }
}
