import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final tts = TTS();

class Scenario_park_1_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_park_1_left({super.key, required this.acter});

  @override
  State<Scenario_park_1_left> createState() => _Scenario_park_1_leftState();
}

class _Scenario_park_1_leftState extends State<Scenario_park_1_left> {
  @override
  void initState() {
    super.initState();
     _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "지금부터 자동차에 타보도록 해요. "
        "오른쪽 화면의 문을 손가락으로 직접 눌러보세요!"
        );
    await tts.TextToSpeech("지금부터 자동차에 타보도록 해요. "
        "오른쪽 화면의 문을 손가락으로 직접 눌러보세요"
        "!", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

  }



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/park/car.webp"),
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

class Scenario_park_1_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_park_1_right({super.key, required this.step_data});

  @override
  State<Scenario_park_1_right> createState() => _Scenario_park_1_rightState();
}

class _Scenario_park_1_rightState extends State<Scenario_park_1_right> {
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
      widget.step_data.sendStepData(
          "park 1",
          "(자동차 문을 열고 타는 상황)오른쪽 화면의 문을 손가락으로 직접 눌러보세요",
          "정답: 터치 완료",
          "응답(터치하기): 터치 완료"
      );

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle("참 잘했어요.");
      await tts.TextToSpeech(
          "참 잘했어요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
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
              "assets/door_open.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),
        ]),
      ),
    );
  }
}
