import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weg/JoinMethods/searchPeerUsers.dart';
import 'package:weg/hostMethods/hostMessages.dart';
import 'package:weg/providers/mainProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (_, mainProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
              letterSpacing: 6.0,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey[700]),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                mainProvider.updateLoggedIn(false);
              },
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'ወግ',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'WEG',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                    letterSpacing: 6.0,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Text(
                      'JOIN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    print("Join Clicked!");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SearchPeerUsers()));
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Text(
                      'HOST',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    print("Create Clicked!");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => HostMessages()));
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
