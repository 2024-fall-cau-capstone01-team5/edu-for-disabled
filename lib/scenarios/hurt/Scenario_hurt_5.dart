import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_5_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_5_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_5_left> createState() => _Scenario_hurt_5_leftState();
}

class _Scenario_hurt_5_leftState extends State<Scenario_hurt_5_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "상처가 난 부위에는 일단 연고부터 발라야 해요."
            "연고는 나쁜 세균들이 몸에 들어오지 못하도록 보호를 해준답니다. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "그런 다음에는 반창고를 붙여야 해요. "
            "반창고도 나쁜 세균들이 몸에 들어오지 못하도록 보호를 해준답니다. ",
            "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
            "그럼, 반창고를 붙여볼까요?"
                "오른쪽 화면의 반창고를 손가락으로 직접 눌러보세요. ",
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
              image: AssetImage("assets/hurt/응급키트.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_5_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_hurt_5_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_5_right> createState() => _Scenario_hurt_5_rightState();
}

class _Scenario_hurt_5_rightState extends State<Scenario_hurt_5_right> {
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


    if (stateName == 'exitState') {
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "hurt 5",
            "(상처에 반창고를 붙이는 상황)오른쪽 화면을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "hurt 5",
            "(상처에 반창고를 붙이는 상황)오른쪽 화면을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로 다쳤을 때는 연고를 바르고 반창고를 붙이는 것을 잊지 말아요. ",
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
            "assets/hurt/bandage.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
