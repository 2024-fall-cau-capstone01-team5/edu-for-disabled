import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_11_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_11_left({super.key, required this.acter});

  @override
  State<Scenario_ready_11_left> createState() => _Scenario_ready_11_leftState();
}

class _Scenario_ready_11_leftState extends State<Scenario_ready_11_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 양치질을 해볼까요?"
    );
    await tts.TextToSpeech(
        "그럼 양치질을 해볼까요?",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "오른쪽 화면의 이빨을 손가락으로 직접 눌러보세요."
    );
    await tts.TextToSpeech(
        "오른쪽 화면의 이빨을 손가락으로 직접 눌러보세요.",
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
              image: AssetImage("assets/ready/bathroom.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_ready_11_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_11_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_11_right> createState() => _Scenario_ready_11_rightState();
}

class _Scenario_ready_11_rightState extends State<Scenario_ready_11_right> {
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
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "ready_to_go 11",
            "(이빨을 닦는 상황)오른쪽 화면의 이빨을 손가락으로 직접 눌러 이빨을 닦아보세요",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "ready_to_go 11",
            "(이빨을 닦는 상황)오른쪽 화면의 이빨을 손가락으로 직접 눌러 이빨을 닦아보세요",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. 양치질을 제대로 하지 않으면 입에서 냄새가 날 수도 있어요."
      );
      await tts.TextToSpeech(
          "참 잘했어요. 양치질을 제대로 하지 않으면 입에서 냄새가 날 수도 있어요.",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "앞으로는 양치질을 꼼꼼하게 깨끗히 해 보도록 해요."
      );
      await tts.TextToSpeech(
          "앞으로는 양치질을 꼼꼼하게 깨끗히 해 보도록 해요.",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "그리고 양치질이 끝나면 물로 입을 헹구는 것도 잊지 않도록 해요. "
      );
      await tts.TextToSpeech(
          "그리고 양치질이 끝나면 물로 입을 헹구는 것도 잊지 않도록 해요. ",
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
            "assets/ready/brushing_tooth.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
