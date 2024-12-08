import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();

class Scenario_missing_child_8_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_8_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_8_left> createState() =>
      _Scenario_missing_child_8_leftState();
}

class _Scenario_missing_child_8_leftState
    extends State<Scenario_missing_child_8_left> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/missing_child/가게 경찰아저씨.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_8_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_8_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_8_right> createState() =>
      _Scenario_missing_child_8_rightState();
}

class _Scenario_missing_child_8_rightState
    extends State<Scenario_missing_child_8_right> {
  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("경찰분께서 도와주기 위해 오셨네요. ", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "안녕하세요. 경찰입니다. 길을 잃으셨군요. "
            "제가 도와드리겠습니다. 부모님의 전화번호가 어떻게 되시죠?",
        "ko-KR-Wavenet-C");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "경찰 분께서 부모님의 전화번호를 물어봤네요. "
            "대답해 볼까요? 부모님의 전화번호를 직접 소리내어 말해보세요 ", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
  }

  void _onRiveInit(Artboard artboard) async {
    await _playWelcomeTTS();

    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);

      _bool1 = controller.findInput<bool>('Boolean 1') as SMIBool?;
      _bool2 = controller.findInput<bool>('Boolean 2') as SMIBool?;
    }

    _bool1?.value = true;

    setState(() async {
      answer = await stt.gettext(4);
    });
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      widget.step_data.sendStepData(
        "missing_child 8",
        "(경찰분이 길을 잃은 사람이 있다는 신고를 가게 점원분에게 받고 가게를 찾아와 이용자에게 부모님의 전화번호를 물어보는 상황)경찰 분께 부모님의 전화번호를 직접 소리내어 말해보세요",
        "정답: \"(부모님의 전화번호)\"",
        "응답(소리내어 말하기): $answer",
      );

      await tts.TextToSpeech(
          "참 잘했어요. "
              "만약에 부모님의 전화번호를 모른다면 앞으로의 사고에 대비해, "
              "지금부터 꼭 외워보도록 해요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool2?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          RiveAnimation.asset(
            "assets/common/icon_recording.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          ),
        ]),
      ),
    );
  }
}
