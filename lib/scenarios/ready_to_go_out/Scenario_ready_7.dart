import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_7_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_7_left({super.key, required this.acter});

  @override
  State<Scenario_ready_7_left> createState() => _Scenario_ready_7_leftState();
}

class _Scenario_ready_7_leftState extends State<Scenario_ready_7_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "지금부터 볼일을 봐 볼까요? "
            "오른쪽 화면의 변기를 손가락으로 직접 눌러보세요. ",
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

class Scenario_ready_7_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_7_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_7_right> createState() => _Scenario_ready_7_rightState();
}

class _Scenario_ready_7_rightState extends State<Scenario_ready_7_right> {
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
    if(_bool?.value == true){
      widget.step_data.sendStepData(
          "ready_to_go 7",
          "(용변을 보기 위해 변기 뚜껑을 여는 상황)오른쪽 화면의 변기를 직접 눌러 뚜껑을 열어보세요",
          "정답: 터치 완료",
          "응답(터치하기): 시간 초과"
      );
    }else {
      widget.step_data.sendStepData(
          "ready_to_go 7",
          "(용변을 보기 위해 변기 뚜껑을 여는 상황)오른쪽 화면의 변기를 직접 눌러 뚜껑을 열어보세요",
          "정답: 터치 완료",
          "응답(터치하기): 터치 완료"
      );
    }
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
            "assets/ready/toilet_closedstate.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
