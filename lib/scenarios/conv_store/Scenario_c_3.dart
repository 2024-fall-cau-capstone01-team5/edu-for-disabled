import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();


class Scenario_c_3_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_c_3_left({super.key, required this.acter});

  @override
  State<Scenario_c_3_left> createState() => _Scenario_c_3_leftState();
}

class _Scenario_c_3_leftState extends State<Scenario_c_3_left> {
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
          Provider.of<Scenario_Manager>(context, listen: false).flag2 == 1
              ? Positioned.fill(
            child: Image(
              image: AssetImage("assets/convenience/편의점 카운터.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          )
              : Positioned.fill(
            child: Image(
              image: AssetImage("assets/convenience/편의점 내부 1.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_c_3_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_c_3_right({super.key, required this.step_data});

  @override
  State<Scenario_c_3_right> createState() => _Scenario_c_3_rightState();
}

class _Scenario_c_3_rightState extends State<Scenario_c_3_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "편의점 안으로 들어왔어요."
            "맛있는 음식들도 보이고 시원한 아이스크림도 보이네요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();


    await tts.TextToSpeech(
        "어서오세요. ",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech(
        "편의점 직원분께서 인사를 해 주시네요."
            "인사를 받았다면 여러분들도 똑같이 인사를 해야 해요."
            "안녕하세요!라고 씩씩하게 소리내어 직접 말해보세요. ",
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
        "convenience 3",
        "(편의점에 들어가 직원에게 인사를 하는 상황)편의점 직원분께 \"안녕하세요\" 라고 말해보세요",
        "정답: \"안녕하세요\"",
        "응답(소리내어 말하기): $answer",
      );

      await tts.TextToSpeech("참 잘했어요."
          "앞으로 편의점이나 가게에 들어갈 때 꼭 인사를 해보도록 해요.",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag2();

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
