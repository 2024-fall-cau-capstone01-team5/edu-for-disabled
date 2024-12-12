import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CharacterCustom extends StatefulWidget {
  const CharacterCustom({super.key, required this.userId, required this.profile});
  final String userId;
  final String profile;

  @override
  State<CharacterCustom> createState() => _CharacterCustomState();
}

class _CharacterCustomState extends State<CharacterCustom> {

  late final StateMachineController _stateMachineController;
  /*
    다음 페이지에서 StateMachineController에 필요한 메소드를 참조했음
    https://pub.dev/documentation/rive/latest/rive/StateMachineController-class.html
   */
  SMINumber? _toggle;
  SMINumber? _prop;
  SMINumber? _eyeShape;
  SMINumber? _bodyShape;
  SMINumber? _bodyColor;
  Map<String, int> idMap = {
    "toggle": 2188,
    "prop": 2189,
    "eyeShape": 2190,
    "bodyShape": 2191,
    "bodyColor": 2192
  };

  Future<void> _fetchCharacterState() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/character/get?user_id=${widget.userId}&profile_name=${widget.profile}");

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _stateMachineController.setInputValue(idMap["toggle"] ?? 2188, data["toggle"] ?? 0.0);
          _stateMachineController.setInputValue(idMap["prop"] ?? 2189, data["prop"] ?? 0.0);
          _stateMachineController.setInputValue(idMap["eyeShape"] ?? 2190, data["eyeShape"] ?? 0.0);
          _stateMachineController.setInputValue(idMap["bodyShape"] ?? 2191, data["bodyShape"] ?? 0.0);
          _stateMachineController.setInputValue(idMap["bodyColor"] ?? 2192, data["bodyColor"] ?? 0.0);
        });
      } else {
        print("Failed to fetch character data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching character data: $e");
    }
  }

  Future<void> _saveCharacterState() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/character/update");

    final body = {
      "user_id": widget.userId,
      "profile_name": widget.profile,
      "toggle": _toggle?.value ?? 0.0,
      "prop": _prop?.value ?? 0.0,
      "eyeShape": _eyeShape?.value ?? 0.0,
      "bodyShape": _bodyShape?.value ?? 0.0,
      "bodyColor": _bodyColor?.value ?? 0.0,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print("Character state saved successfully!");
      } else {
        print("Failed to save character state: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saving character state: $e");
    }
  }

  void _onRiveInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    )!;
    artboard.addController(_stateMachineController);


    _fetchCharacterState();
  }

  void _hitBump(){
    _toggle = _stateMachineController.getNumberInput("toggle") as SMINumber?;
    _prop = _stateMachineController.getNumberInput("prop") as SMINumber?;
    _eyeShape = _stateMachineController.getNumberInput("eyeShape") as SMINumber?;
    _bodyShape = _stateMachineController.getNumberInput("bodyShape") as SMINumber?;
    _bodyColor = _stateMachineController.getNumberInput("bodyColor") as SMINumber?;
    //print("_toggle: ${_toggle?.value}, _prop: ${_prop?.value}, _eyeShape: ${_eyeShape?.value}, _bodyShape: ${_bodyShape?.value}, _bodyColor: ${_bodyColor?.value}");
    // 1. HTTP로 /character/set 호출해 State 저장하기
    _saveCharacterState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.profile}님의 캐릭터 꾸미기"),
        ),
        body: Center(
          // Inspired from, https://stackoverflow.com/questions/67075182/how-to-use-rives-state-machine-in-flutter
          child: GestureDetector(
            child: RiveAnimation.asset(
              "assets/character_creator.riv",
              fit: BoxFit.contain,
              artboard: "MacBook Air - 6",
              onInit: _onRiveInit,
            ),
            onTap: _hitBump,
          )
        ),
    );
  }
}
