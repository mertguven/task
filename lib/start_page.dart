import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trellocards/home_page.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3497b1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: RaisedButton(
              onPressed: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => HomePage())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward_ios),
                  Text("Giriş yap"),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Created by\nMEDO",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
