import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();


class Scenario_missing_child_7_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_7_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_7_left> createState() => _Scenario_missing_child_7_leftState();
}

class _Scenario_missing_child_7_leftState extends State<Scenario_missing_child_7_left> {
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
              image: AssetImage("assets/missing_child/가게 일러스트.png"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(
              child: widget.acter
          ),
        ],
      ),
    );
  }
}

class Scenario_missing_child_7_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_7_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_7_right> createState() => _Scenario_missing_child_7_rightState();
}

class _Scenario_missing_child_7_rightState extends State<Scenario_missing_child_7_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "직원 분께서 대답을 하시네요. 한번 들어볼까요? ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "길을 잃으셨나요? 이름이 어떻게 되시나요?",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "직원 분께서 이름을 물어봤네요 대답해 볼까요? 자기의 이름을 직접 소리내어 말해보세요 ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;


  }

  void _onRiveInit(Artboard artboard) async{
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

    setState(() async{
      answer = await stt.gettext(4);
    });

  }

  void _onStateChange(String stateMachineName, String stateName) async {

    if (stateName == 'ExitState') {
      widget.step_data.sendStepData(
        "missing_child 7",
        "(가게 점원분이 이름을 물어본 상황)가게 직원분께 자기의 이름을 직접 소리내어 말해보세요",
        "정답: \"(자기 이름)\"",
        "응답(소리내어 말하기): $answer",
      );

      await tts.TextToSpeech(
          "네. 잠시만요. 경찰서에 연락할게요.",
          "ko-KR-Wavenet-A");
      await tts.player.onPlayerComplete.first;

      await tts.TextToSpeech(
          "지금 직원분께서 경찰에 연락을 하고 계시네요. "
              "경찰은 나쁜 사람들만 잡아가는 무서운 분들이 아니에요. "
              "사람들에게 도움을 주기도 하는 착한 분들이랍니다. ",
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
