import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();


class Scenario_ready_2_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_ready_2_left({super.key, required this.acter});

  @override
  State<Scenario_ready_2_left> createState() => _Scenario_ready_2_leftState();
}

class _Scenario_ready_2_leftState extends State<Scenario_ready_2_left> {
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
              image: AssetImage("assets/common/living_room.png"),
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

class Scenario_ready_2_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_ready_2_right({super.key, required this.step_data});

  @override
  State<Scenario_ready_2_right> createState() => _Scenario_ready_2_rightState();
}

class _Scenario_ready_2_rightState extends State<Scenario_ready_2_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
          "일어난 다음에는 부모님께 인사를 해 보도록 해요. "
            "안녕히 주무셨어요? 라고 직접 소리내어 말해보세요. ",
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
          "ready_to_go 2",
          "(부모님께 아침 인사를 하는 상황)부모님께 \"안녕히 주무셨어요?\" 라고 소리내어 말해보세요",
          "정답: \"안녕히 주무셨어요?\"",
          "응답(소리내어 말하기): $answer",
      );

      await tts.TextToSpeech("참 잘했어요."
          "앞으로는 아침에 일어난 다음에 부모님께 인사를 씩씩하게 해보도록 해요", "ko-KR-Wavenet-D");
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
