import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_park_6_left extends StatefulWidget {
  const Scenario_park_6_left({super.key});

  @override
  State<Scenario_park_6_left> createState() => _Scenario_park_6_leftState();
}

class _Scenario_park_6_leftState extends State<Scenario_park_6_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("집으로 돌아가기 전에 자기가 남긴 쓰레기를 치워봐요. "
        "오른쪽 화면을 손가락으로 눌러보세요. "
        "그리고 아래로 떨어지는 쓰레기들을 눌러보세요. "
        , "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/park/park.webp"),
        fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Scenario_park_6_right extends StatefulWidget {
  const Scenario_park_6_right({super.key});

  @override
  State<Scenario_park_6_right> createState() => _Scenario_park_6_rightState();
}

class _Scenario_park_6_rightState extends State<Scenario_park_6_right> {
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

  void _onStateChange(String stateMachineName, String stateName) async{
    if (stateName == 'ExitState') {
      await tts.TextToSpeech(
          "참 잘했어요. 앞으로 집에 돌아가기 전에는 자기 쓰레기는 직접 스스로 치워도보록 해요. ",
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
          RiveAnimation.asset(
            "assets/park/Garbage_collecting.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          ),
        ]),
      ),
    );
  }
}
