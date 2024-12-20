import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final tts = TTS();

class Scenario_park_6_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_park_6_left({super.key, required this.acter});

  @override
  State<Scenario_park_6_left> createState() => _Scenario_park_6_leftState();
}

class _Scenario_park_6_leftState extends State<Scenario_park_6_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("집으로 돌아가기 전에 자기가 남긴 쓰레기를 치워봐요. ");
    await tts.TextToSpeech("집으로 돌아가기 전에 자기가 남긴 쓰레기를 치워봐요.", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("오른쪽 화면을 손가락으로 눌러보세요.\n"
            "그리고 아래로 떨어지는 쓰레기들을 눌러보세요.");
    await tts.TextToSpeech(
        "오른쪽 화면을 손가락으로 눌러보세요. "
            "그리고 아래로 떨어지는 쓰레기들을 눌러보세요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      // child: const Image(
      //   image: AssetImage("assets/park/park.webp"),
      //   fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      // ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/park/park.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_park_6_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_park_6_right({super.key, required this.step_data});

  @override
  State<Scenario_park_6_right> createState() => _Scenario_park_6_rightState();
}

class _Scenario_park_6_rightState extends State<Scenario_park_6_right> {
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, 'oceanStateMachine',
        onStateChange: _onStateChange);

    if (controller != null) {
      artboard.addController(controller);
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      widget.step_data.sendStepData(
          "park 6",
          "(공원에서 떠나기 전 자기가 남긴 쓰레기를 줍는 상황)오른쪽 화면의 쓰레기들을 손가락으로 직접 눌러보세요!",
          "정답: 미니 게임 완료",
          "응답(터치하기): 미니 게임 완료");

      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("참 잘했어요. 앞으로는 집에 가기 전에 자기가 남긴 쓰레기는\n"
              "스스로 치우는 착한 사람이 되보도록 해요.");
      await tts.TextToSpeech(
          "참 잘했어요. 앞으로는 집에 가기 전에 자기가 남긴 쓰레기는"
              "스스로 치우는 착한 사람이 되보도록 해요.",
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
                  "assets/park/garbage_collecting.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
