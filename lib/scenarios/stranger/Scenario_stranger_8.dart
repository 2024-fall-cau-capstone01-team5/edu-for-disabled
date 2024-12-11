import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();

class Scenario_stranger_8_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_stranger_8_left({super.key, required this.acter});

  @override
  State<Scenario_stranger_8_left> createState() =>
      _Scenario_stranger_8_leftState();
}

class _Scenario_stranger_8_leftState extends State<Scenario_stranger_8_left> {
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
              image: AssetImage("assets/stranger/도와주는사람.png"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_stranger_8_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_stranger_8_right({super.key, required this.step_data});

  @override
  State<Scenario_stranger_8_right> createState() =>
      _Scenario_stranger_8_rightState();
}

class _Scenario_stranger_8_rightState extends State<Scenario_stranger_8_right> {
  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "여러분들은 남자분께 도움을 받았어요. 도움을 받았다면 감사의 인사를 해야\n"
            "해요. "
            "도와주신 남자분께 \"감사합니다.\" 라고 직접 소리내어 말해보세요. "
    );
    await tts.TextToSpeech("여러분들은 남자분께 도움을 받았어요."
        "도움을 받았다면 감사의 인사를 해야 해요."
        "도와주신 남자분께 감사합니다. 라고 직접 소리내어 말해보세요. ",
        "ko-KR-Wavenet-D");
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
      answer = await stt.gettext(5);
    });
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      widget.step_data.sendStepData(
        "stranger 8",
        "(도와주신 남자분께 감사의 인사를 하는 상황)도와주신 남자분께 \"감사합니다.\" 라고 말해보세요",
        "정답: \"감사합니다.\"",
        "응답(소리내어 말하기): $answer",
      );

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
              "앞으로는 감사 인사를 꼭 해보도록 해요. "
      );
      await tts.TextToSpeech(
          "참 잘했어요."
              "앞으로는 감사 인사를 꼭 해보도록 해요. ",
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
