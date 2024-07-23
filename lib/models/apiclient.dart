import 'dart:convert';
import 'package:ha_mobile_application/models/staticvalues.dart';
import 'package:ha_mobile_application/models/userpreferences.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  String url = Staticvalues.baseurl + Staticvalues.apiAuthentication;

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        'UserName': username,
        'Password': password,
        'Secret': Staticvalues.secret,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var rsp = AuthenticateRequestAndResponse.fromJson(jsonDecode(response.body));
      UserPreferences.username = username;
      UserPreferences.apiKey = rsp.accessToken;
      UserPreferences.isAuthenticated = true;
      UserPreferences.keyExperation =
          DateTime.now().add(const Duration(minutes: 35));

      return rsp.accessToken;
    } else {
      UserPreferences.username = "";
      UserPreferences.apiKey = "";
      UserPreferences.isAuthenticated = false;
      UserPreferences.keyExperation = DateTime.now();
      return "";
    }
  }
}

class AuthenticateRequestAndResponse {
  final String accessToken;
//final String RefreshToken;

  const AuthenticateRequestAndResponse({
    required this.accessToken,
//required this.RefreshToken,
  });

// ignore: non_constant_identifier_names
  factory AuthenticateRequestAndResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticateRequestAndResponse(
      // RefreshToken: json['RefreshToken'],
      accessToken: json['accessToken'],
    );
  }
}
