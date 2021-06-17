import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:weg/models/message.dart';
import 'package:weg/models/user.dart';
import 'package:weg/providers/mainProvider.dart';
import 'package:weg/services/requests.dart';
import 'package:weg/shared.dart';

class HostMessages extends StatefulWidget {
  const HostMessages({Key? key}) : super(key: key);

  @override
  _HostMessagesState createState() => _HostMessagesState();
}

class _HostMessagesState extends State<HostMessages> {
  late ServerSocket server;

  TextEditingController messageController = new TextEditingController();

  List<Message> messages = [];

  Requests requests = new Requests();

  Future<void> serverStart() async {
    // bind the socket server to an address and port

    String name =
        Provider.of<MainProvider>(context, listen: false).currentUserName;
    String newIp = await Ipify.ipv4();

    // print("My IP: ${gt.ip}");
    User userModel = new User(name: name, ip: newIp);

    String responseCode = await requests.addToActiveList(userModel);
    print("Response Code: $responseCode");

    User usr = User.fromJson(jsonDecode(responseCode));
    String finalIp = usr.ip.split(":")[0];
    print("Final IP: $finalIp");

    //Create Server Socket
    server = await ServerSocket.bind(finalIp, 4567);

    // listen for clent connections to the server
    server.listen((client) {
      handleConnection(client);
    });
  }

  @override
  void initState() {
    serverStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            server.close();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Hosting ወግ',
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
      body: SafeArea(
        child: Consumer<MainProvider>(builder: (_, mainProvider, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: messages.length == 0
                      ? Center(
                          child: Text('No Message Yet'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(messages[index].message),
                              subtitle: Text(messages[index].time),
                              leading: CircleAvatar(
                                child: Text(
                                  messages[index]
                                      .from
                                      .substring(0, 2)
                                      .toUpperCase(),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: messageTextFieldGenerator(
                        controller: messageController,
                        hint: 'Message',
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        //Send Message Here
                        if (messageController.text.isNotEmpty) {
                          DateTime now = DateTime.now();
                          Message message = new Message(
                              message: messageController.text,
                              from: mainProvider.currentUserName,
                              time: "${now.hour}:${now.minute}");

                          List<Socket> clients = mainProvider.clients;

                          if (clients.length == 0) {
                            setState(() {
                              messages.add(message);
                            });
                          } else {
                            for (Socket cls in clients) {
                              cls.write(message.toJson());
                            }
                            setState(() {
                              messages.add(message);
                            });
                          }

                          messageController.text = "";
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget messageTextFieldGenerator(
      {required TextEditingController controller, required String hint}) {
    return TextFormField(
      controller: controller,
      autofocus: false,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.blueGrey[700],
        letterSpacing: 1.0,
      ),
      onChanged: (phone) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
            letterSpacing: 0.5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
      ),
    );
  }

  void handleConnection(Socket client) {
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');

    Shared.clients.add(client);
    Provider.of<MainProvider>(context, listen: false).addClient(client);

    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) async {
        await Future.delayed(Duration(seconds: 1));
        final message = String.fromCharCodes(data);
        Message msg = Message.fromJson(message);
        messages.add(msg);
        if (message == 'logout') {
          client.write('loging out!');
          await client.close();
        } else {
          //Add the response handler here
          List<Socket> registeredClients =
              Provider.of<MainProvider>(context, listen: false).clients;
          for (Socket cls in registeredClients) {
            cls.write('$message');
          }
          setState(() {
            messages.add(Message.fromJson(message));
          });
        }
      },

      // handle errors
      onError: (error) {
        print(error);
        client.close();
      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        client.close();
      },
    );
  }
}
