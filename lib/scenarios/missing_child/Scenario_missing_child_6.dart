import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();


class Scenario_missing_child_6_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_6_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_6_left> createState() => _Scenario_missing_child_6_leftState();
}

class _Scenario_missing_child_6_leftState extends State<Scenario_missing_child_6_left> {
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
              image: AssetImage("assets/missing_child/가게 일러스트.webp"),
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

class Scenario_missing_child_6_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_6_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_6_right> createState() => _Scenario_missing_child_6_rightState();
}

class _Scenario_missing_child_6_rightState extends State<Scenario_missing_child_6_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "가게 안으로 들어왔습니다. 저기 점원 분이 보이네요. "
            "가게 직원분께 \"길을 잃었어요. 도와주세요.\" 라고 직접 소리내어 말해보세요. "
    );
    await tts.TextToSpeech(
        "가게 안으로 들어왔습니다. 저기 점원 분이 보이네요. "
            "가게 직원분께 길을 잃었어요. 도와주세요 라고 직접 소리내어 말해보세요 ",
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
        "missing_child 6",
        "(가게에 들어가 점원분께 도움을 요청하는 상황)가게 직원분께 \"길을 잃었어요. 도와주세요.\" 라고 말해보세요",
        "정답: \"길을 잃었어요. 도와주세요\"",
        "응답(소리내어 말하기): $answer",
      );

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
              "앞으로 도움을 구할 땐 꼭 자기가 어떤 상황에 처해있는지 잘 설명해 보도록 해요."
      );
      await tts.TextToSpeech("참 잘했어요."
          "앞으로 도움을 구할 땐 꼭 자기가 어떤 상황에 처해있는지 잘 설명해 보도록 해요.",
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
