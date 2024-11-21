import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_park_4_left extends StatefulWidget {
  const Scenario_park_4_left({super.key});

  @override
  State<Scenario_park_4_left> createState() => _Scenario_park_4_leftState();
}

class _Scenario_park_4_leftState extends State<Scenario_park_4_left> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playWelcomeTTS();
  }


  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "공원에 도착했어요. 예쁜 나뭇잎들이 떨어져 있네요. "
            "한번 주워볼까요? 오른쪽 화면의 나뭇잎들을 손가락으로 직접 터치해보세요"
            "!",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/park/tree.webp"),
        fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Scenario_park_4_right extends StatefulWidget {
  const Scenario_park_4_right({super.key});

  @override
  State<Scenario_park_4_right> createState() => _Scenario_park_4_rightState();
}

class _Scenario_park_4_rightState extends State<Scenario_park_4_right> {
  SMITrigger? _touch1;
  SMITrigger? _touch2;
  SMITrigger? _touch3;
  SMITrigger? _touch4;
  SMIBool? _bool;



  void _onRiveInit(Artboard artboard) async {

    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);

      _touch1 = controller.findInput<SMITrigger>('Trigger 1') as SMITrigger?;
      _touch2 = controller.findInput<SMITrigger>('Trigger 2') as SMITrigger?;
      _touch3 = controller.findInput<SMITrigger>('Trigger 3') as SMITrigger?;
      _touch4 = controller.findInput<SMITrigger>('Trigger 4') as SMITrigger?;

      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == "disapper 1" ||
        stateName == "disapper 2" ||
        stateName == "disapper 3" ||
        stateName == "disapper 4") {}

    if (stateName == 'ExitState') {
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

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
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
                  "assets/park/leaves.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
