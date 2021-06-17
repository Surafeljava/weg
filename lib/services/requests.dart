import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weg/models/user.dart';
import 'package:weg/shared.dart';

class Requests {
  var client = http.Client();

  Future<List<User>> getAllActiveUsers() async {
    List<User> usersList = [];
    http.Response response;

    try {
      response = await client.get(
        Uri.parse('http://${Shared.serverIp}:8080/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        for (var user in users) {
          usersList.add(User.fromJson(user));
        }
      }
    } catch (e) {
      print("error occured ${e.toString()}");
    }
    return usersList;
  }

  Future<String> addToActiveList(User user) async {
    http.Response response;
    try {
      response =
          await client.post(Uri.parse('http://${Shared.serverIp}:8080/users'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(user.toJson()));
      print("Response Status: ${response.statusCode}");
      return response.body;
    } catch (e) {
      print("error occured ${e.toString()}");
      return "";
    }
  }
}
