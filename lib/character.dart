import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Character extends StatefulWidget {
  const Character({super.key, required this.userId, required this.profile});
  final String userId;
  final String profile;

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  late final StateMachineController _stateMachineController;

  void _onRiveInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    )!;
    artboard.addController(_stateMachineController);

    _fetchCharacterState();
  }

  SMINumber? _toggle;
  SMINumber? _prop;
  SMINumber? _eyeShape;
  SMINumber? _bodyShape;
  SMINumber? _bodyColor;
  Map<String, int> idMap = {
    "toggle": 742,
    "prop": 743,
    "eyeShape": 744,
    "bodyShape": 745,
    "bodyColor": 746
  };

  Future<void> _fetchCharacterState() async {
    final url = Uri.parse(
        "http://20.9.151.223:8080/character/get?user_id=${widget
            .userId}&profile_name=${widget.profile}");

    try {
      final response = await http.get(
          url, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _stateMachineController.setInputValue(
              idMap["toggle"] ?? 742, data["toggle"] ?? 0.0);
          _stateMachineController.setInputValue(
              idMap["prop"] ?? 743, data["prop"] ?? 0.0);
          _stateMachineController.setInputValue(
              idMap["eyeShape"] ?? 744, data["eyeShape"] ?? 0.0);
          _stateMachineController.setInputValue(
              idMap["bodyShape"] ?? 745, data["bodyShape"] ?? 0.0);
          _stateMachineController.setInputValue(
              idMap["bodyColor"] ?? 746, data["bodyColor"] ?? 0.0);
        });
      } else {
        print("Failed to fetch character data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching character data: $e");
    }
  }

  void _hitBump() {
    _toggle = _stateMachineController.getNumberInput("toggle") as SMINumber?;
    _prop = _stateMachineController.getNumberInput("prop") as SMINumber?;
    _eyeShape =
    _stateMachineController.getNumberInput("eyeShape") as SMINumber?;
    _bodyShape =
    _stateMachineController.getNumberInput("bodyShape") as SMINumber?;
    _bodyColor =
    _stateMachineController.getNumberInput("bodyColor") as SMINumber?;
    //print("_toggle: ${_toggle?.id}, _prop: ${_prop?.id}, _eyeShape: ${_eyeShape?.id}, _bodyShape: ${_bodyShape?.id}, _bodyColor: ${_bodyColor?.id}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9, // 가로 화면 기준 크기 설정
      height: size.height * 0.6, // 적절한 높이 비율 설정
      child: GestureDetector(
          onTap: _hitBump,
          child: RiveAnimation.asset(
            "assets/character.riv",
            fit: BoxFit.contain,
            artboard: "MacBook Air - 6",
            onInit: _onRiveInit,
          )
      ),
    );
  }
}
