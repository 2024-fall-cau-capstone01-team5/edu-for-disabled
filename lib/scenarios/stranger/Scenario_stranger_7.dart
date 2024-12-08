import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Scenario_stranger_7_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_stranger_7_left({super.key, required this.acter});

  @override
  State<Scenario_stranger_7_left> createState() =>
      _Scenario_stranger_7_leftState();
}

class _Scenario_stranger_7_leftState extends State<Scenario_stranger_7_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("여러분을 데리고 가려던 모르는 사람이 떠나네요. "
        "참 잘했어요. "
        "지나가던 남자분께 도움을 받았네요! "
        " 여러분을 도와주신 남자뿐께 어떤 기분이 드나요? 자기가 느끼는 기분을 오른쪽 화면에서 손가락으로 직접 눌러보세요. ",
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

class Scenario_stranger_7_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_stranger_7_right({super.key, required this.step_data});

  @override
  State<Scenario_stranger_7_right> createState() =>
      _Scenario_stranger_7_rightState();
}

class _Scenario_stranger_7_rightState extends State<Scenario_stranger_7_right> {
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
      _trigger1 = controller.findInput<bool>('Trigger 1') as SMITrigger?;
      _trigger2 = controller.findInput<bool>('Trigger 2') as SMITrigger?;
      _trigger3 = controller.findInput<SMITrigger>('Trigger 3') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "stranger 7",
            "(도움을 준 사람에게 느끼는 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 좋아요",
            "응답(감정 표현): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "stranger 7",
            "(도움을 준 사람에게 느끼는 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 좋아요",
            "응답(감정 표현): 좋아요");
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
      _trigger1?.value = true;
    } else if (stateName == "sad") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "stranger 7",
          "(도움을 준 사람에게 느끼는 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 좋아요",
          "응답(감정 표현): 슬퍼요");
    } else if (stateName == "angry") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "stranger 7",
          "(도움을 준 사람에게 느끼는 기분을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 좋아요",
          "응답(감정 표현): 화나요");
    } else if (stateName == "good") {
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
            "assets/common/emotion_good.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
