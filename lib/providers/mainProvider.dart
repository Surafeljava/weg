import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:weg/models/user.dart';

class MainProvider extends ChangeNotifier {
  bool loggedIn = false;

  void updateLoggedIn(bool val) {
    loggedIn = val;
    notifyListeners();
  }

  //Search or Host
  bool searching = false;

  void updateSearching(bool val) {
    searching = val;
    notifyListeners();
  }

  //Active Users Store
  List<User> activeUser = [];

  void updateActiveUsers(List<User> users) {
    activeUser = users;
    notifyListeners();
  }

  //Current User Name
  String currentUserName = "";

  void updateCurrentUserName(String name) {
    currentUserName = name;
    notifyListeners();
  }

  //Server Joined Users
  List<Socket> clients = [];

  void addClient(Socket client) {
    clients.add(client);
    notifyListeners();
  }

  //Connected socket
  late Socket socket;

  void addSocket(Socket sock) {
    socket = sock;
    notifyListeners();
  }

  //server ip
  String serverIp = "10.6.218.24";

  void changeServerIp(String ip) {
    serverIp = ip;
    notifyListeners();
  }
}
