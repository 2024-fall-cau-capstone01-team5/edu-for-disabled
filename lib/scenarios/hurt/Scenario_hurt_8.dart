import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();


class Scenario_hurt_8_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_8_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_8_left> createState() => _Scenario_hurt_8_leftState();
}

class _Scenario_hurt_8_leftState extends State<Scenario_hurt_8_left> {
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
              image: AssetImage("assets/hurt/call119.webp"),
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

class Scenario_hurt_8_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_hurt_8_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_8_right> createState() => _Scenario_hurt_8_rightState();
}

class _Scenario_hurt_8_rightState extends State<Scenario_hurt_8_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
            "네, 119 구급대원입니다. 무엇을 도와드릴까요? ",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "일일구 구급대원분께서 무엇을 도와주냐고 물어봤네요. "
            "대답해 볼까요? "
            " 도와주세요! 다쳤어요!라고 직접 소리내어 말해보세요! ",
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
      answer = await stt.gettext(6);
    });

  }

  void _onStateChange(String stateMachineName, String stateName) async {

    if (stateName == 'ExitState') {
      widget.step_data.sendStepData(
        "missing_child 8",
        "(119에 전화해 도와달라고 말하는 상황)119 구급대원분께 \"도와주세요! 다쳤어요!\" 라고 말해보세요",
        "정답: \"도와주세요. 다쳤어요.\"",
        "응답(소리내어 말하기): $answer",
      );

      await tts.TextToSpeech("참 잘했어요."
          "앞으로 도움을 구할 땐 꼭 자기가 어떤 상황에 쳐해있는지 잘 설명해 보도록 해요.",
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
