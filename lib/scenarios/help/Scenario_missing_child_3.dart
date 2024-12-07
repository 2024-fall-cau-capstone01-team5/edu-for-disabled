import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_missing_child_3_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_3_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_3_left> createState() => _Scenario_missing_child_3_leftState();
}

class _Scenario_missing_child_3_leftState extends State<Scenario_missing_child_3_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "먼저 길을 잃었을 땐 멈춰 서서 주변을 천천히 살펴봐야 해요. "
            "그리고 마음을 가라앉히기 위해 심호흡을 해봐요. "
            "오른쪽 화면을 손가락으로 직접 눌러보세요. ",
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
              image: AssetImage("assets/missing_child/시내_부모missing.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_3_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_missing_child_3_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_3_right> createState() => _Scenario_missing_child_3_rightState();
}

class _Scenario_missing_child_3_rightState extends State<Scenario_missing_child_3_right> {
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


    if (stateName == 'BB') {
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "missing_child 3",
            "(길을 잃은 상황에서 침착하게 심호흡을 하는 상황)오른쪽 화면을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "missing_child 3",
            "(길을 잃은 상황에서 침착하게 심호흡을 하는 상황)오른쪽 화면을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로는 어떤 상황이 와도 침착하게 행동해 보도록 해요. ",
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
            "assets/missing_child/breath.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Image(image: AssetImage("assets/common/AAC_멈춰요.png"))
        ]),
      ),
    );
  }
}
