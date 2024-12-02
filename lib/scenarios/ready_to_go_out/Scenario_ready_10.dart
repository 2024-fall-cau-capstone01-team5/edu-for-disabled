import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_10_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_10_left({super.key, required this.acter});

  @override
  State<Scenario_ready_10_left> createState() => _Scenario_ready_10_leftState();
}

class _Scenario_ready_10_leftState extends State<Scenario_ready_10_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "그럼 이제부터 씻어볼까요? 먼저 양치를 해 보도록 해요. "
            "오른쪽 화면의 치약을 손가락으로 직접 눌러보세요. ",
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

class Scenario_ready_10_right extends StatefulWidget {
  const Scenario_ready_10_right({super.key});

  @override
  State<Scenario_ready_10_right> createState() => _Scenario_ready_10_rightState();
}

class _Scenario_ready_10_rightState extends State<Scenario_ready_10_right> {
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
    if (stateName == 'ExitState') {
      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로는 치약을 짤 때에는 방금 그림에서 본 것과 같이 필요한 만큼만 짜 보도록 해요. ",
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
            "assets/ready/toothbrush.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
        ]),
      ),
    );
  }
}
