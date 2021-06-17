import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weg/providers/mainProvider.dart';
import 'package:weg/services/requests.dart';
import 'package:weg/shared.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController ipController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<MainProvider>(
      builder: (_, mainProvider, child) {
        return SafeArea(
          child: Padding(
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
                nameTextFieldGenerator(
                    controller: nameController, hint: 'Name'),
                SizedBox(
                  height: 15,
                ),
                nameTextFieldGenerator(
                    controller: ipController, hint: 'Server Ip'),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(
                    'Join',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4.0,
                    ),
                  ),
                  onPressed: () async {
                    print("Join Clicked!");

                    if (ipController.text.isNotEmpty) {
                      mainProvider.changeServerIp(ipController.text);
                      Shared.serverIp = ipController.text;
                    }

                    if (nameController.text.isNotEmpty) {
                      mainProvider.updateCurrentUserName(nameController.text);
                      mainProvider.updateLoggedIn(true);
                    }
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget nameTextFieldGenerator(
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
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.transparent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }
}
