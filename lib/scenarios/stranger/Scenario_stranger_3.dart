import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:flutterpractice/scenarios/stt.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final stt = STT();

class Scenario_stranger_3_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_stranger_3_left({super.key, required this.acter});

  @override
  State<Scenario_stranger_3_left> createState() =>
      _Scenario_stranger_3_leftState();
}

class _Scenario_stranger_3_leftState extends State<Scenario_stranger_3_left> {
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

class Scenario_stranger_3_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_stranger_3_right({super.key, required this.step_data});

  @override
  State<Scenario_stranger_3_right> createState() =>
      _Scenario_stranger_3_rightState();
}

class _Scenario_stranger_3_rightState extends State<Scenario_stranger_3_right> {
  SMIBool? _bool1;
  SMIBool? _bool2;

  String answer = '';

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "저기 혹시 시간 괜찮으면 잠시 저 좀 따라올 수 있어요? "
    );
    await tts.TextToSpeech("저기 혹시 시간 괜찮으면 잠시 저 좀 따라올 수 있어요? ",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "모르는 사람이 자기를 따라오라고 하네요.\n"
            "하지만 모르는 사람을 함부로 따라가면 나쁜 일이 생길 수도 있어요. "
    );
    await tts.TextToSpeech(
        "모르는 사람이 자기를 따라오라고 하네요. "
            "하지만 모르는 사람을 함부로 따라가면 나쁜 일이 생길 수도 있어요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
            "이럴 땐 싫다고 단호하게 말해야해요.\n"
            "착하게 말하면 나쁜 사람이 떠나지 않아요. "
    );
    await tts.TextToSpeech(
            "이럴 땐 싫다고 단호하게 말해야해요. "
            "착하게 말하면 나쁜 사람이 떠나지 않아요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 지금부터 힘차게, \"싫어요!\"라고 직접 소리내어 말해보세요."
    );
    await tts.TextToSpeech(
        "그럼 지금부터 힘차게, 싫어요!라고 직접 소리내어 말해보세요.",
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
        "stranger 3",
        "(모르는 사람이 따라오라고 할 때 싫어요라고 말하는 상황)모르는 사람에게 \"싫어요\" 라고 말해보세요",
        "정답: \"싫어요\"",
        "응답(소리내어 말하기): $answer",
      );

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요. "
              "앞으로는 의사표현을 확실하게 해보도록 해요. "
      );
      await tts.TextToSpeech(
          "참 잘했어요. "
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
