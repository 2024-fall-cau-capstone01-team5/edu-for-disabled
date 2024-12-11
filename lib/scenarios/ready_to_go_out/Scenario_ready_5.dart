import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_5_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_5_left({super.key, required this.acter});

  @override
  State<Scenario_ready_5_left> createState() => _Scenario_ready_5_leftState();
}

class _Scenario_ready_5_leftState extends State<Scenario_ready_5_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "밥을 다 먹고 난 후에는 식탁을 치워야 해요."
    );
    await tts.TextToSpeech(
        "밥을 다 먹고 난 후에는 식탁을 치워야 해요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "오른쪽 화면의 그릇과 수저들을 손가락으로 직접 눌러보세요."
    );
    await tts.TextToSpeech(
        "오른쪽 화면의 그릇과 수저들을 손가락으로 직접 눌러보세요.",
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

class Scenario_ready_5_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_5_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_5_right> createState() => _Scenario_ready_5_rightState();
}

class _Scenario_ready_5_rightState extends State<Scenario_ready_5_right> {
  SMITrigger? _spoon1;
  SMITrigger? _spoon2;
  SMITrigger? _plate1;
  SMITrigger? _plate2;

  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _spoon1 = controller.findInput<SMITrigger>('spoon 1') as SMITrigger?;
      _spoon2 = controller.findInput<SMITrigger>('spoon 2') as SMITrigger?;
      _plate1 = controller.findInput<SMITrigger>('plate 1') as SMITrigger?;
      _plate2 = controller.findInput<SMITrigger>('plate 2') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
      _bool?.value = false;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "ready_to_go 5",
            "(음식을 다 먹고 치우는 상황)오른쪽 화면의 그릇과 수저들을 손가락으로 직접 눌러 싱크대에 옮겨보세요",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "ready_to_go 5",
            "(음식을 다 먹고 치우는 상황)오른쪽 화면의 그릇과 수저들을 손가락으로 직접 눌러 싱크대에 옮겨보세요",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. 앞으로는 자기가 밥을 먹은 그릇들은"
      );
      await tts.TextToSpeech(
          "참 잘했어요. 앞으로는 자기가 밥을 먹은 그릇들은",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "스스로 치우는 착한 사람이 돼 보도록 해요."
      );
      await tts.TextToSpeech(
          "스스로 치우는 착한 사람이 돼 보도록 해요.",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    }else if (stateName == "Timer exit"){
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
            "assets/ready/sink_clear.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
