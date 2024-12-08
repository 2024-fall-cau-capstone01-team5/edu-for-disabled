import 'package:flutter/material.dart';
import 'Scenario_park_1.dart';
import 'Scenario_park_2.dart';
import 'Scenario_park_3.dart';
import 'Scenario_park_4.dart';
import 'Scenario_park_5.dart';
import 'Scenario_park_6.dart';
import 'Scenario_park_7.dart';
import 'Scenario_park_8.dart';

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
      home: Scenario_park_8_left(),

      // home: Scenario('편의점'),
    );
  }
}
