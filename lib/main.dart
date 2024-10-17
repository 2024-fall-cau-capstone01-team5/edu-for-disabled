import 'package:flutter/material.dart';
import 'contents_bar.dart';   // Landing page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContentsBar(),
    );
  }
}
