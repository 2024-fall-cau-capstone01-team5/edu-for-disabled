import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_3_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_3_left({super.key, required this.acter});

  @override
  State<Scenario_ready_3_left> createState() => _Scenario_ready_3_leftState();
}

class _Scenario_ready_3_leftState extends State<Scenario_ready_3_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
            "아침 밥을 먹어보도록 할까요? 마침 부모님께서 음식을 만들고 계시네요. "
                "부모님이 음식을 만들고 계시는 동안 식탁을 차려볼까요? "
                "오른쪽 화면의 접시와 수저들을 손가락으로 직접 눌러보세요. ",
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
              image: AssetImage("assets/ready/kitchen.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_ready_3_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_3_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_3_right> createState() => _Scenario_ready_3_rightState();
}

class _Scenario_ready_3_rightState extends State<Scenario_ready_3_right> {
  SMITrigger? _spoon;
  SMITrigger? _plate;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _spoon = controller.findInput<SMITrigger>('spoon') as SMITrigger?;
      _plate = controller.findInput<SMITrigger>('plate') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      print("EXITSTATE");
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "ready_to_go 3",
            "(부모님께서 음식을 만드는 중일 때 식탁을 차리는 상황)오른쪽 화면의 접시와 수저들을 손가락으로 직접 눌러보세요.",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "ready_to_go 3",
            "(부모님께서 음식을 만드는 중일 때 식탁을 차리는 상황)오른쪽 화면의 접시와 수저들을 손가락으로 직접 눌러보세요.",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로는 밥을 먹기 전에 식탁을 차려 부모님을 도와주는 착한 사람이 돼 보도록 해요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    }else if (stateName == "Timer exit"){
      print("TIMER EXIT");
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
            "assets/ready/setting_table.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
