import 'package:flutter/material.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';

import 'scenarios/conv_store/Scenario_c_5.dart';

import 'scenario.dart';

String? get font => GoogleFonts.gaegu().fontFamily;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.gaeguTextTheme(),
      ),
      home: LoginScreen(), // 디버깅용

      // home: Scenario('편의점'),
    );
  }
}
