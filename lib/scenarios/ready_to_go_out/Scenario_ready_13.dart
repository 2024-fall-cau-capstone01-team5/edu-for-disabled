import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

class Scenario_ready_13_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_13_left({super.key, required this.acter});

  @override
  State<Scenario_ready_13_left> createState() => _Scenario_ready_13_leftState();
}

class _Scenario_ready_13_leftState extends State<Scenario_ready_13_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
            "그럼, 깔끔하게 씻었으니 이제 밖에 나가기 위해서 옷을 입어볼까요? "
                "오른쪽 화면을 터치해서 마음에 드는 옷과 장신구를 선택해 캐릭터를 꾸며보세요!",
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
              image: AssetImage("assets/common/living_room.png"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_ready_13_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_13_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_13_right> createState() => _Scenario_ready_13_rightState();
}

class _Scenario_ready_13_rightState extends State<Scenario_ready_13_right> {

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'wear',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'Timer exit') {
      widget.step_data.sendStepData(
          "ready_to_go 13",
          "(외출을 하기 위해 옷을 입는 상황)오른쪽 화면을 터치해서 마음에 드는 옷과 장신구를 선택해 캐릭터를 꾸며보세요",
          "정답: 선택 완료",
          "응답(선택하기): 선택 완료"
      );
      await tts.TextToSpeech(
          "참 잘했어요. "
              "앞으로 옷을 입을 땐 스스로 입는 습관을 들이는 착한 사람이 돼 보도록 해요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
            "assets/ready/dress_the_cartoon_character.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
