import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_4_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_4_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_4_left> createState() => _Scenario_hurt_4_leftState();
}

class _Scenario_hurt_4_leftState extends State<Scenario_hurt_4_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "손가락을 다쳤을 땐 먼저 흐르는 물에 손을 깨끗히 씻어야 해요.\n"
            "그래야 나쁜 세균들이 손가락으로 들어가지 못한답니다."
    );
    await tts.TextToSpeech(
        "손가락을 다쳤을 땐 먼저 흐르는 물에 손을 깨끗히 씻어야 해요. "
            "그래야 나쁜 세균들이 손가락으로 들어가지 못한답니다. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 손을 씻어볼까요? 오른쪽 화면을 손가락으로 직접 눌러보세요. "
    );
    await tts.TextToSpeech(
        "그럼 손을 씻어볼까요? 오른쪽 화면을 손가락으로 직접 눌러보세요. ",
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
              image: AssetImage("assets/hurt/손가락 다침.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_hurt_4_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_hurt_4_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_4_right> createState() => _Scenario_hurt_4_rightState();
}

class _Scenario_hurt_4_rightState extends State<Scenario_hurt_4_right> {
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


    if (stateName == 'handwash_covid') {
      if(_bool?.value == true){
        widget.step_data.sendStepData(
            "hurt 4",
            "(상처를 흐르는 물에 씻는 상황)오른쪽 화면을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "hurt 4",
            "(상처를 흐르는 물에 씻는 상황)오른쪽 화면을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 터치 완료"
        );
      }

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요.\n앞으로 다쳤을 때는 상처를 흐르는 물로 살살 씻어보도록 해요."
      );
      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로 다쳤을 때는 상처를 흐르는 물로 살살 씻어보도록 해요. ",
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
            "assets/hurt/wash_hands.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
