import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();

class Scenario_stranger_5_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_stranger_5_left({super.key, required this.acter});

  @override
  State<Scenario_stranger_5_left> createState() =>
      _Scenario_stranger_5_leftState();
}

class _Scenario_stranger_5_leftState extends State<Scenario_stranger_5_left> {
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
              image: AssetImage("assets/stranger/낯선사람접근.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_stranger_5_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_stranger_5_right({super.key, required this.step_data});

  @override
  State<Scenario_stranger_5_right> createState() =>
      _Scenario_stranger_5_rightState();
}

class _Scenario_stranger_5_rightState extends State<Scenario_stranger_5_right> {
  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "낯선 사람이 여러분을 데리고 가려고 할 때 \"싫어요!\" 라고 말했는데도\n계속 데리고 가려고 하면, "
            "주변 사람들에게 도움을 요청해야 해요. "
    );
    await tts.TextToSpeech(
        "낯선 사람이 여러분을 데리고 가려고 할 때 싫어요! 라고 말했는데도 계속 데리고 가려고 하면, "
        "주변 사람들에게 도움을 요청해야 해요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
            "그대로 따라가면 큰일이 생길수도 있어요."
    );
    await tts.TextToSpeech(
        "그대로 따라가면 큰일이 생길수도 있어요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 길을 걷는 사람들도 들을 수있는 큰 목소리로\n"
            "\"도와주세요! 모르는 사람이에요!\" 라고 직접 소리내어 말해보세요."
    );
    await tts.TextToSpeech(
        "그럼 길을 걷는 사람들도 들을 수 있는 큰 목소리로, "
            "도와주세요! 모르는 사람이에요! 라고 직접 소리내어 말해보세요",
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
        "stranger 5",
        "(모르는 사람이 끌고 가려고 할 때 주변 사람들에게 도움을 요청하는 상황)주변 사람들에게 \"도와주세요! 모르는 사람이에요!\" 라고 말해보세요",
        "정답: \"싫어요\"",
        "응답(소리내어 말하기): $answer",
      );

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
              "앞으로는 의사표현을 확실하게 해보도록 해요. "
      );
      await tts.TextToSpeech(
          "참 잘했어요."
              "앞으로는 의사표현을 확실하게 해보도록 해요. ",
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
