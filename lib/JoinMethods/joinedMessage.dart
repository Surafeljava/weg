import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weg/models/message.dart';
import 'package:weg/providers/mainProvider.dart';

class JoinedMessage extends StatefulWidget {
  const JoinedMessage({Key? key}) : super(key: key);

  @override
  _JoinedMessageState createState() => _JoinedMessageState();
}

class _JoinedMessageState extends State<JoinedMessage> {
  TextEditingController messageController = new TextEditingController();

  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    Socket socket = Provider.of<MainProvider>(context, listen: false).socket;

    // listen for responses from the server
    socket.listen(
      // handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        setState(() {
          messages.add(Message.fromJson(json.decode(serverResponse)));
        });
        print('Server: $serverResponse');
      },

      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        socket.destroy();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //Client Close...
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Joined Chat',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
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
                          child: Text('No Messages Yet'),
                        )
                      : ListView.builder(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
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
                          Socket socket = mainProvider.socket;
                          DateTime now = DateTime.now();
                          Message message = new Message(
                              message: messageController.text,
                              from: mainProvider.currentUserName,
                              time: "${now.hour}:${now.minute}");
                          socket.write(json.encode(message.toJson()));
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
}
