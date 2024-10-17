import 'package:flutter/material.dart';

class Preference extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("개인 설정"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/preferences/avatars/boy_01.png"),
            Text("Adjust your preferences here."),
          ],
        ),
      ),
    );
  }
}
