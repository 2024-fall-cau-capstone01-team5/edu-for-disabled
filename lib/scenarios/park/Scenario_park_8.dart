import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_park_2_left extends StatefulWidget {
  const Scenario_park_2_left({super.key});

  @override
  State<Scenario_park_2_left> createState() => _Scenario_park_2_leftState();
}

class _Scenario_park_2_leftState extends State<Scenario_park_2_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("이야기를 잘 끝내셨네요. 참 잘했어요."
        "앞으로는 나갈 때 부모님과 선생님의 말씀을 잘 듣는 착한 사람이 되보도록 해요 "
        "!", "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/park/car_inside.webp"),
        fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Scenario_park_2_right extends StatefulWidget {
  const Scenario_park_2_right({super.key});

  @override
  State<Scenario_park_2_right> createState() => _Scenario_park_2_rightState();
}

class _Scenario_park_2_rightState extends State<Scenario_park_2_right> {
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
    if (stateName == 'ExitState') {
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
              "assets/park/security_belt.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),
        ]),
      ),
    );
  }
}
