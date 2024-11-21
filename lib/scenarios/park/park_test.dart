import 'package:flutter/material.dart';
import 'Scenario_park_1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scenario_park_1_left(),

      // home: Scenario('편의점'),
    );
  }
}
