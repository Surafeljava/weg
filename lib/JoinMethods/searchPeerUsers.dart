import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weg/JoinMethods/joinedMessage.dart';
import 'package:weg/models/user.dart';
import 'package:weg/providers/mainProvider.dart';
import 'package:weg/services/requests.dart';

class SearchPeerUsers extends StatefulWidget {
  const SearchPeerUsers({Key? key}) : super(key: key);

  @override
  _SearchPeerUsersState createState() => _SearchPeerUsersState();
}

class _SearchPeerUsersState extends State<SearchPeerUsers> {
  bool searching = true;

  Requests requests = new Requests();

  List<User> activeUsers = [];

  @override
  void initState() {
    //Get the users data and make searching false
    requests.getAllActiveUsers().then((value) {
      setState(() {
        String name =
            Provider.of<MainProvider>(context, listen: false).currentUserName;
        for (User user in value) {
          if (user.name != name) {
            activeUsers.add(user);
          }
        }
        searching = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Search ወግ',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[800],
            fontWeight: FontWeight.w400,
            letterSpacing: 2.0,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      body: Consumer<MainProvider>(builder: (_, mainProvider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: searching
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : activeUsers.length == 0
                        ? Center(
                            child: Text('No Active User'),
                          )
                        : ListView.builder(
                            itemCount: activeUsers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    activeUsers[index]
                                        .name
                                        .substring(0, 2)
                                        .toUpperCase(),
                                  ),
                                ),
                                title: Text(activeUsers[index].name),
                                subtitle: Text(activeUsers[index].ip),
                                onTap: () async {
                                  //Connect to the server and call the joined message page
                                  print("Connecting...");
                                  // ignore: close_sinks
                                  try {
                                    Socket socket = await Socket.connect(
                                        activeUsers[index].ip, 4567);
                                    print("Connected: ");
                                    mainProvider.addSocket(socket);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => JoinedMessage()));
                                  } catch (e) {
                                    print("Failed to connect.");
                                  }
                                },
                              );
                            },
                          ),
              ),
              ElevatedButton(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Text(
                    'SCAN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    searching = true;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  requests.getAllActiveUsers().then((value) {
                    activeUsers = [];
                    setState(() {
                      String name =
                          Provider.of<MainProvider>(context, listen: false)
                              .currentUserName;
                      for (User user in value) {
                        if (user.name != name) {
                          activeUsers.add(user);
                        }
                      }
                      searching = false;
                    });
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        );
      }),
    );
  }
}
