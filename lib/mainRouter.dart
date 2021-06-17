import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weg/commonViews/homePage.dart';
import 'package:weg/login.dart';
import 'package:weg/providers/mainProvider.dart';
import 'package:weg/JoinMethods/searchPeerUsers.dart';

class MainRouter extends StatefulWidget {
  const MainRouter({Key? key}) : super(key: key);

  @override
  _MainRouterState createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (_, mainProvider, child) {
        if (mainProvider.loggedIn) {
          return HomePage();
        } else {
          return Login();
        }
      },
    );
  }
}
