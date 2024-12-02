import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_12_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_12_left({super.key, required this.acter});

  @override
  State<Scenario_ready_12_left> createState() => _Scenario_ready_12_leftState();
}

class _Scenario_ready_12_leftState extends State<Scenario_ready_12_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "양치질을 다 끝냈으니 마지막으로 세수를 해 보도록해요."
            "오른쪽 화면을 손가락으로 직접 눌러보세요 ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/common/living_room.png"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_ready_12_right extends StatefulWidget {
  const Scenario_ready_12_right({super.key});

  @override
  State<Scenario_ready_12_right> createState() => _Scenario_ready_12_rightState();
}

class _Scenario_ready_12_rightState extends State<Scenario_ready_12_right> {
  SMITrigger? _trigger;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _trigger = controller.findInput<SMITrigger>('Trigger 1') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'hand') {
      await tts.TextToSpeech(
          "참 잘했어요. "
              "세수를 할 때는 손에 충분히 비눗기를 뭍힌 다음에 얼굴을 문질러서 깨끗히 씻어보도록 해요. "
              "앞으로는 얼굴을 깨끗히 씻어서 깔끔한 모습을 다른 사람들에게 보여주도록 해요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          RiveAnimation.asset(
            "assets/ready/face_washing.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
        ]),
      ),
    );
  }
}
