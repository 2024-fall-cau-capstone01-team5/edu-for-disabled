import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_hurt_7_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_7_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_7_left> createState() => _Scenario_hurt_7_leftState();
}

class _Scenario_hurt_7_leftState extends State<Scenario_hurt_7_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "상처가 난 곳을 수건으로 꾹 눌렀다면, 이번엔 도움을 구해야 해요.\n"
            "부모님이 옆에 계시다면, 부모님께 먼저 도움을 구해 보도록 해요. "
    );
    await tts.TextToSpeech(
        "상처가 난 곳을 수건으로 꾹 눌렀다면, 이번엔 도움을 구해야 해요. "
            "부모님이 옆에 계시다면, 부모님께 먼저 도움을 구해 보도록 해요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "만약에 부모님이 안 계실 때에는 119에 전화를 해서 도움을 구해야 해요."
    );
    await tts.TextToSpeech(
        "만약에 부모님이 안 계실 때에는 119에 전화를 해서 도움을 구해야 해요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 119에 전화를 걸어볼까요?\n오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요! "
    );
    await tts.TextToSpeech(
        "그럼 119에 전화를 걸어볼까요? 오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요! ",
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

class Scenario_hurt_7_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_hurt_7_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_7_right> createState() => _Scenario_hurt_7_rightState();
}

class _Scenario_hurt_7_rightState extends State<Scenario_hurt_7_right> {
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
            "hurt 7",
            "(도움 요청을 위해 119에 전화를 하는 상황)오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요!",
            "정답: 터치 완료",
            "응답(터치하기): 시간 초과"
        );
      }else {
        widget.step_data.sendStepData(
            "hurt 7",
            "(도움 요청을 위해 119에 전화를 하는 상황)오른쪽 화면의 버튼을 손가락으로 직접 눌러보세요!",
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
            "assets/hurt/call119.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
