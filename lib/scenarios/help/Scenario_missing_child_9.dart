import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();
final AudioPlayer _audioPlayer = AudioPlayer();

class Scenario_missing_child_9_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_9_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_9_left> createState() =>
      _Scenario_missing_child_9_leftState();
}

class _Scenario_missing_child_9_leftState
    extends State<Scenario_missing_child_9_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "축하드려요. "
            "경찰분께서 부모님에게 연락해 부모님이 찾으러 오셨습니다. "
            "정말 다행이네요. 부모님을 다시 만난 기분이 어떤가요? "
            "오른쪽 화면의 자기가 느낀 기분을 손가락으로 직접 눌러보세요! ",
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
              image: AssetImage("assets/missing_child/가게 재회.webp"),
              fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
            ),
          ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_9_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_9_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_9_right> createState() =>
      _Scenario_missing_child_9_rightState();
}

class _Scenario_missing_child_9_rightState
    extends State<Scenario_missing_child_9_right> {
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
      _trigger1 = controller.findInput<SMITrigger>('Trigger 2') as SMITrigger?;
      _trigger1 = controller.findInput<SMITrigger>('Trigger 3') as SMITrigger?;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "missing_child 9",
            "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 좋아요",
            "응답(감정 표현): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "missing_child 9",
            "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
            "정답: 좋아요",
            "응답(감정 표현): 좋아요");
      }

      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool?.value = true;
      _trigger1?.fire();
    } else if (stateName == "sad") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 9",
          "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 좋아요",
          "응답(감정 표현): 슬퍼요");
    } else if (stateName == "angry") {
      await _audioPlayer.play(AssetSource("effect_incorrect.mp3"));

      widget.step_data.sendStepData(
          "missing_child 9",
          "(부모님과 재회했을 때 감정을 선택하는 상황)오른쪽 화면의 자신의 기분을 선택해보세요.",
          "정답: 좋아요",
          "응답(감정 표현): 화나요");
    } else if (stateName == "good") {
      await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
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
