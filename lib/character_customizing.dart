import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final StateMachineController _stateMachineController;
  SMINumber? _toggle;
  SMINumber? _prop;
  SMINumber? _eyeShape;
  SMINumber? _bodyShape;
  SMINumber? _bodyColor;


  void _onRiveInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
        artboard,
        "State Machine 1",
    )!;
    artboard.addController(_stateMachineController);
    
    _toggle = _stateMachineController.findInput("toggle") as SMINumber?;
    _prop = _stateMachineController.findInput("prop") as SMINumber?;
    _eyeShape = _stateMachineController.findInput("eyeShape") as SMINumber?;
    _bodyShape = _stateMachineController.findInput("bodyShape") as SMINumber?;
    _bodyColor = _stateMachineController.findInput("bodyColor") as SMINumber?;
  }


















  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("캐릭터 커스터마이징 페이지"),
        ),
        body: Center(
          child: RiveAnimation.asset(
            "assets/character_creator.riv",
            fit: BoxFit.contain,
            artboard: "MacBook Air - 6",
            onInit: _onRiveInit,
          ),
        ));
  }
}
