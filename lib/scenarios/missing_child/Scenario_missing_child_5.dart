import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_missing_child_5_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_5_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_5_left> createState() => _Scenario_missing_child_5_leftState();
}

class _Scenario_missing_child_5_leftState extends State<Scenario_missing_child_5_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 지금부터 도움을 요청하러 가볼까요?\n"
            "오른쪽 화면의 문을 손가락으로 직접 눌러보세요."
    );
    await tts.TextToSpeech(
        "그럼 지금부터 도움을 요청하러 가볼까요?"
            "오른쪽 화면의 문을 손가락으로 직접 눌러보세요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/missing_child/shop.png"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_5_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_5_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_5_right> createState() => _Scenario_missing_child_5_rightState();
}

class _Scenario_missing_child_5_rightState extends State<Scenario_missing_child_5_right> {
  SMITrigger? _touch;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _touch = controller.findInput<SMITrigger>('touch') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "missing_child 5",
            "(도움을 요청하러 가게 안으로 들어가는 상황)오른쪽 화면의 문을 손가락으로 직접 눌러 가게 안으로 들어가보세요",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "missing_child 5",
            "(도움을 요청하러 가게 안으로 들어가는 상황)오른쪽 화면의 문을 손가락으로 직접 눌러 가게 안으로 들어가보세요",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
      );
      await tts.TextToSpeech(
          "참 잘했어요. ",
          "ko-KR-Wavenet-D");
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
            "assets/ready/door_opening_and_closing.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
