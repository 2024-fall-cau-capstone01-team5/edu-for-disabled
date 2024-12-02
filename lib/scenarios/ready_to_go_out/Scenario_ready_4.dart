import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_4_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_4_left({super.key, required this.acter});

  @override
  State<Scenario_ready_4_left> createState() => _Scenario_ready_4_leftState();
}

class _Scenario_ready_4_leftState extends State<Scenario_ready_4_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
            "그럼 밥을 먹어볼까요? 오른쪽 화면을 손가락으로 직접 눌러보세요. ",
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

class Scenario_ready_4_right extends StatefulWidget {
  const Scenario_ready_4_right({super.key});

  @override
  State<Scenario_ready_4_right> createState() => _Scenario_ready_4_rightState();
}

class _Scenario_ready_4_rightState extends State<Scenario_ready_4_right> {
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
    if (stateName == 'eat') {
      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로 밥을 먹을 때에는 손으로 직접 음식을 집는 것이 아닌 꼭 숟가락과 젓가락을 사용해요."
              "그리고 음식을 흘리지 않도록 주의하며 먹어보도록 해요. ",
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
            "assets/ready/eating.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
        ]),
      ),
    );
  }
}
