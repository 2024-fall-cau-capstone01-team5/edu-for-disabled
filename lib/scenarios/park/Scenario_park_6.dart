import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_park_6_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_park_6_left({super.key, required this.acter});

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


    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      // child: const Image(
      //   image: AssetImage("assets/park/park.webp"),
      //   fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      // ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/park/park.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(
              child: widget.acter
          ),
        ],
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

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'oceanStateMachine',
      onStateChange: _onStateChange
    );

    if (controller != null) {
      artboard.addController(controller);
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {

    if (stateName == 'ExitState') {
      await tts.TextToSpeech("참 잘했어요. "
          "앞으로는 집에 가기 전에 자기가 남긴 쓰레기는 스스로 치우는"
          "착한 사람이 되보도록 해요", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          RiveAnimation.asset(
            "assets/park/garbage_collecting.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          ),
        ]),
      ),
    );
  }
}
