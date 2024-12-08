import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Scenario_stranger_4_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_stranger_4_left({super.key, required this.acter});

  @override
  State<Scenario_stranger_4_left> createState() =>
      _Scenario_stranger_4_leftState();
}

class _Scenario_stranger_4_leftState extends State<Scenario_stranger_4_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("괜찮아요. 잠깐이면 돼니까 따라오세요. ",
        "ko-KR-Wavenet-A");
    await tts.player.onPlayerComplete.first;

    await tts.TextToSpeech("싫어요. 라고 말했는데도 모르는 사람이 손을 잡고 여러분을 끌고 가려고 하고 있어요. "
        "이럴 때 여러분의 기분은 어떤가요? 오른쪽 화면의 자기가 느낀 기분을 손가락으로 직접 눌러보세요. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/stranger/끌고가기시도.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_stranger_4_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_stranger_4_right({super.key, required this.step_data});

  @override
  State<Scenario_stranger_4_right> createState() =>
      _Scenario_stranger_4_rightState();
}

class _Scenario_stranger_4_rightState extends State<Scenario_stranger_4_right> {
  SMITrigger? _trigger1;
  SMITrigger? _trigger2;
  SMITrigger? _trigger3;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);
      _trigger1 = controller.findInput<SMITrigger>('Trigger 1') as SMITrigger?;
      _trigger2 = controller.findInput<bool>('Trigger 2') as SMITrigger?;
      _trigger3 = controller.findInput<SMITrigger>('Trigger 3') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "stranger 4",
            "(낯선 사람이 자기를 끌고 가는 상황)오른쪽 화면에 자신의 기분을 선택해보세요.",
            "정답: 싫어요",
            "응답(감정 표현): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "stranger 4",
            "(낯선 사람이 자기를 끌고 가는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 싫어요",
            "응답(감정 표현): 싫어요");
      }

      await tts.TextToSpeech(
          "참 잘했어요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      _trigger2?.value = true;
    } else if (stateName == "good") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "stranger 4",
          "(낯선 사람이 자기를 끌고 가는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 싫어요",
          "응답(감정 표현): 좋아요");
    } else if (stateName == "fun") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "stranger 4",
          "(낯선 사람이 자기를 끌고 가는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 싫어요",
          "응답(감정 표현): 즐거워요");
    } else if (stateName == "nope") {
      await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
      await Future.delayed(Duration(seconds: 2));
      _audioPlayer.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
                  "assets/common/emotion_nope.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
