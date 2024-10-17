import 'package:flutter/material.dart';

class Scenario extends StatelessWidget {  // 현재는 시나리오 미구현으로 stateless
  final String label;
  Scenario(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$label 시나리오'),
      ),
      body: Center(
        child: Text('Welcome to the $label Scenario page!'),
      ),
    );
  }
}
