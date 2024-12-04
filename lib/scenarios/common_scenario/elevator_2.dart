import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Elevator_2_left extends StatefulWidget {
  final StatefulWidget acter;

  const Elevator_2_left({super.key, required this.acter});

  @override
  State<Elevator_2_left> createState() => _Elevator_2_leftState();
}

class _Elevator_2_leftState extends State<Elevator_2_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "오른쪽 화면에 나와 있는 문을 터치해서 열고 들어가보세요!"
    );
    await tts.TextToSpeech("오른쪽 화면에 나와 있는 문을 터치해서 열고 들어가보세요"
        "!", "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // 부모의 경계 반경과 동일하게 설정
        child: Stack(
          children: [
            // 배경 이미지 (아래쪽에 위치)
            const Positioned.fill(
              child: Image(
                image: AssetImage("assets/common/elevator.png"),
                fit: BoxFit.cover, // 이미지가 Container에 맞도록 설정
              ),
            ),
            // 배우 이미지 (위쪽에 위치)
            Positioned.fill(
                child: widget.acter
            ),
          ],
        ),
      ),
    );
  }
}

class Elevator_2_right extends StatefulWidget {
  const Elevator_2_right({super.key});

  @override
  State<Elevator_2_right> createState() => _Elevator_2_rightState();
}

class _Elevator_2_rightState extends State<Elevator_2_right> {
  SMITrigger? _touch;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _touch = controller.findInput<SMITrigger>('touch') as SMITrigger?;
    }
  }

  void _hitBump() {

    _touch?.fire();

    print("Touch TRIGGERED!");
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    if (stateName == 'exit') {
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle("참 잘했어요. ");
      await tts.TextToSpeech(
          "참 잘했어요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          GestureDetector(
            onTap: _hitBump,
            child: RiveAnimation.asset(
              "assets/common/elevator_door.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),
        ]),
      ),
    );
  }
}
