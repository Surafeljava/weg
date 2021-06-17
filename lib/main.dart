import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weg/mainRouter.dart';
import 'package:weg/providers/mainProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Weg Peer Chatting',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainRouter(),
      ),
    );
  }
}
