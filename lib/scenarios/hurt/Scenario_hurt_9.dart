import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();


class Scenario_hurt_9_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_hurt_9_left({super.key, required this.acter});

  @override
  State<Scenario_hurt_9_left> createState() => _Scenario_hurt_9_leftState();
}

class _Scenario_hurt_9_leftState extends State<Scenario_hurt_9_left> {
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

class Scenario_hurt_9_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_hurt_9_right({super.key, required this.step_data});

  @override
  State<Scenario_hurt_9_right> createState() => _Scenario_hurt_9_rightState();
}

class _Scenario_hurt_9_rightState extends State<Scenario_hurt_9_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "네, 알겠습니다. 주소가 어떻게 돼시죠? ",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "일일구 구급대원분께서 주소를 물어보시네요. "
            "대답해 볼까요? "
            "여러분의 집 주소를 직접 소리내어 말해보세요! ",
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
        "missing_child 9",
        "(119에 전화해 구급 대원에게 집 주소를 말해주는 상황)119 구급대원분께 집 주소를 말해보세요",
        "정답: \"(집 주소)\"",
        "응답(소리내어 말하기): $answer",
      );

      await tts.TextToSpeech("참 잘했어요."
          "혹시 집 주소를 모른다면, 지금부터라도 사고에 대비해서 집 주소를 꼭 외워보도록 해요. ",
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
